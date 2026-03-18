# Security Scan Report

Generated: $(date)

## Project Structure
- Client: $([ -d client ] && echo "✓" || echo "✗")
- Server: $([ -d server ] && echo "✓" || echo "✗")
- Azure Functions: $([ -d azure-functions ] && echo "✓" || echo "✗")
- Python: $([ -d python ] && echo "✓" || echo "✗")

## Dependencies
- package.json: $([ -f package.json ] && echo "✓" || echo "✗")
- requirements.txt: $([ -f requirements.txt ] && echo "✓" || echo "✗")
- Dockerfile: $([ -f Dockerfile ] && echo "✓" || echo "✗")

## SBOM Files
$(ls -1 sbom/ 2>/dev/null | sed 's/^/- /' || echo "No SBOM files generated")

## Scan Reports
$(ls -1 reports/ 2>/dev/null | sed 's/^/- /' || echo "No scan reports generated")

