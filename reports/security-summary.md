# Security Scan Report

Generated: $(date)

## Project Structure
- Client: $([ -d client ] && echo "✓" || echo "✗")
- Server: $([ -d server ] && echo "✓" || echo "✗")
- Backend: $([ -d backend ] && echo "✓" || echo "✗")
- Frontend: $([ -d frontend ] && echo "✓" || echo "✗")
- Azure Functions: $([ -d azure-functions ] && echo "✓" || echo "✗")
- Python: $([ -d python ] && echo "✓" || echo "✗")

## Dependencies
- package.json: $([ -f package.json ] && echo "✓" || echo "✗")
- requirements.txt: $([ -f requirements.txt ] && echo "✓" || echo "✗")
- Dockerfile: $([ -f Dockerfile ] && echo "✓" || echo "✗")

## SBOM Files Generated
$(ls -1 sbom/*.json 2>/dev/null | wc -l) SBOM files

## Scan Reports
$(ls -1 reports/ 2>/dev/null | grep -v security-summary | wc -l) report files

