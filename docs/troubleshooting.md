# Troubleshooting

## `podman machine init` says the provider is unsupported

`libkrun` is only selectable on Darwin/arm64. On Intel Macs use
`--provider applehv`.

## `podman machine start` fails immediately

Check that `krunkit` is on `PATH`:

```sh
command -v krunkit
```

Podman's libkrun provider requires it. Install it with:

```sh
brew tap slp/krun
brew install krunkit
```

## The machine is on the wrong provider

`podman machine init --provider libkrun` fixes new machines. For the default,
set it in `containers.conf`:

```ini
[machine]
provider = "libkrun"
```

Or per-invocation with `CONTAINERS_MACHINE_PROVIDER=libkrun`.

## Container reports the wrong architecture

It should match the machine. Check both:

```sh
podman machine info
podman run --rm podman-libkrun-macos uname -m
```

## Slow first `podman build`

The first build downloads the base image. Later builds reuse the layer cache.

## `podman machine init --provider libkrun` fails with "krunkit exited unexpectedly"

On a machine that is itself a VM, nested virtualization is unavailable and
libkrun cannot start. This is the expected result on GitHub-hosted macOS
runners, which are VMs.

Check whether you are inside a VM:

```sh
sysctl -n kern.hv_vmm_present
```

`1` means a hypervisor is already present above you. GitHub's macOS runners
report `1`, and `machdep.cpu.brand_string` reads `Apple M1 (Virtual)`.

GitHub documents this: nested virtualization is not supported on arm64 macOS
runners. The request to support Hypervisor.framework there
(`actions/runner-images#13505`) was closed as not planned.

On real Apple Silicon hardware the same command works normally.

## Quartus will not run here

That is expected. Quartus is x86-64 Linux only, and the libkrun machine on
Apple Silicon is aarch64. See [`quartus.md`](quartus.md).

## `bad substitution` in a workflow

macOS runners ship bash 3.2, which does not support `${VAR,,}` or other bash 4
parameter expansions. Use `tr` instead:

```sh
repo=$(printf '%s' "$GITHUB_REPOSITORY" | tr '[:upper:]' '[:lower:]')
```

## `Need x86-64 binaries`

That is not this image's job. It is a native aarch64 image. If a specific
tool has no Arm build, that is a separate problem with its own trade-offs, and
you should decide on it deliberately rather than by default.
