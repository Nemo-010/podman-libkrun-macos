#!/usr/bin/env bash
#
# Set up a Podman machine on Apple Silicon using the libkrun provider.
#
# Requires: podman, krunkit (Homebrew). No qemu is installed or used.

set -euo pipefail

MACHINE_NAME="${MACHINE_NAME:-podman-machine-default}"
CPUS="${CPUS:-4}"
MEMORY_MB="${MEMORY_MB:-4096}"
DISK_GB="${DISK_GB:-50}"

need() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "error: '$1' not found in PATH" >&2
        exit 1
    }
}

need podman

if [ "$(uname -s)" != "Darwin" ]; then
    echo "error: this script is for macOS" >&2
    exit 1
fi

if [ "$(uname -m)" != "arm64" ]; then
    echo "error: libkrun requires Apple Silicon; use --provider applehv on Intel" >&2
    exit 1
fi

# krunkit is what Podman's libkrun provider actually launches.
if ! command -v krunkit >/dev/null 2>&1; then
    echo "krunkit not found; installing from the slp/krun tap"
    need brew
    brew tap slp/krun
    brew install krunkit
fi

if podman machine inspect "$MACHINE_NAME" >/dev/null 2>&1; then
    echo "machine '$MACHINE_NAME' already exists"
else
    echo "creating machine '$MACHINE_NAME' with the libkrun provider"
    podman machine init \
        --provider libkrun \
        --cpus "$CPUS" \
        --memory "$MEMORY_MB" \
        --disk-size "$DISK_GB" \
        "$MACHINE_NAME"
fi

podman machine start "$MACHINE_NAME"
podman machine info
