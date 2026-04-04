package main

import (
	"crypto/sha256"
	"fmt"
	"io/ioutil"
)

// Função utilitária para gerar SHA256 de um arquivo
func generateSHA256(path string) string {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return fmt.Sprintf("Erro: %v", err)
	}
	hash := sha256.Sum256(data)
	return fmt.Sprintf("%x", hash)
}
