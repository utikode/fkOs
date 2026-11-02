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
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check prerequisites
echo "[Step 0] Checking prerequisites..."
command -v debootstrap >/dev/null 2>&1 || error "debootstrap not found. Install with: sudo apt-get install -y debootstrap"
command -v mksquashfs >/dev/null 2>&1 || error "mksquashfs not found. Install with: sudo apt-get install -y squashfs-tools"
command -v grub-mkrescue >/dev/null 2>&1 || error "grub-mkrescue not found. Install with: sudo apt-get install -y grub-pc-bin grub-efi-amd64-bin xorriso"
command -v xorriso >/dev/null 2>&1 || error "xorriso not found. Install with: sudo apt-get install -y xorriso"

# Check kernel image
if [ ! -f "build/kernel-image/bzImage" ]; then
    error "Kernel image not found at build/kernel-image/bzImage. Download from GitHub Actions artifact first."
fi

# Step 1: Prepare rootfs
echo "[Step 1] Preparing rootfs..."
if [ ! -d "build/rootfs/bin" ]; then
    warn "Rootfs not found. Running setup-rootfs.sh..."
    chmod +x build/rootfs/setup.sh
    sudo ./build/rootfs/setup.sh
fi

# Step 2: Copy kernel
echo "[Step 2] Copying kernel..."
mkdir -p build/boot
cp build/kernel-image/bzImage build/boot/vmlinuz-fkos
info "Kernel copied to build/boot/vmlinuz-fkos"

# Step 3: Create initramfs
echo "[Step 3] Creating initramfs..."
cd build
# Create a minimal initramfs with busybox
mkdir -p initramfs/bin initramfs/dev initramfs/etc initramfs/lib initramfs/proc initramfs/sys initramfs/tmp
# Copy busybox if available in rootfs
if [ -f "rootfs/bin/busybox" ]; then
    cp rootfs/bin/busybox initramfs/bin/
    chmod +x initramfs/bin/busybox
    # Create symlinks for common commands
    for cmd in sh ls cat mount umount mkdir mknod; do
        ln -sf busybox initramfs/bin/$cmd 2>/dev/null || true
    done
fi
# Create init script
cat > initramfs/init << 'EOF'
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t devtmpfs dev /dev
echo "fkOs initramfs loaded"
exec /bin/sh
EOF
chmod +x initramfs/init
# Create cpio archive
cd initramfs
find . | cpio --quiet -H newc -o | gzip -9 > ../boot/initrd-fkos.gz
cd ..
info "Initramfs created: build/boot/initrd-fkos.gz"

# Step 4: Create GRUB configuration
echo "[Step 4] Configuring GRUB..."
mkdir -p boot/grub
cat > boot/grub/grub.cfg << 'EOF'
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
mksquashfs rootfs fkOs.squashfs -comp xz -Xbcj x86 -e boot/initrd-fkos.gz
info "SquashFS created: fkOs.squashfs"

# Step 6: Build ISO with GRUB2
echo "[Step 6] Building ISO with GRUB2..."
grub-mkrescue -o fkOs.iso \
    boot/ \
    --xorriso=/usr/bin/xorriso
info "ISO build complete!"

echo ""
echo "=== ISO Build Complete ==="
echo "Output: fkOs.iso"
echo "Size: $(du -h fkOs.iso | cut -f1)"
echo "Path: $(pwd)/fkOs.iso"
echo ""

# Verify ISO exists
if [ -f "fkOs.iso" ]; then
    echo "✅ ISO successfully created!"
    echo "Test with: qemu-system-x86_64 -cdrom fkOs.iso -boot d -m 2048"
else
    error "ISO file was not created. Check the build logs above."
fi