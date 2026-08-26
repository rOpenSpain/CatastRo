test_that("ovcurl() returns distinct URLs for distinct service identifiers", {
  expect_snapshot(ovcurl("another"))
  expect_snapshot(ovcurl("mun"))
  expect_false(identical(ovcurl("RCCOORD"), ovcurl("RCCOOR")))
})
