#!/bin/bash
set -e

# Rootfs for fkOs - Minimal Ubuntu LTS (noble)
# Includes essential packages + core applications

ROOTFS_DIR="./rootfs"
UBUNTU_VERSION="noble"

echo "=== fkOs Rootfs Setup ==="
echo "Target: $ROOTFS_DIR"
echo "Ubuntu version: $UBUNTU_VERSION"
echo ""

# Create rootfs directory
echo "[1/7] Membuat direktori rootfs..."
mkdir -p "$ROOTFS_DIR"

# Bootstrap minimal Ubuntu
echo "[2/7] Bootstrapping minimal Ubuntu rootfs..."
debootstrap --variant=minbase "$UBUNTU_VERSION" "$ROOTFS_DIR" http://archive.ubuntu.com/ubuntu

# Configure apt sources
echo "[3/7] Konfigurasi apt sources..."
cat > "$ROOTFS_DIR/etc/apt/sources.list" << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
EOF

# Install essential packages
echo "[4/7] Menginstal paket dasar..."
apt-get update
apt-get install -y \
  systemd \
  sudo \
  wget \
  curl \
  network-manager \
  file-manager \
  browser \
  terminal \
  settings \
  libc6 \
  libstdc++6 \
  libc6-dev \
  libc6-dev-multilib \
  ca-certificates \
  gnupg \
  lsb-release \
  python3 \
  python3-pip \
  libssl-dev \
  libelf-dev \
  bison \
  flex \
  libzstd-dev \
  m4 \
  debootstrap \
  squashfs-tools \
  grub-pc-bin \
  grub-efi-amd64-bin \
  xorriso \
  qemu-system-x86_64 \
  squashfs-image-builder

echo "[5/7] Membuat fstab minimal..."
cat > "$ROOTFS_DIR/etc/fstab" << 'EOF'
# <file system> <dir> <type> <options> <dump> <pass>
UUID=rootfs / ext4 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
dev /dev devtmpfs defaults 0 0
EOF

echo "[6/7] Membuat file konfigurasi..."
# Create basic systemd service files for core services
mkdir -p "$ROOTFS_DIR/etc/systemd/system"

# Systemd service for file manager (simple wrapper)
cat > "$ROOTFS_DIR/etc/systemd/system/file-manager.service" << 'EOF'
[Unit]
Description=File Manager (FKM)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/file-manager
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Systemd service for terminal (already available via terminal package)
# No additional config needed

echo "[7/7] Rootfs setup complete!"
echo ""
echo "Rootfs directory: $ROOTFS_DIR"
echo "Ready for ISO build."
