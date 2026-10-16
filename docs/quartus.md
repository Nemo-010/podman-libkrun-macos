# Quartus and the architecture problem

Quartus Prime is **x86-64 Linux only**. That single fact determines everything
about where it can run, and it is worth stating plainly because it is easy to
miss.

## What Quartus supports

From Altera's own software:

- The Linux installer is an ELF x86-64 binary. The 25.1 Lite installer contains
  no `aarch64` or `arm64` payload of any kind.
- The OS support matrix lists Windows, RHEL, SUSE and Ubuntu. There is no
  macOS, Apple or Darwin entry anywhere.
- The official Altera container images (`alterafpga/quartus-*`,
  `intel/quartuspro-*`) publish `linux/amd64` only.
- Distribution packaging agrees: Arch's AUR `quartus-free` is `arch=('x86_64')`,
  and nixpkgs declares `platforms = [ "x86_64-linux" ]`.

## What that means for each layer here

| Where | Guest architecture | Can run Quartus? |
|---|---|---|
| libkrun machine on Apple Silicon | aarch64 | no |
| macOS runner in Actions | aarch64 | no |
| native x86-64 Linux | x86-64 | yes |

The libkrun provider on Apple Silicon boots an **aarch64** Linux guest, because
libkrun uses the Hypervisor framework and runs native guests. It has no x86-64
guest support. So the image in this repository is a native aarch64 image, and
Quartus cannot run in it.

This is not a limitation of the image or of the setup. There is no build of
Quartus for either aarch64 or macOS to run.

## Where Quartus is tested

`.github/workflows/test.yml` runs Quartus on `ubuntu-latest`, which is x86-64
Linux, and executes `quartus_sh`, `quartus_cpf`, `quartus_pgm` and
`jtagconfig`. That is the only platform where it can work, so it is the only
place the test can be meaningful.

## The earlier work on this

Separately, Quartus was exercised under qemu user emulation on an aarch64 host.
It can be made to start that way, but it is not a practical setup:

- `adm/qenv.sh` runs `uname -m`; anything other than `x86_64` makes it assume a
  32-bit machine and abort with "Can not run the 64-bit Quartus II software on
  a 32-bit machine."
- It then greps `/proc/cpuinfo` for `sse` and terminates when it is absent,
  which is always the case on ARM.

Both checks have to be patched, and the result is slow enough that it is not
day-to-day work. Use an x86-64 machine or a native x86-64 runner instead.

## If you need Quartus on Arm hardware

The honest options are an x86-64 host, a cloud x86-64 runner, or emulation with
the caveats above. There is no native path.
