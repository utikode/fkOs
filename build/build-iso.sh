#!/bin/bash
set -e

# fkOs ISO Build Script
# Combine kernel + rootfs into a bootable ISO

echo "=== fkOs ISO Build Process ==="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Step 1: Prepare rootfs (already built separately)
echo "[Step 1] Rootfs ready: ./build/rootfs"
ls -la build/rootfs/bin/ | head -5
ls -la build/rootfs/usr/ | head -5

# Step 2: Copy kernel
echo "[Step 2] Copying kernel..."
cp build/kernel-image/bzImage build/boot/vmlinuz-fkos
cp build/kernel-image/config build/kernel-config
info "Kernel copied to build/boot/vmlinuz-fkos"

# Step 3: Create initramfs with kernel driver modules
echo "[Step 3] Creating initramfs..."
cd build
chmod +x rootfs/install.sh
# Note: Actual module extraction would need kernel modules from rootfs
# For minimal setup, we use a simple initramfs approach
find rootfs -type f | cpio --quiet -H newc -o > initrd.img
cp build/kernel-image/initrd.tar.gz boot/initrd-fkos.gz 2>/dev/null || true
info "Initramfs created"

# Step 4: Create GRUB configuration
echo "[Step 4] Configuring GRUB..."
mkdir -p boot/grub
cat > boot/grub/grub.cfg << EOF
default=0
timeout=30

menuentry "fkOs" {
    linux /boot/vmlinuz-fkos root=/dev/sda1 rw
    initrd /boot/initrd-fkos.gz
}
EOF
info "GRUB config created"

# Step 5: Create SquashFS filesystem
echo "[Step 5] Creating SquashFS root filesystem..."
mkfs.squashfs squashfs fkOs.squashfs << DEPS
<none> squashfs-tools
EOF
info "SquashFS created: fkOs.squashfs"

# Step 6: Build ISO with GRUB2
echo "[Step 6] Building ISO with GRUB2..."
grub-mkrescue -o fkOs.iso \
  --euefi \
  --euefi-secure-boot \
  --euefi-cdimage \
  --no-mkrelf \
  boot/grub/
info "ISO build complete!"

echo ""
echo "=== ISO Build Complete ==="
echo "Output: fkOs.iso"
echo "Size: $(du -h fkOs.iso | cut -f1)"
echo "Path: $(pwd)/fkOs.iso"