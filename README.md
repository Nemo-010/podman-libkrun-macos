# Quartus in a container

Run Quartus Prime with one command, on a Mac or on Linux.

```sh
podman run --rm -it -v "$PWD:/work" ghcr.io/nemo-010/podman-libkrun-macos:quartus
```

You get a shell with `quartus_sh`, `quartus_cpf`, `quartus_pgm` and
`jtagconfig` on `PATH`. Your directory is mounted at `/work`.

That is the whole thing. No setup, no emulator install, no virtual machine
configuration.

## On an Apple Silicon Mac

It works because Podman's macOS machine already ships `qemu-user-static-x86`
and registers the binfmt handler. The image is amd64, so Podman runs it
through emulation without being asked. Nothing to configure.

## Build it yourself

```sh
podman build -f Containerfile.quartus -t quartus .
podman run --rm -it -v "$PWD:/work" quartus
```

Useful build args:

| Arg | Default | Meaning |
|---|---|---|
| `QUARTUS_EDITION` | `lite` | `lite`, or `programmer` for a smaller image |
| `DEVICES` | `cyclone` | comma-separated device families to keep |
| `QUARTUS_VERSION` | `25.1std.0.1129` | Altera installer version |
| `BASE_IMAGE` | `debian:stable-slim` | base image |

## What is in here

| Path | What |
|---|---|
| `Containerfile.quartus` | the Quartus image |
| `.github/workflows/quartus.yml` | builds it, tests the tools, pushes to GHCR |
| `docs/quartus.md` | usage notes |
| `Containerfile` | a small generic Alpine image, unrelated to Quartus |
| `scripts/setup-macos.sh` | creates a Podman machine on macOS |
| `.github/workflows/build.yml`, `test.yml` | the generic image's CI |

## Notes

- The image is a few GB. The first pull takes a while; later runs are local.
- Emulation on Arm is slower than native x86-64. Fine for programming and
  conversion, slower for large compiles.
