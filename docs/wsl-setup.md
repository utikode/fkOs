# WSL2 Build Environment

1. Install WSL2 Ubuntu:
   wsl --install -d Ubuntu

2. Update:
   sudo apt update && sudo apt upgrade -y

3. Toolchain:
   sudo apt install -y build-essential clang gcc make qemu-system-x86 git python3

4. Rust:
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

5. Mount workspace:
   /mnt/c/Users/kangris/.qwenpaw/workspaces/default/fkOs
