#' @title Replace Missing Values by a value
#' @param .data data frame
#' @param ... variables. If no variables were provided, the function will fill
#' in missing values for all variables.
#' @param .value value for NA be replaced by
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
