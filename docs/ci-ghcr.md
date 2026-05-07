# GHCR publishing from GitHub Actions (`GHCR_PAT`)

The workflow `.github/workflows/Docker-Conteiner-env-image.yml` publishes images to GHCR.

## Why `GITHUB_TOKEN` can fail with `write_package`

Even with workflow permissions set to:

```yaml
permissions:
  contents: read
  packages: write
```

some repositories still hit:

`denied: permission_denied: write_package`

This can happen due to package-level/org-level permission constraints where the default `GITHUB_TOKEN` is not accepted for package write operations.

## Recommended fix used in this repository

Use a dedicated Personal Access Token secret (`GHCR_PAT`) for GHCR login in the workflow.

## Create the PAT

1. Go to **GitHub Settings → Developer settings → Personal access tokens**.
2. Create a token (classic) or fine-grained token that can publish packages for this repository.
3. Ensure it has:
   - `write:packages`
   - `read:packages`
   - `repo` (required if the repository/package is private)

## Add it as a repository secret

1. Open this repository in GitHub.
2. Go to **Settings → Secrets and variables → Actions**.
3. Add a new repository secret:
   - **Name**: `GHCR_PAT`
   - **Value**: your PAT value

After this, pushes to the default branch can publish to GHCR reliably, while pull requests continue to build without pushing images.
