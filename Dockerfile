# syntax=docker/dockerfile:1

# ---- STAGE 1: Builder ----
FROM debian:bullseye-slim AS builder

RUN groupadd --gid 65532 nonroot && \
    useradd --uid 65532 --gid 65532 --shell /bin/false nonroot

RUN mkdir /hath && chown -R nonroot:nonroot /hath

# ---- STAGE 2: Final Image ----
FROM gcr.io/distroless/static-debian11

# ---- Arguments ----
ARG TARGETARCH

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder --chown=nonroot:nonroot /hath /hath

COPY --chmod=755 artifacts/hath-rust-${TARGETARCH}/hath-rust /usr/local/bin/hath-rust

# ---- Final Configuration ----
WORKDIR /hath

USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/hath-rust"]