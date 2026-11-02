# fkOs ISO Build Guide

## Overview
Build a bootable fkOs ISO using GitHub Actions (recommended since WSL is slow on your laptop).

## Prerequisites
- Ubuntu LTS runner (GitHub Actions)
- debootstrap, squashfs-tools, grub-pc-bin, grub-efi-amd64-bin, xorriso, qemu-system-x86_64

## Build Steps

### Step 1: Create Rootfs

Run `fkOs/build/rootfs/setup.sh` to create minimal Ubuntu rootfs:

```bash
cd fkOs
chmod +x build/rootfs/setup.sh
sudo ./build/rootfs/setup.sh
```

This will:
1. Bootstrap Ubuntu noble with debootstrap (minimal base)
2. Install essential packages (systemd, sudo, network tools, Python, etc.)
3. Configure apt sources
4. Create fstab
5. Output rootfs directory

### Step 2: Build ISO

Run `fkOs/build/build-iso.sh`:

```bash
cd fkOs
chmod +x build/build-iso.sh
sudo ./build/build-iso.sh
```

This will:
1. Copy kernel from `build/kernel-image/bzImage` to `build/boot/vmlinuz-fkos`
2. Create initramfs from rootfs
3. Create GRUB config
4. Create SquashFS filesystem
5. Build ISO with GRUB2

### Step 3: Test with QEMU

```bash
qemu-system-x86_64 -cdrom fkOs.iso -boot d -m 2048
```

## Directory Structure After Build

```
fkOs/
├── build/
│   ├── kernel-image/
│   │   └── bzImage              # Kernel (built via GitHub Actions)
│   ├── rootfs/                  # Rootfs (created via setup.sh)
│   ├── boot/
│   │   ├── vmlinuz-fkos         # Kernel copy
│   │   └── initrd-fkos.gz       # Initramfs
│   ├── grub.cfg                 # GRUB config
│   ├── fkOs.squashfs            # SquashFS filesystem
│   └── fkOs.iso                 # Final ISO
├── docs/
│   └── github-iso-build.md      # This guide
└── fkOs_ROADMAP.md              # Roadmap
```

## GitHub Actions Workflow

Create `.github/workflows/build-iso.yml`:

```yaml
name: Build fkOs ISO

on:
  workflow_dispatch:

jobs:
  build-iso:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y debootstrap squashfs-tools \
            grub-pc-bin grub-efi-amd64-bin xorriso \
            qemu-system-x86_64 mtools dosfstools

      - name: Download kernel artifact
        uses: actions/download-artifact@v4
        with:
          name: fkOs-kernel
          path: build/kernel-image/

      - name: Create rootfs
        run: |
          chmod +x build/rootfs/setup.sh
          sudo ./build/rootfs/setup.sh

      - name: Build ISO
        run: |
          chmod +x build/build-iso.sh
          sudo ./build/build-iso.sh

      - name: Upload ISO artifact
        uses: actions/upload-artifact@v4
        with:
          name: fkOs-iso
          path: fkOs.iso
```

## Notes

- Rootfs creation takes 5-10 minutes depending on network speed
- ISO build takes 5-15 minutes
- Total GitHub Actions build time: ~20 minutes
- All packages installed in rootfs are minimal for fast boot

## Troubleshooting

| Issue | Solution |
|-------|----------|
| debootstrap failed | Check network connectivity |
| GRUB install failed | Ensure mtools and dosfstools are installed |
| ISO won't boot in QEMU | Check grub.cfg paths and initramfs |
