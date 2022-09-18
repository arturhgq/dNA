test_that("fill functions", {
  tibble::tibble(
    a = c(NA,2,3,NA),
    b = c(1,NA,3,3),
    group = c(1,1,2,2)
  ) -> df
  expect_equal(
    fill_by_group(df, group),
    tibble::tibble(
      a = c(2,2,3,3),
      b = c(1,1,3,3),
      group = c(1,1,2,2)
    )
  )
  expect_equal(
    fill_by_group(df, group, a),
    tibble::tibble(
      a = c(2,2,3,3),
      b = c(1,NA,3,3),
      group = c(1,1,2,2)
    )
  )
})
