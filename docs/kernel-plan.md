# Kernel Plan

## Phase A: Linux LTS (now)
- Use Linux 6.6 LTS
- Minimal config: virtio, ext4, network, DRM
- Build in WSL once ready
- Output: vmlinuz + modules

## Phase B: Custom kernel (gradual)
- Research microkernel architecture
- Prototype memory manager + scheduler in Rust
- Build minimal bootable kernel (ELF) with bootloader
- Iterative migration
