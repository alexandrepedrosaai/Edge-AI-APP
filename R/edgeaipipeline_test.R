# edge_ai_pipeline_test.R
library(testthat)

predict_edge <- function(x) {
  if (x > 0.5) "active" else "inactive"
}

test_that("Edge inference works", {
  expect_equal(predict_edge(0.9), "active")
  expect_equal(predict_edge(0.1), "inactive")
})
