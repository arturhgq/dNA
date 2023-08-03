#' @title Drop empty columns from a dataframe.
#' @description
#' This function drops empty columns from a dataframe
#' @param x dataframe
#' @export
drop_na_column = function(x) {
  x[,!sapply(x,function(var) all(is.na(var)))]
}
