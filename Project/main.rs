use std::process::Command;
use std::path::Path;

fn main() {
    let input_file = "slides.md";
    let output_file = "output.pdf";

    // Check if input exists
    if !Path::new(input_file).exists() {
        eprintln!("Error: Markdown file not found: {}", input_file);
        return;
    }

    // Pandoc command: convert Markdown to PDF (via LaTeX)
    let status = Command::new("pandoc")
        .arg(input_file)
        .arg("-o")
        .arg(output_file)
        .arg("--pdf-engine=xelatex")
        .status();

    match status {
        Ok(s) if s.success() => {
            println!("✅ PDF generated successfully: {}", output_file);
        }
        Ok(s) => {
            eprintln!("Pandoc exited with status: {}", s);
        }
        Err(e) => {
            eprintln!("Error running Pandoc: {}", e);
        }
    }
}
