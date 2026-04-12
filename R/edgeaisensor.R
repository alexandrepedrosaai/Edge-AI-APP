# edge_ai_sensor.R
set.seed(Sys.time())
value <- runif(1, 0, 1)
cat("Sensor Temperature => value:", value, "\n")

if (value > 0.7) {
  cat("⚠️ Alert: value above threshold!\n")
} else {
  cat("✅ Value within safe range.\n")
}
