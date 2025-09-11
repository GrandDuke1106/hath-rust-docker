# Hath-Rust-Docker

[Docker镜像](https://hub.docker.com/r/grandduke1106/hath-rust-docker)
[](https://hub.docker.com/r/grandduke1106/hath-rust-docker/tags)

这是一个为 [hath-rust](https://github.com/james58899/hath-rust) 应用打造的，安全、轻量、跨平台的高质量 Docker 镜像。

本镜像基于 Google 的 `distroless/static` 基础镜像构建，确保了极小的体积。镜像内的应用默认以非 root 用户运行，进一步增强了安全性。

## 🚀 快速开始

**可选**: 新建用户，避免使用诸如root等高权限用户。
```bash
sudo useradd -m -d /home/username -s /bin/bash username
su - username
```
其中： `-m`：创建用户的主目录。 `-d`：指定用户的主目录路径。 `-s`：指定用户的 shell；并且使用`su`命令切换用户。

**第一步**: 在你的主机上创建一个目录，用于存储 `hath-rust` 的数据、配置或日志。

```bash
mkdir -p ./hath
```

**第二步**: 运行 Docker 容器，并将主机目录挂载进去。

```bash
docker run --rm -it \
  -p 8080:8080 \
  --user "$(id -u):$(id -g)" \
  -v ./hath:/hath \
  grandduke1106/hath-rust-docker:latest \
  <你的hath-rust程序参数>
```

### 命令详解

  * `--rm`: 容器停止后自动删除，适合临时运行和测试。
  * `-it`: 开启交互模式并分配一个终端，在成功输入id和密码后即可去除这个参数。
  * `-p 8080:8080`: 将你主机的 `8080` 端口映射到容器的 `8080` 端口。**请根据 `hath-rust` 实际使用的端口进行修改**。
  * `--user "$(id -u):$(id -g)"`: 让容器内的进程以你当前主机的用户身份运行，从而解决挂载目录时的权限问题。
  * `-v ./hath:/hath`: 将当前路径下的 `hath` 目录挂载到容器内的 `/hath` 工作目录，用于持久化存储数据。
  * `grandduke1106/hath-rust-docker:latest`: 指定要运行的镜像。
  * `<你的hath-rust程序参数>`: 在这里追加传递给 `hath-rust` 程序的所有命令行参数（见下文）。

-----

## ⚙️ 详细配置

### 持久化与权限

为了让 `hath-rust` 的数据（例如配置文件、日志、数据库等）在容器重启后依然存在，你需要将一个主机目录挂载到容器的 `/hath` 工作目录中。

由于容器内的进程默认以非 root 用户运行，直接挂载主机的普通目录会导致权限冲突 (`Permission Denied` 错误)。为了解决这个问题，强烈推荐在 `docker run` 命令中添加 `--user "$(id -u):$(id -g)"` 参数。

这会使容器内进程的 UID 和 GID 与你主机当前用户的 UID 和 GID 保持一致，从而确保对挂载目录拥有正常的读写权限。

### 向 `hath-rust` 传递参数

本镜像的 `ENTRYPOINT` 被设置为 `hath-rust` 程序。因此，你在 `docker run` 命令中，镜像名之后提供的任何内容都将直接作为命令行参数传递给 `hath-rust` 程序。

**示例:**

  * **查看程序帮助信息:**

    ```bash
    docker run --rm grandduke1106/hath-rust-docker --help
    ```

  * **指定端口:**
    

    ```bash
    docker run --it -p 8080:8080 -v ./hath:/hath --user "$(id -u):$(id -g)" grandduke1106/hath-rust-docker --port 8080
    ```

### 使用 Docker 命名卷 (替代方案)

如果你不希望将数据存储在主机的特定路径下，而是让 Docker 来管理，可以使用命名卷。

1.  **创建一个命名卷:**

    ```bash
    docker volume create hath-app-data
    ```

2.  **使用命名卷启动容器:**

    ```bash
    docker run --rm -it \
      -p 8080:8080 \
      -v hath-app-data:/hath \
      grandduke1106/hath-rust-docker:latest
    ```

    使用命名卷时，Docker 会自动处理权限问题，因此通常不再需要 `--user` 参数。

## 🏷️ 镜像标签

  * `latest`: 指向最新发布的稳定版本。
  * `vX.Y.Z` (例如 `v1.12.1`): 指向特定的发行版本，推荐在生产环境中使用以确保可复现性。
