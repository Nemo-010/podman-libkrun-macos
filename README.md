# podman-libkrun-macos

A minimal container image and setup notes for running work inside a Podman
machine on macOS backed by **libkrun**.

- `Containerfile` — a small, generic Alpine image. No qemu, no cross-arch
  emulation.
- `scripts/setup-macos.sh` — installs `krunkit` and creates the Podman machine
  on Apple Silicon.
- `docs/` — the details.
- `.github/workflows/build.yml` — builds the image and pushes it to GHCR.

In Electrosphere terms this is the Neucom approach: keep it lean and native
rather than bolting an emulator on top.

## Why this shape

On Apple Silicon, `podman machine` runs an aarch64 Linux VM, and Podman 6 and
newer default to the `libkrun` provider. libkrun talks to Apple's Hypervisor
framework directly, so the guest is native aarch64. There is no qemu and no
Rosetta in this path, which is exactly why the image here is a plain multi-arch
Alpine base with nothing architecture-specific in it.

## Quick start (macOS, Apple Silicon)

```sh
brew install podman
./scripts/setup-macos.sh

podman build -t podman-libkrun-macos .
podman run --rm -it podman-libkrun-macos
```

## Requirements

- Apple Silicon (arm64). libkrun only supports Arm systems; on Intel Macs use
  the `applehv` provider.
- macOS 14 or newer (a `krunkit` requirement).
- Podman, plus `krunkit` from the `slp/krun` Homebrew tap.

## Documentation

- [`docs/macos-libkrun.md`](docs/macos-libkrun.md) — creating the machine
- [`docs/container.md`](docs/container.md) — building and running the image
- [`docs/troubleshooting.md`](docs/troubleshooting.md) — when it goes wrong
