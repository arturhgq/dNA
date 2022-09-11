#' @title Replace NAs by a value
#' @description `r lifecycle::badge('stable')`
#'
#' This function replaces NAs by a value
#' @param .data data frame
#' @param ... variables. If no variables were provided, the function will fill
#' in Missing Values for all variables.
#' @param .value value for NAs be replaced by
#' @examples
#'    tibble::tibble(
#'      var1 = c(1,2,3,4, NA),
#'      var2 = c(NA, NA, NaN, 2, 3)
#'    ) -> data
#' replace_na(data, .value = 0)
#' @export
replace_na <- \(.data, ..., .value = 0) {
  length(rlang::quos(...)) -> .quos_length
  if (.quos_length == 0) {
    .data |>
      dplyr::mutate(
        dplyr::across(
          .cols = dplyr::everything(),
          ~ replace(.x, is.nan(.x), .value) |>
            replace(is.na(.x), .value)
        )
      )
  } else {
    .data |>
      dplyr::mutate(
        dplyr::across(
          .cols = c(...),
          ~ replace(.x, is.nan(.x), .value) |>
            replace(is.na(.x), .value)
        )
      )
  }
}
