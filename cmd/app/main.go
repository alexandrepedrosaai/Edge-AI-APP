package main

import (
	"fmt"

	"github.com/alexandrepedrosaai/edge-ai-app/internal/inference"
	"github.com/alexandrepedrosaai/edge-ai-app/internal/pipeline"
)

func main() {
	fmt.Println("=== Edge AI App ===")

	// Run inference demo
	samples := []float64{0.3, 0.6, 0.9}
	for _, v := range samples {
		label := inference.ClassifySensor(v)
		score := inference.NormalizeScore(v)
		fmt.Printf("Sensor: %.2f -> %s (score: %.4f)\n", v, label, score)
	}

	// Run pipeline
	pipeline.Run()
}
