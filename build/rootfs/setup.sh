#!/bin/bash
set -e

# Rootfs setup for fkOs
# This script bootstraps a minimal Ubuntu rootfs and installs necessary packages

ROOTFS_DIR="./rootfs"
UBUNTU_VERSION="noble"

echo "=== fkOs Rootfs Setup ==="
echo "Target directory: $ROOTFS_DIR"
echo "Ubuntu version: $UBUNTU_VERSION"
echo ""

# Create rootfs directory
echo "[1/5] Membuat direktori rootfs..."
mkdir -p "$ROOTFS_DIR"
echo "   ✓ Directory created"

# Bootstrap minimal Ubuntu
echo "[2/5] Bootstrapping minimal Ubuntu rootfs..."
debootstrap --variant=minbase "$UBUNTU_VERSION" "$ROOTFS_DIR" http://archive.ubuntu.com/ubuntu
echo "   ✓ Rootfs bootstrapped successfully"

# Configure apt sources inside rootfs
echo "[3/5] Konfigurasi apt sources di dalam rootfs..."
cat > "$ROOTFS_DIR/etc/apt/sources.list" << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
EOF
echo "   ✓ APT sources configured"

# Chroot and install packages
echo "[4/5] Menginstal paket dasar di dalam rootfs..."
chroot "$ROOTFS_DIR" /bin/bash -c "
  apt-get update
  apt-get install -y \
    systemd \
    sudo \
    wget \
    curl \
    network-manager \
    nano \
    vim \
    bash \
    coreutils \
    findutils \
    procps \
    util-linux \
    e2fsprogs \
    grep \
    sed \
    awk \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    iproute2 \
    iputils-ping \
    net-tools \
    usbutils \
    usbutils \
    pciutils \
    htop \
    less \
    moreutils
"
echo "   ✓ Packages installed successfully"

# Install additional packages for system functionality
echo "[5/5] Menginstal paket sistem tambahan..."
chroot "$ROOTFS_DIR" /bin/bash -c "
  apt-get install -y \
    linux-image-generic \
    firmware-linux \
    firmware-linux-free \
    firmware-linux-nonfree \
    console-setup \
    keyboard-configuration \
    tzdata \
    locales \
    libglib2.0-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgtk-3-0 \
    libnss3 \
    libnspr4 \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    libpulse0 \
    libjson-glib-1.0-0 \
    libsoup3-0 \
    librest-0.7-0 \
    libsoup2.4-1 \
    libsnap1 \
    libunwind8 \
    libidn2-0 \
    libidn2-0 \
    libkrb5-3 \
    liblz4-0 \
    libzstd1 \
    libjson-c5 \
    libuv1 \
    libmicrohttpd12 \
    libxml2 \
    libsqlite3-0 \
    libtinfo6 \
    libffi7 \
    libgcc-s1 \
    libstdc++6 \
    libc6
"
echo "   ✓ System packages installed"

# Create minimal fstab
echo "[6/6] Membuat fstab minimal..."
cat > "$ROOTFS_DIR/etc/fstab" << 'EOF'
# <file system> <dir> <type> <options> <dump> <pass>
UUID=rootfs / ext4 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
dev /dev devtmpfs defaults 0 0
EOF
echo "   ✓ fstab created"

echo ""
echo "=== Rootfs Setup Complete ==="
echo "Rootfs directory: $ROOTFS_DIR"
echo "Ready for ISO build."
echo ""

# Post-setup verification
echo "Verifikasi rootfs..."
ls -la "$ROOTFS_DIR/bin/" | head -5
echo "..."
ls -la "$ROOTFS_DIR/usr/bin/" | head -5