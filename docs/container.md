# Building and running the image

The image is a plain Alpine base. It contains no qemu and no emulation setup.

## Build

```sh
podman build -t podman-libkrun-macos .
```

Add packages without editing the Containerfile:

```sh
podman build --build-arg EXTRA_PACKAGES="python3 py3-pip" -t podman-libkrun-macos .
```

Use a different base:

```sh
podman build --build-arg BASE_IMAGE=debian:stable-slim -t podman-libkrun-macos .
```

The Makefile wraps the same thing:

```sh
make build
make build EXTRA_PACKAGES="nodejs npm"
make build BASE_IMAGE=debian:stable-slim
```

## Run

```sh
podman run --rm -it podman-libkrun-macos
```

Mount a working tree:

```sh
podman run --rm -it -v "$PWD:/work" podman-libkrun-macos
```

`WORKDIR` is `/work`.

## Confirm the architecture

Everything should report the machine's native aarch64:

```sh
podman run --rm podman-libkrun-macos uname -m
```

## Pushing

```sh
podman tag podman-libkrun-macos ghcr.io/<owner>/podman-libkrun-macos:latest
podman push ghcr.io/<owner>/podman-libkrun-macos:latest
```

The GitHub Actions workflow does the same push to GHCR automatically.
