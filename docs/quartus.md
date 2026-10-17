# Quartus, in one command

Quartus is x86-64 Linux software. That is the only thing you need to know: the
container is x86-64, and on an Apple Silicon Mac Podman runs it through
emulation automatically. There is nothing to set up.

## Run it

```sh
podman run --rm -it -v "$PWD:/work" ghcr.io/nemo-010/podman-libkrun-macos:quartus
```

You get a shell with the Quartus tools on `PATH`:

```sh
quartus_sh --version
quartus_cpf --version
quartus_pgm --version
jtagconfig --help
```

That is it. Your current directory is mounted at `/work`, which is the working
directory inside the container.

## Or build it yourself

```sh
podman build -f Containerfile.quartus -t quartus .
podman run --rm -it -v "$PWD:/work" quartus
```

Pick a different device family or edition with build args:

```sh
podman build -f Containerfile.quartus \
  --build-arg DEVICES=cyclone,cyclonev,max10 \
  --build-arg QUARTUS_EDITION=lite \
  -t quartus .
```

`QUARTUS_EDITION=programmer` builds a much smaller image if you only need
programming and conversion.

## Why it works on a Mac

Podman's machine on macOS already ships `qemu-user-static-x86` and registers
the binfmt handler, so an amd64 container runs on an arm64 VM without any
configuration. This image is amd64, so it just runs.

The one thing that needed fixing is that Quartus ships a launcher in `bin/`
which refuses to start unless the host looks like x86-64 Linux. The image puts
the real binaries directory on `PATH` instead, so you never hit that launcher.

## Not using a Mac?

Same command works on any Linux machine, with no emulation at all:

```sh
podman run --rm -it -v "$PWD:/work" ghcr.io/nemo-010/podman-libkrun-macos:quartus
```

## Notes

- The first pull is a few GB. Later runs reuse the local image.
- Emulation is slower than native. For big compiles, native x86-64 is faster.
- Quartus needs a licence for some devices; the free Lite edition covers
  Cyclone, MAX and similar families.
