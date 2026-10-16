# Podman machine on macOS with libkrun

## What the provider is

`podman machine` on macOS has two providers:

| Provider | Backend |
|----------|---------|
| `libkrun` (default) | libkrun, using Apple's Hypervisor framework |
| `applehv` | Apple Virtualization framework |

libkrun is a small VMM library that uses KVM on Linux and the Hypervisor
framework (HVF) on macOS/ARM64. On Apple Silicon both providers run a native
aarch64 Linux guest, so there is no cross-architecture emulation involved in
this path. This is the Neucom Sphere approach: use the native transport rather
than layering an emulator over it.

## Requirements

- Apple Silicon (arm64). libkrun only supports Arm systems.
- macOS 14 or newer, which `krunkit` requires.
- Podman 6 or newer for `libkrun` to be the default on Macs. On Podman 5.4 to
  5.9 select it explicitly with `--provider libkrun` or
  `CONTAINERS_MACHINE_PROVIDER=libkrun`.
- `krunkit`, from the `slp/krun` Homebrew tap.

## Install krunkit

```sh
brew tap slp/krun
brew install krunkit
```

Podman looks for `krunkit` on `PATH`; that is the whole check it performs for
this provider.

## Create the machine

```sh
podman machine init --provider libkrun
podman machine start
```

Or use the script, which also installs `krunkit` if it is missing:

```sh
./scripts/setup-macos.sh
```

Resources are configurable, and the defaults are not version-pinned:

```sh
podman machine init --provider libkrun --cpus 4 --memory 4096 --disk-size 50
```

## Inspect

```sh
podman machine info
podman machine list
podman machine inspect
```

`podman machine info` reports the provider and the machine's architecture.

## Notes

- Nested virtualization is enabled by default for libkrun machines on M3 or
  newer hosts running macOS 15 or newer.
- `podman machine init --now` starts the machine immediately after creating it.
- Rosetta is not available with the libkrun provider; it is an `applehv`
  feature. If you need x86-64 binaries, that is a separate decision, not
  something this setup does for you.
