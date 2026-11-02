# fkOs Roadmap

## 1. Kernel
- Base: Linux LTS (initial)
- Long-term: custom microkernel (Rust)
- Phases: LTS -> harden -> modules -> custom kernel

## 2. System
- Init: systemd
- Package manager: fkpkg (apt-based initially)
- Sandboxing: bubblewrap + seccomp
- Updates: A/B partitions, atomic rollback

## 3. UI
- Desktop: Wayland compositor (wlroots)
- Shell: fkShell (panel, launcher, notifications)
- Theme: Material You-like dynamic colors
- Accessibility first

## 4. Apps
- File manager, browser, terminal, settings, app store
- Media, image, text editor, calculator, calendar
- AI assistant integrated

## 5. Build & ISO
- WSL2 build environment
- Rootfs via debootstrap
- Kernel LTS cross-build
- GRUB2 + SquashFS ISO

## 6. AI-native
- Local LLM service
- Voice I/O
- Semantic search
- NL automation
- Privacy-first

## Milestones
- M0: Skeleton + docs
- M1: WSL2 + toolchain + LTS kernel build
- M2: Minimal rootfs + bootable ISO
- M3: Desktop shell prototype
- M4: AI services integration
- M5: Beta release
