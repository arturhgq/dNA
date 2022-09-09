#' @title Count Missing Values in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function counts Missing Values in a data frame
#' @param .data data frame
#' @param .format output data frame format ('longer' or 'wider')
#' @export
count_na <- function(.data, .format = "longer") {
  rlang::expr(
    . |>
      tidyr::pivot_longer(
        dplyr::everything(),
        names_to = "variable",
        values_to = "n") |>
      dplyr::arrange(dplyr::desc(n))
  ) -> .longer

  is.na(.data) |>
    tibble::as_tibble() |>
    purrr::map_df(sum) |>
    purrr::when(
      .format == "wider" ~ .,
      .format == "longer" ~ rlang::eval_tidy(.longer)
    )
}

#' @title Count Missing Values by group in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function Missing Values by group in a data frame
#' @inheritParams count_na
#' @param .vars variables to be counted.
#' If no variables were provided, the function will count Missing Values for all variables.
#' @param .group group variable
#' @export
count_group_na <- \(
  .data,
  .vars = dplyr::everything(),
  .group,
  .format = "longer"
) {

  if (missing(.group)){
    cli::cli_abort("'.group' variable must be specified")
  }
  rlang::enexpr(.group) |>
    rlang::as_label() -> .group_string

  .data|>
    dplyr::select({{.vars}}, {{.group}}) |>
    base::split(.data[[.group_string]]) |>
    purrr::imap_dfr(
      ~ count_na(.x, .format = .format) |>
        dplyr::mutate(
          {{.group}} := .y)
    ) |>
    dplyr::relocate(
      {{.group}},
      .after = dplyr::last_col()
    )

}
