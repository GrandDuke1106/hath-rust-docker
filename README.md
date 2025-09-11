# Hath-Rust-Docker

[Docker Image](https://hub.docker.com/r/grandduke1106/hath-rust-docker)
[](https://hub.docker.com/r/grandduke1106/hath-rust-docker/tags)

This is a high-quality, secure, lightweight, and multi-platform Docker image built for the [hath-rust](https://github.com/james58899/hath-rust) application.

This image is based on Google's `distroless/static` base image, ensuring a minimal footprint. The application within the image runs as a non-root user by default, further enhancing security.

## 🚀 Quick Start

**Optional**: Create a new, unprivileged user on the host machine to avoid running as `root` or another high-privilege user.

```bash
# -m: Creates the user's home directory.
# -d: Specifies the path to the home directory.
# -s: Specifies the user's login shell.
sudo useradd -m -d /home/username -s /bin/bash username

# Switch to the new user
su - username
```

**Step 1**: Create a directory on your host machine to store `hath-rust`'s data, configurations, or logs.

```bash
mkdir -p ./hath
```

**Step 2**: Run the Docker container and mount the host directory into it.

```bash
docker run --rm -it \
  -p 8080:8080 \
  --user "$(id -u):$(id -g)" \
  -v ./hath:/hath \
  grandduke1106/hath-rust-docker:latest \
  <your-hath-rust-app-arguments>
```

### Command Breakdown

  * `--rm`: Automatically removes the container when it exits. Ideal for temporary runs and testing.
  * `-it`: Starts the container in interactive mode and allocates a pseudo-TTY. This allows you to interact directly with the application, which may be necessary for initial setup (like entering an ID and password). For background operation, you can replace `-it` with `-d`.
  * `-p 8080:8080`: Maps port `8080` on your host to port `8080` in the container. **Please change this according to the actual port used by `hath-rust`**.
  * `--user "$(id -u):$(id -g)"`: Runs the container's process with the same user and group ID as your current host user. This resolves permission issues when using mounted volumes.
  * `-v ./hath:/hath`: Mounts the `./hath` directory from your current path into the `/hath` working directory inside the container for data persistence.
  * `grandduke1106/hath-rust-docker:latest`: Specifies the image to run.
  * `<your-hath-rust-app-arguments>`: Append any command-line arguments for the `hath-rust` application here (see below).

-----

## ⚙️ Detailed Configuration

### Persistence and Permissions

To ensure that `hath-rust`'s data (e.g., configuration files, logs, databases) persists across container restarts, you need to mount a host directory to the `/hath` working directory in the container.

Because the container process runs as a non-root user by default, directly mounting a standard host directory can lead to `Permission Denied` errors. To solve this, it is highly recommended to add the `--user "$(id -u):$(id -g)"` parameter to your `docker run` command.

This ensures that the UID and GID of the container process match the UID and GID of your current host user, granting the necessary read/write permissions for the mounted directory.

### Passing Arguments to `hath-rust`

The `ENTRYPOINT` of this image is set to the `hath-rust` program. Therefore, any content you provide after the image name in the `docker run` command will be passed directly as command-line arguments to the `hath-rust` application.

**Examples:**

  * **View the application's help information:**

    ```bash
    docker run --rm grandduke1106/hath-rust-docker --help
    ```

  * **Specify a port:**

    ```bash
    docker run --it -p 8080:8080 -v ./hath:/hath --user "$(id -u):$(id -g)" grandduke1106/hath-rust-docker --port 8080
    ```

### Using Docker Named Volumes (Alternative)

If you prefer to have Docker manage the storage instead of binding it to a specific path on your host, you can use named volumes.

1.  **Create a named volume:**

    ```bash
    docker volume create hath-app-data
    ```

2.  **Start the container using the named volume:**

    ```bash
    docker run --rm -it \
      -p 8080:8080 \
      -v hath-app-data:/hath \
      grandduke1106/hath-rust-docker:latest
    ```

    When using named volumes, Docker often handles permissions automatically, so the `--user` parameter is usually not required.

## 🏷️ Image Tags

  * `latest`: Points to the most recent stable release.
  * `vX.Y.Z` (e.g., `v1.12.1`): Points to a specific release version. Recommended for production environments to ensure reproducibility.