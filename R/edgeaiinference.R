# edge_ai_inference.R
predict_edge <- function(x) {
  if (x > 0.5) "active" else "inactive"
}

data <- c(0.2, 0.6, 0.8, 0.3)
for (d in data) {
  cat("Input:", d, "=> Result:", predict_edge(d), "\n")
}
