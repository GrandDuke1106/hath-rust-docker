# syntax=docker/dockerfile:1

# ---- STAGE 1: Builder ----
# 使用一个包含完整工具链的普通 Debian 镜像作为构建环境
FROM debian:bullseye-slim AS builder

# 创建我们需要的用户和组
# distroless/static 中的 nonroot 用户 ID 和组 ID 都是 65532
RUN groupadd --gid 65532 nonroot && \
    useradd --uid 65532 --gid 65532 --shell /bin/false nonroot

# 创建工作目录，并立即将其所有权赋予 nonroot 用户
RUN mkdir /hath && chown -R nonroot:nonroot /hath


# ---- STAGE 2: Final Image ----
# 使用你的 distroless 镜像作为最终镜像
FROM gcr.io/distroless/static-debian11

# ---- Arguments ----
ARG TARGETARCH

# 从 builder 阶段复制用户和组的定义
# 这样最终镜像才能识别 nonroot 用户
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# 从 builder 阶段复制已经设置好权限的工作目录
COPY --from=builder --chown=nonroot:nonroot /hath /hath

# 复制二进制文件
COPY --chmod=755 artifacts/hath-rust-${TARGETARCH}/hath-rust /usr/local/bin/hath-rust

# ---- Final Configuration ----
# 设置工作目录
WORKDIR /hath

# 以 nonroot 用户运行
USER nonroot:nonroot

# 设置容器的入口点
ENTRYPOINT ["/usr/local/bin/hath-rust"]