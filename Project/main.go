package main

import (
    "fmt"
    "os"
    "os/exec"
)

func main() {
    // Input and output files
    inputFile := "slides.md"
    outputFile := "output.pdf"

    // Check if input exists
    if _, err := os.Stat(inputFile); os.IsNotExist(err) {
        fmt.Println("Error: Markdown file not found:", inputFile)
        return
    }

    // Pandoc command: convert Markdown to PDF (via LaTeX)
    cmd := exec.Command("pandoc", inputFile, "-o", outputFile, "--pdf-engine=xelatex")

    // Run the command
    err := cmd.Run()
    if err != nil {
        fmt.Println("Error running Pandoc:", err)
        return
    }

    fmt.Println("✅ PDF generated successfully:", outputFile)
}
