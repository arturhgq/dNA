test_that("count functions", {
  data.frame(
    var1 = c(NA, 1),
    var2 = c(NA, NA)
  ) -> df
  expect_equal(
    count_na(df),
    data.frame(
      variable = c("var2", "var1"),
      n = c(2,1)
    )
  )
})


