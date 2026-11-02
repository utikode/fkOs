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
echo "[1/6] Creating rootfs directory..."
mkdir -p "$ROOTFS_DIR"
echo "   ✓ Directory created"

# Bootstrap minimal Ubuntu
echo "[2/6] Bootstrapping minimal Ubuntu rootfs..."
debootstrap --variant=minbase "$UBUNTU_VERSION" "$ROOTFS_DIR" http://archive.ubuntu.com/ubuntu
echo "   ✓ Rootfs bootstrapped successfully"

# Configure apt sources inside rootfs
echo "[3/6] Configuring apt sources..."
cat > "$ROOTFS_DIR/etc/apt/sources.list" << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
EOF
echo "   ✓ APT sources configured"

# Mount proc and sys for chroot
echo "[4/6] Mounting proc/sys/dev for chroot..."
mount -t proc proc "$ROOTFS_DIR/proc" 2>/dev/null || (mkdir -p "$ROOTFS_DIR/proc" && mount -t proc proc "$ROOTFS_DIR/proc")
mount -t sysfs sys "$ROOTFS_DIR/sys" 2>/dev/null || (mkdir -p "$ROOTFS_DIR/sys" && mount -t sysfs sys "$ROOTFS_DIR/sys")
mount --bind /dev "$ROOTFS_DIR/dev" 2>/dev/null || (mkdir -p "$ROOTFS_DIR/dev" && mount --bind /dev "$ROOTFS_DIR/dev")
echo "   ✓ proc/sys/dev mounted"

# Chroot and install packages
echo "[5/6] Installing packages in rootfs..."
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
    pciutils \
    htop \
    less \
    moreutils \
    linux-image-generic \
    firmware-linux \
    firmware-linux-free
"
echo "   ✓ Packages installed successfully"

# Create minimal fstab
echo "[6/6] Creating fstab..."
cat > "$ROOTFS_DIR/etc/fstab" << 'EOF'
# <file system> <dir> <type> <options> <dump> <pass>
UUID=rootfs / ext4 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
dev /dev devtmpfs defaults 0 0
EOF
echo "   ✓ fstab created"

# Unmount proc/sys/dev
echo "Cleaning up mounts..."
umount "$ROOTFS_DIR/proc" 2>/dev/null || true
umount "$ROOTFS_DIR/sys" 2>/dev/null || true
umount "$ROOTFS_DIR/dev" 2>/dev/null || true
echo "   ✓ Mounts unmounted"

echo ""
echo "=== Rootfs Setup Complete ==="
echo "Rootfs directory: $ROOTFS_DIR"
echo "Ready for ISO build."
echo ""