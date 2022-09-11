#' @title Count NAs in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function counts NAs in a data frame
#' @param .data data frame
#' @param .format output data frame format ('longer' or 'wider')
#' @examples
#' tibble::tibble(
#' var1 = c(1,2,3,4, NA),
#' var2 = c(NA, NA, NaN, 2, 3)
#' ) -> data
#' count_na(data)
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

#' @title Count NAs by group in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function NAs by group in a data frame
#' @inheritParams count_na
#' @param .vars variables to be counted.
#' If no variables were provided, the function will count Missing Values for all variables.
#' @param .group group variable
#' @examples
#' tibble::tibble(
#' var1 = c(1,2,3,4, NA),
#' var2 = c(NA, NA, NaN, 2, 3),
#' group = c(2010,2010,2012,2012, 2012)
#' ) -> data
#' count_group_na(data, .group = group)
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
