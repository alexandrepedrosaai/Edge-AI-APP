package main

import (
	"fmt"
)

// Exemplo de inferência em dispositivo Edge (IoT)
func edgeInference(sensorData []float64) {
	for _, v := range sensorData {
		if v > 0.7 {
			fmt.Printf("Sensor %.2f => Atividade detectada\n", v)
		} else {
			fmt.Printf("Sensor %.2f => Nenhuma atividade\n", v)
		}
	}
}

func main() {
	data := []float64{0.2, 0.75, 0.9}
	edgeInference(data)
}
