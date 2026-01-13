FROM swift:6.1-bookworm AS builder

# Build-time arguments for version information
ARG GIT_COMMIT
ARG GIT_TAG
ARG BUILD_DATE

WORKDIR /app

# Copy Package files first for better caching
COPY Package.swift Package.resolved ./

# Resolve dependencies first
RUN swift package resolve

# Copy source files
COPY Sources/ ./Sources/
COPY Tests/ ./Tests/

# Build with memory optimizations
ENV SWIFT_BUILD_FLAGS="-Xswiftc -stats-output-dir -Xswiftc /tmp/stats"
RUN ulimit -v 12582912 && \
    ulimit -m 8388608 && \
    swift build -c release --product App --static-swift-stdlib -j 1 --disable-sandbox

# Runtime stage
FROM debian:bookworm-slim

# Version information from build stage
ARG GIT_COMMIT
ARG GIT_TAG
ARG BUILD_DATE

# Set version environment variables
ENV GIT_COMMIT=${GIT_COMMIT}
ENV GIT_TAG=${GIT_TAG}
ENV BUILD_DATE=${BUILD_DATE}

# Label the image with metadata
LABEL org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.version="${GIT_TAG}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="NLF Web" \
      org.opencontainers.image.description="Neon Law Foundation Website"

# Install ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV ENV=PRODUCTION

# Copy the built executable
COPY --from=builder /app/.build/release/App /app/App

# Copy Public files (logo, etc.)
COPY Public/ /app/Public/

EXPOSE 8080

CMD ["./App"]
