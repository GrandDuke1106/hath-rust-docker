# syntax=docker/dockerfile:1

# ---- Base Image ----
# 明确使用 static 镜像，因为它不包含任何动态库，要求二进制文件是完全静态链接的
FROM gcr.io/distroless/base-debian11

# ---- Arguments ----
# Docker 会在构建时自动为这个变量填充当前的目标架构，例如 "amd64", "arm64", "arm"
ARG TARGETARCH

# 设置工作目录
WORKDIR /hath

# ---- Copy Binary ----
# 根据目标架构从构建上下文中复制对应的静态编译二进制文件
COPY artifacts/hath-rust-${TARGETARCH}/hath-rust /usr/local/bin/hath-rust

# ---- Final Configuration ----
# 以非 root 用户运行
USER nonroot:nonroot

# 设置容器的入口点
ENTRYPOINT ["hath-rust"]