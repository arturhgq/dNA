#' @title Aren't x missing elements?
#' @description `r lifecycle::badge("stable")`
#' This function indicates which elements are not missing
#' @param x an \R object to be tested
#' @export
#'
not_na <- function(x) !is.na(x)
