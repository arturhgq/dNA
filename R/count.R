#' @title Count NAs in a data frame for each variable
#' @description `r lifecycle::badge('stable')`
#'
#' This function counts NAs in a data frame for each variable
#' @param data data frame
#' @param format output data frame format ('longer' or 'wider')
#' @examples
#' tibble::tibble(
#' var1 = c(1,2,3,4, NA),
#' var2 = c(NA, NA, NaN, 2, 3)
#' ) -> data
#' count_na(data)
#' count_na(data, "wider")
#' @export
count_na <- function(data, format = "longer") {

  vars_na = sort(
    colSums(is.na(data)),
    decreasing = TRUE
  )

  switch(
    format,
    wider = data.frame(
      rbind(vars_na),
      row.names = NULL
    ),
    longer = data.frame(
      variable = names(vars_na),
      n = vars_na,
      row.names = NULL
    )
  )
}

#' @title Count NAs by group in a data frame
#' @description `r lifecycle::badge('stable')`
#'
#' This function NAs by group in a data frame
#' @inheritParams count_na
#' @param vars variables to be counted.
#' If no variables were provided, the function will count Missing Values for all variables.
#' @param group group variable
#' @note Expected new features
#' Allowing more than one group variable.
#' @examples
#' tibble::tibble(
#' var1 = c(1,2,3,4, NA),
#' var2 = c(NA, NA, NaN, 2, 3),
#' group = c(2010,2010,2012,2012, 2012)
#' ) -> data
#' count_group_na(data, group = group)
#' @export
count_group_na <- \(
  data,
  vars = dplyr::everything(),
  group,
  format = "longer"
) {

  if (missing(group)){
    cli::cli_abort("'group' variable must be specified")
  }
  rlang::enexpr(group) |>
    rlang::as_label() -> group_string

  data|>
    dplyr::select({{vars}}, {{group}}) |>
    base::split(data[[group_string]]) |>
    purrr::imap_dfr(
      ~ count_na(.x, format = format) |>
        dplyr::mutate(
          {{group}} := .y)
    ) |>
    dplyr::relocate(
      {{group}},
      .after = dplyr::last_col()
    )
}
