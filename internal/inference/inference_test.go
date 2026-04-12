package inference

import "testing"

func TestClassifySensor(t *testing.T) {
	tests := []struct {
		value    float64
		expected string
	}{
		{0.9, "Alerta"},
		{0.6, "Normal"},
		{0.3, "Baixo"},
	}
	for _, tt := range tests {
		got := ClassifySensor(tt.value)
		if got != tt.expected {
			t.Errorf("ClassifySensor(%.1f) = %q, want %q", tt.value, got, tt.expected)
		}
	}
}

func TestNormalizeScore(t *testing.T) {
	score := NormalizeScore(0.0)
	if score < 0.49 || score > 0.51 {
		t.Errorf("NormalizeScore(0.0) = %f, want ~0.5", score)
	}
}
