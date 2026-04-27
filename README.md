# kubectl

Minimal, multi-architecture kubectl image for Kubernetes operations. Production-ready with focus on simplicity, security, and transparency.

## Features

- ✅ **Minimal Size** — 102MB Alpine-based image
- ✅ **Always Latest** — Tracks stable kubectl releases automatically
- ✅ **Multi-arch support** — linux/amd64, linux/arm64
- ✅ **Security hardened** — Non-root user (UID 1001), minimal packages
- ✅ **Signed images** — Cosign keyless signing
- ✅ **SBOM included** — CycloneDX format
- ✅ **SHA256 verified** — kubectl binary integrity check

## Quick Start

### Docker

```bash
# Pull latest
docker pull docker.io/helmforge/kubectl:latest

# Check version
docker run --rm helmforge/kubectl:latest version --client

# Use with kubeconfig
docker run --rm -v ~/.kube:/home/kubectl/.kube:ro \
  helmforge/kubectl:latest get pods
```

### Kubernetes Job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: kubectl-job
spec:
  template:
    spec:
      serviceAccountName: kubectl-sa
      containers:
      - name: kubectl
        image: docker.io/helmforge/kubectl:latest
        command: ["kubectl", "get", "pods", "-A"]
      restartPolicy: Never
```

### Kubernetes CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: kubectl-backup
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: kubectl-sa
          containers:
          - name: kubectl
            image: docker.io/helmforge/kubectl:latest
            command:
            - /bin/bash
            - -c
            - |
              kubectl get all -A -o yaml > /backup/cluster-backup.yaml
          restartPolicy: OnFailure
```

## Tags

Both tags are automatically generated on every build:

- `latest` — Always tracks latest stable kubectl release
- `<version>` — Specific kubectl version (e.g., `1.35.3`)

**Example:**
```bash
# Always get the latest
docker pull helmforge/kubectl:latest

# Pin to specific version
docker pull helmforge/kubectl:1.35.3
```

Both tags point to the same image digest and are updated together when kubectl releases a new stable version.

## Updating to Latest kubectl

The image automatically updates when:
- New commits are pushed to `main` branch
- Manually triggered via GitHub Actions

**To force an update to the latest kubectl stable release:**

1. Go to: https://github.com/helmforgedev/kubectl/actions/workflows/build.yaml
2. Click "Run workflow" → Select `main` branch → Click "Run workflow"
3. The workflow will detect the latest kubectl stable version and rebuild the image

This triggers a new build with the current stable kubectl release, updating both `:latest` and `:X.Y.Z` tags.

## Building Locally

```bash
docker build -t kubectl:local .
docker run --rm kubectl:local version --client
```

## Security

- **Non-root user** — Runs as kubectl (UID/GID: 1001)
- **Minimal base** — Alpine Linux 3.22 (~8MB)
- **Security updates** — Applied during build
- **Image signing** — Cosign keyless signing
- **SBOM** — CycloneDX format included
- **Binary verification** — SHA256 checksum validation
- **No secrets** — No credentials or tokens in image

## Technical Details

| Specification | Value |
|--------------|-------|
| **Image Size** | 102 MB |
| **Base Image** | Alpine Linux 3.22 |
| **Base OS Size** | ~8 MB |
| **kubectl Version** | Latest stable (auto-updated) |
| **Current Version** | v1.35.3 |
| **Kustomize** | v5.7.1 |
| **Architectures** | linux/amd64, linux/arm64 |
| **User** | kubectl (UID/GID 1001) |
| **Shell** | bash |
| **Libc** | musl |

## Use Cases

**Ideal for:**
- ✅ Kubernetes CronJobs and Jobs
- ✅ CI/CD pipelines
- ✅ GitOps workflows
- ✅ Backup and maintenance tasks
- ✅ Cluster administration scripts
- ✅ Size-conscious deployments

**Benefits:**
- **Minimal footprint** → Faster pulls, lower storage costs
- **Auto-update** → Always tracks latest stable kubectl
- **Security-first** → Non-root, minimal packages, signed images
- **Production-ready** → Full kubectl + kustomize functionality

## Verifying Image Signatures

Images are signed with Cosign using keyless signing:

```bash
# Install cosign
# https://docs.sigstore.dev/cosign/installation/

# Verify signature
cosign verify \
  --certificate-identity-regexp=https://github.com/helmforgedev/kubectl \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  docker.io/helmforge/kubectl:latest
```

## SBOM (Software Bill of Materials)

SBOM is generated with Trivy in CycloneDX format and available as workflow artifact:

```bash
# View SBOM with trivy
trivy image --format cyclonedx docker.io/helmforge/kubectl:latest
```

## Support

- **Issues**: https://github.com/helmforgedev/kubectl/issues
- **kubectl Docs**: https://kubernetes.io/docs/reference/kubectl/
- **Kubernetes Docs**: https://kubernetes.io/docs/

## License

Apache-2.0 - see [LICENSE](LICENSE)

---

**Maintained by**: [HelmForge Team](https://helmforge.dev)
