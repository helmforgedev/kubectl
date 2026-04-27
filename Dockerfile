# syntax=docker/dockerfile:1

# ==============================================================================
# Minimal kubectl image - Alpine-based
# ==============================================================================
FROM alpine:3.22 AS base

# Install ca-certificates and bash for better compatibility
RUN apk add --no-cache \
    ca-certificates \
    bash \
    curl \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 kubectl && \
    adduser -u 1001 -G kubectl -s /bin/bash -D kubectl

# ==============================================================================
# Download kubectl
# ==============================================================================
FROM base AS download

ARG TARGETARCH
ARG KUBECTL_VERSION

# Download kubectl (use provided version or fetch latest stable)
RUN if [ -z "$KUBECTL_VERSION" ]; then \
        KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt); \
    fi && \
    echo "Downloading kubectl ${KUBECTL_VERSION} for ${TARGETARCH}" && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c - && \
    chmod +x kubectl && \
    ./kubectl version --client

# ==============================================================================
# Production image
# ==============================================================================
FROM base AS production

# Security labels
LABEL org.opencontainers.image.title="kubectl" \
      org.opencontainers.image.description="Minimal kubectl image for Kubernetes operations" \
      org.opencontainers.image.vendor="HelmForge" \
      org.opencontainers.image.authors="HelmForge Team" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/helmforgedev/kubectl"

# Copy kubectl binary
COPY --from=download --chown=kubectl:kubectl /kubectl /usr/local/bin/kubectl

# Create .kube directory
RUN mkdir -p /home/kubectl/.kube && \
    chown -R kubectl:kubectl /home/kubectl

# Switch to non-root user
USER kubectl:kubectl
WORKDIR /home/kubectl

# Default command
ENTRYPOINT ["kubectl"]
CMD ["version", "--client"]
