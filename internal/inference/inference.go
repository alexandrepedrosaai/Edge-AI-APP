package inference

import "math"

// ClassifySensor classifies a sensor reading into alert levels.
func ClassifySensor(value float64) string {
	if value > 0.8 {
		return "Alerta"
	} else if value > 0.5 {
		return "Normal"
	}
	return "Baixo"
}

// NormalizeScore normalises a value using a sigmoid function.
func NormalizeScore(value float64) float64 {
	return 1.0 / (1.0 + math.Exp(-value))
}
