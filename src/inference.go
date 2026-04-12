package main

import (
	"fmt"
	"math"
)

// Exemplo simples de inferência: classificação de valores de sensor
func classifySensor(value float64) string {
	if value > 0.8 {
		return "Alerta"
	} else if value > 0.5 {
		return "Normal"
	}
	return "Baixo"
}

func main() {
	samples := []float64{0.3, 0.6, 0.9}
	for _, v := range samples {
		fmt.Printf("Valor %.2f => Classe: %s\n", v, classifySensor(v))
	}
}
