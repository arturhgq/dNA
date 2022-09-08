#' @title Count Missing Values in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function counts Missing Values in a data frame
#' @param .data data frame
#' @param .format output data frame format ('longer' or 'wider')
#' @export
count_na <- \(.data, .format = "longer") {
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


