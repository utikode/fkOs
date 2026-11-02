# fkOs

Modern AI-native operating system. Target: better than Windows 11 in speed, security, and AI integration.

## Overview

fkOs is a modern operating system designed for the AI era, built on Linux LTS kernel with a custom desktop environment, integrated AI assistant, and privacy-first design.

## Project Status

- ✅ Kernel built (Linux LTS 6.12.43)
- ✅ Rootfs setup scripts created
- ✅ Core apps (File Manager, Browser, Terminal, Settings, AI Assistant) implemented
- ✅ Desktop UI (Shell, Panel, Launcher, Theme) created
- ⚠️ ISO build in progress (via GitHub Actions)
- 🔄 System, UI, Apps, and AI features under development

## Structure

```
fkOs/
├── kernel/          # Kernel & drivers
├── system/          # Services, package manager, init
├── ui/              # Compositor, desktop shell
├── apps/            # Built-in applications
├── build/           # ISO & image build scripts
│   ├── kernel-image/  # Kernel artifact (bzImage)
│   ├── rootfs/      # Rootfs setup scripts
│   ├── apps/        # Core apps installers
│   ├── ui/          # Desktop UI setup
│   └── build-iso.sh # ISO build script
├── docs/            # Documentation
│   ├── roadmap      # Project roadmap
│   ├── system-layout # System directory layout
│   ├── kernel-plan  # Kernel development plan
│   └── github-iso-build # ISO build guide
└── .github/workflows/ # CI/CD workflows
```

## Build

### Kernel Build (via GitHub Actions)

The kernel is built on GitHub Actions using the `build-kernel.yml` workflow.

```bash
# Trigger build on GitHub
# Go to: https://github.com/utikode/fkOs/actions
# Click: "Build fkOs Kernel" → "Run workflow"
```

### ISO Build (via GitHub Actions)

The ISO is built on GitHub Actions using the `build-iso.yml` workflow.

```bash
# Trigger build on GitHub
# Go to: https://github.com/utikode/fkOs/actions
# Click: "Build fkOs ISO" → "Run workflow"
```

### Local Build (WSL2)

```bash
# In WSL2 Ubuntu:
cd fkOs
./build/rootfs/setup.sh      # Create rootfs
./build/apps/install-core.sh  # Install core apps
./build/ui/setup.sh           # Setup desktop UI
./build/build-iso.sh           # Build ISO
```

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/utikode/fkOs.git
   cd fkOs
   ```

2. Build the kernel (via GitHub Actions):
   - Go to GitHub → Actions → "Build fkOs Kernel" → Run workflow

3. Build the ISO (via GitHub Actions):
   - Go to GitHub → Actions → "Build fkOs ISO" → Run workflow

4. Test with QEMU:
   ```bash
   qemu-system-x86_64 -cdrom fkOs.iso -boot d -m 2048
   ```

## Features

### Core Apps
- File Manager
- Browser
- Terminal
- Settings
- AI Assistant (fkai)

### Desktop UI
- Desktop Shell
- Panel
- Launcher
- Theme (fkOs Default)

### AI-Native
- Local LLM support
- Voice input/output
- Semantic search
- Natural language automation

## Documentation

- [Roadmap](fkOs_ROADMAP.md) - Project roadmap
- [System Layout](docs/system-layout.md) - System directory structure
- [Kernel Plan](docs/kernel-plan.md) - Kernel development plan
- [AI Features](docs/ai-features.md) - AI-native features
- [Built-in Apps](docs/builtin-apps.md) - List of built-in apps
- [GitHub Build](docs/github-build.md) - GitHub Actions build guide
- [GitHub ISO Build](docs/github-iso-build.md) - ISO build guide

## Contributing

This is an early-stage project. Contributions are welcome!

## License

TBD
