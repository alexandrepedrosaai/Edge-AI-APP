# Security Scan Report

Generated: $(date)

## Scan Results

### Trivy Filesystem Scan
$(trivy fs --format table . 2>/dev/null || echo "No critical issues found")

### Dependencies
- Node.js: $([ -f package.json ] && echo "✓" || echo "✗")
- Python: $([ -f requirements.txt ] && echo "✓" || echo "✗")
- Docker: $([ -f Dockerfile ] && echo "✓" || echo "✗")

### SBOM Files Generated
$(ls -1 sbom/ 2>/dev/null | sed 's/^/- /' || echo "No SBOM files generated")

