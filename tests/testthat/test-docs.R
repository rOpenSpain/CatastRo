test_that("OVC documentation URLs differ by service identifier", {
  expect_snapshot(ovcurl("another"))
  expect_snapshot(ovcurl("mun"))
  expect_false(identical(ovcurl("RCCOORD"), ovcurl("RCCOOR")))
})
