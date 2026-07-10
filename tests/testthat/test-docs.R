test_that("Test docs", {
  expect_snapshot(ovcurl("another"))
  expect_snapshot(ovcurl("mun"))
  expect_false(identical(ovcurl("RCCOORD"), ovcurl("RCCOOR")))
})
