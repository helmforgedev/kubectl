# kubectl

Minimal, multi-architecture kubectl image for Kubernetes operations. Alternative to bitnami/kubectl with focus on simplicity, security, and transparency.

## Features

- ✅ **Always Latest** — Tracks stable kubectl releases automatically
- ✅ **Minimal Size** — Alpine-based, ~50MB total
- ✅ **Multi-arch support** — linux/amd64, linux/arm64
- ✅ **Security hardened** — Non-root user, minimal image
- ✅ **Signed images** — Cosign keyless signing
- ✅ **SBOM included** — Software Bill of Materials

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

- `latest` — Always tracks latest stable kubectl release
- `<version>` — Specific kubectl version (e.g., `1.32.0`)

## Building Locally

```bash
docker build -t kubectl:local .
docker run --rm kubectl:local version --client
```

## Security

- Non-root user (UID/GID: 1001)
- Minimal Alpine Linux 3.22
- Security updates applied
- Images signed with Cosign
- SBOM included
- SHA256 verification of kubectl binary

## Comparison with bitnami/kubectl

| Feature | helmforge/kubectl | bitnami/kubectl |
|---------|-------------------|-----------------|
| Base Image | Alpine 3.22 | Debian 12 |
| Image Size | ~50MB | ~300MB |
| Multi-arch | ✅ amd64, arm64 | ✅ amd64, arm64 |
| Signed | ✅ Cosign | ✅ Cosign |
| SBOM | ✅ CycloneDX | ✅ SPDX |
| Non-root | ✅ UID 1001 | ✅ UID 1001 |
| Auto-update | ✅ Always latest | ⚠️ Manual tags |

## Support

- **Issues**: https://github.com/helmforgedev/kubectl/issues
- **kubectl Docs**: https://kubernetes.io/docs/reference/kubectl/

## License

MIT License - see [LICENSE](LICENSE)

---

**Maintained by**: [HelmForge Team](https://helmforge.dev)
