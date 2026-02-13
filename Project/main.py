import subprocess
import os

def main():
    input_file = "slides.md"
    output_file = "output.pdf"

    # Check if input exists
    if not os.path.exists(input_file):
        print(f"Error: Markdown file not found: {input_file}")
        return

    # Pandoc command: convert Markdown to PDF (via LaTeX)
    try:
        subprocess.run(
            ["pandoc", input_file, "-o", output_file, "--pdf-engine=xelatex"],
            check=True
        )
        print(f"✅ PDF generated successfully: {output_file}")
    except subprocess.CalledProcessError as e:
        print("Error running Pandoc:", e)

if __name__ == "__main__":
    main()
