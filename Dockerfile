# ----------------------------
# Builder stage
# ----------------------------
FROM ubuntu:resolute AS builder

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    xz-utils \
    tar \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download the WSL image
RUN curl -L -o resolute.wsl \
    https://cdimage.ubuntu.com/ubuntu-wsl/daily-live/20260420/resolute-wsl-amd64.wsl

# Extract it (WSL images are typically tar-based archives)
RUN mkdir rootfs && \
    tar -xf resolute.wsl -C rootfs

# ----------------------------
# Final stage (minimal root filesystem)
# ----------------------------
FROM scratch

# Copy extracted root filesystem
COPY --from=builder /build/rootfs/ /

# Optional: ensure a shell entrypoint (if present in the WSL image)
CMD ["/bin/bash"]
