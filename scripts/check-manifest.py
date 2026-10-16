#!/usr/bin/env python3
"""Assert the published image carries the architectures we expect."""

import json
import sys


def main() -> int:
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <manifest.json>", file=sys.stderr)
        return 2

    with open(sys.argv[1], encoding="utf-8") as handle:
        index = json.load(handle)

    platforms = sorted(
        m["platform"]["architecture"] for m in index.get("manifests", [])
    )
    print("published architectures:", platforms)

    missing = {"amd64", "arm64"} - set(platforms)
    if missing:
        print(f"missing architectures: {sorted(missing)}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
