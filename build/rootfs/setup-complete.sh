#!/bin/bash
set -e

# fkOs Rootfs Setup - Complete Build
# Combines base system + core apps + desktop UI

ROOTFS_DIR="./rootfs"
UBUNTU_VERSION="noble"

echo "=== fkOs Complete Rootfs Setup ==="

# Step 1: Base system
echo "[Step 1] Base system setup..."
./build/rootfs/setup.sh

# Step 2: Core apps
echo "[Step 2] Core apps installation..."
./build/apps/install-core.sh

# Step 3: Desktop UI
echo "[Step 3] Desktop UI setup..."
./build/ui/setup.sh

echo ""
echo "=== fkOs Rootfs Complete ==="
echo "All components installed:"
echo "  - Base system: Ubuntu noble"
echo "  - Core apps: file-manager, browser, terminal, settings, fkai"
echo "  - Desktop UI: shell, panel, launcher, theme"
echo ""
echo "Ready for ISO build!"