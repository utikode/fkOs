# Rootfs for fkOs - Minimal Ubuntu LTS (noble)
# Built with debootstrap

# Base system packages
packages=(
  systemd
  sudo
  wget
  curl
  network-manager
  file-manager
  browser
  terminal
  settings
  libc6
  libstdc++6
  libc6-dev
  libc6-dev-multilib
  ca-certificates
  gnupg
  lsb-release
  python3
  python3-pip
  libssl-dev
  libelf-dev
  bison
  flex
  libzstd-dev
  m4
  debootstrap
  squashfs-tools
  grub-pc-bin
  grub-efi-amd64-bin
  xorriso
  qemu-system-x86_64
  squashfs-image-builder
)

# Install packages
apt-get update
apt-get install -y "${packages[@]}"
