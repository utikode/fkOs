# /proc/ Not Mounted Warning - Explanation and Fix

## What the Warning Means

When the GitHub Actions workflow runs:
```bash
sudo chroot /tmp/fkos-rootfs /bin/bash -c "apt-get update && apt-get install -y linux-image-generic systemd"
```

The chroot environment doesn't have `/proc/`, `/sys/`, and `/dev/` mounted. This causes the warning:
```
⚠️ /proc/ is not mounted. This is not a supported mode of operation. Please fix your invocation environment to mount /proc/ and /sys/ properly. Proceeding anyway. Your mileage may vary.
```

This is a **warning, not a fatal error**. The packages still install, but systemd configuration may be incomplete because systemd services try to start during package installation but can't without /proc/ mounted.

## Why the ISO Build "Succeeded" but No ISO Was Created

The workflow on GitHub still has the **original placeholder steps**:

```yaml
- name: Build ISO (placeholder)
  run: |
    echo "ISO build steps go here"
    # TODO: implement full ISO creation with GRUB + squashfs
```

This just echoes text and succeeds (exit code 0). Then the upload step tries to upload `fkOs.iso` but finds nothing:
```
##[warning]No files were found with the provided path: fkOs.iso. No artifacts will be uploaded.
```

## How to Fix

### Option 1: Create a new GitHub PAT with workflow scope

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with `repo` AND `workflow` scopes
3. Use this new token to push the updated workflow file

### Option 2: Add the workflow file manually via GitHub web interface

1. Go to https://github.com/utikode/fkOs
2. Click "Add file" → "Create new file"
3. Name the file: `.github/workflows/build-iso.yml`
4. Copy the content below into the editor
5. Commit the file

## Updated Workflow Content

Copy this into `.github/workflows/build-iso.yml`:

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

      - name: Setup rootfs
        run: |
          chmod +x build/rootfs/setup.sh
          sudo ./build/rootfs/setup.sh

      - name: Build ISO
        run: |
          chmod +x build/build-iso.sh
          sudo ./build/build-iso.sh

      - name: Upload ISO
        uses: actions/upload-artifact@v4
        with:
          name: fkOs-iso
          path: fkOs.iso
```

## What the Updated Workflow Does

1. **Checkout**: Gets the fkOs repository code
2. **Install dependencies**: Installs debootstrap, squashfs-tools, grub, xorriso, etc.
3. **Download kernel artifact**: Gets the bzImage from the kernel build workflow
4. **Setup rootfs**: Runs setup.sh which:
   - Creates minimal Ubuntu rootfs with debootstrap
   - Mounts /proc, /sys, /dev in chroot (fixes the /proc warning)
   - Installs packages via chroot (now properly mounted)
   - Creates fstab
   - Unmounts proc/sys/dev
5. **Build ISO**: Runs build-iso.sh which:
   - Checks prerequisites
   - Copies kernel to build/boot/vmlinuz-fkos
   - Creates initramfs
   - Creates GRUB config
   - Creates SquashFS filesystem
   - Builds ISO with GRUB2
6. **Upload ISO**: Uploads fkOs.iso as an artifact

## After Adding the Workflow

1. Go to GitHub → Actions → "Build fkOs ISO"
2. Click "Run workflow"
3. Wait for the build to complete (~20-30 minutes)
4. Download the fkOs-iso artifact

## Notes

- The /proc/ not mounted warning will be fixed because setup.sh now mounts /proc, /sys, /dev before chroot
- The ISO will actually be built now because build-iso.sh is executed
- The kernel artifact (bzImage) will be downloaded from the kernel build workflow
