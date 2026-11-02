#!/usr/bin/env bash
set -euo pipefail

# Build Linux LTS kernel for fkOs (WSL environment)
KERNEL_VERSION="6.6"  # LTS
SRC_DIR="$HOME/src/linux-$KERNEL_VERSION"
OUT_DIR="$(pwd)/out/kernel"

mkdir -p "$OUT_DIR"
echo "TODO: download kernel source, apply fkOs config, build"
