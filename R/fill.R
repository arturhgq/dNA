#' @title Fill in missing values within groups
#' @description `r lifecycle::badge('stable')`
#'
#' This function fills in missing values within groups
#' @param .data data frame
#' @param .group group variable
#' @param ... variables to be filled.
#' If no variables were provided, the function will fill in missing values for
#' all variables.
#' @examples
#'  data.frame(
#'    var1 = c(NA,2,3,NA),
#'    var2 = c(NA,NA,3,3),
#'    var3 = c(NA,1,3,3),
#'    var4 = c(10,NA, 2,NA),
#'    group = c(1,1,2,2)
#'  ) -> data
#'
#'  fill_by_group(data, group, var1, var3)
#' @export
fill_by_group <- function(.data, .group, ...) {

  rlang::enquo(.group) -> .group_enquo
  rlang::enquos(...) |>
    length() -> .vars_length

  .data |>
    dplyr::group_by({{.group}}) -> data

  if (.vars_length != 0) {
    data |>
      dplyr::summarise(
        dplyr::across(
          .cols = c(...),
          ~ dplyr::n_distinct(
            na.omit(.x)
          )
        )
      ) -> .group_values
  } else {
    data |>
      dplyr::summarise(
        dplyr::across(
          .cols = dplyr::everything(),
          ~ dplyr::n_distinct(
            na.omit(.x)
          )
        )
      ) -> .group_values
  }

  .group_values |>
    tidyr::pivot_longer(
      cols = - {{.group}},
      names_to = "vars",
      values_to = "values"
    ) -> .group_values

  unique(.group_values[["values"]]) -> .group_values_unique

  if (any(.group_values_unique > 1)) {
    .group_values |>
      dplyr::filter(values > 1) |>
      dplyr::group_by({{.group}}) |>
      dplyr::summarise(
        values_collapsed = glue::glue_collapse(values, sep = ", ", last = " and "),
        values_collapsed_group = paste0(values, " (", {{.group}}, ")"),
        .groups = "drop"
      ) |>
      dplyr::pull(values_collapsed_group) |>
      glue::glue_collapse(sep = ", ", last = " and ") -> .message
    cli::cli_abort(
      c(
        "x" = "There is more than one unique value in some groups.",
        "See the list of unique values per group that need manual correction:",
        "{(.message)}"
      )
    )
  } else {
    if (.vars_length != 0) {
      data |>
        tidyr::fill(..., .direction = "updown") |>
        dplyr::ungroup()
    } else {
      data |>
        tidyr::fill(-{{.group}}, .direction = "updown") |>
        dplyr::ungroup()
    }
  }
}
