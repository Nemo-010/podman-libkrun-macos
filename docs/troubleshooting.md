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

## Need x86-64 binaries

That is not this image's job. It is a native aarch64 image. If a specific
tool has no Arm build, that is a separate problem with its own trade-offs, and
you should decide on it deliberately rather than by default.
