#!/bin/bash
set -e

# fkOs Core Applications - Build & Install Script
# Installs core applications into the rootfs

ROOTFS_DIR="./rootfs"

echo "=== fkOs Core Apps Installation ==="

# Create apps directory
mkdir -p "$ROOTFS_DIR/usr/local/bin"
mkdir -p "$ROOTFS_DIR/usr/share/fkos/apps"
mkdir -p "$ROOTFS_DIR/usr/share/fkos/ui"
mkdir -p "$ROOTFS_DIR/etc/fkos"

# Install File Manager (FKM)
echo "[1/5] Installing File Manager..."
cat > "$ROOTFS_DIR/usr/local/bin/file-manager" << 'EOF'
#!/bin/bash
# fkOs File Manager - Minimal implementation
# Uses system's file manager with fkOs branding

# Check if we have a GUI
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    # GUI mode
    if command -v pcmanfm &>/dev/null; then
        pcmanfm "$@"
    elif command -v nautilus &>/dev/null; then
        nautilus "$@"
    else
        echo "fkOs File Manager: No GUI file manager found"
        echo "Falling back to terminal mode..."
        ls -la "$@"
    fi
else
    # Terminal mode
    echo "fkOs File Manager (Terminal Mode)"
    echo "Use: file-manager [directory]"
    if [ -n "$1" ]; then
        ls -la "$1"
    else
        ls -la
    fi
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/file-manager"

# Install Browser
echo "[2/5] Installing Browser..."
cat > "$ROOTFS_DIR/usr/local/bin/browser" << 'EOF'
#!/bin/bash
# fkOs Browser - Minimal wrapper
# Uses system browser with fkOs branding

if command -v firefox &>/dev/null; then
    firefox "$@"
elif command -v chromium-browser &>/dev/null; then
    chromium-browser "$@"
elif command -v google-chrome &>/dev/null; then
    google-chrome "$@"
else
    echo "fkOs Browser: No browser found"
    echo "Install one of: firefox, chromium-browser, google-chrome"
    echo "Or use: curl $1"
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/browser"

# Install Terminal
echo "[3/5] Installing Terminal..."
cat > "$ROOTFS_DIR/usr/local/bin/terminal" << 'EOF'
#!/bin/bash
# fkOs Terminal - Minimal wrapper
# Uses system terminal with fkOs branding

if command -v gnome-terminal &>/dev/null; then
    gnome-terminal "$@"
elif command -v konsole &>/dev/null; then
    konsole "$@"
elif command -v xterm &>/dev/null; then
    xterm "$@"
else
    echo "fkOs Terminal: No terminal found"
    echo "Using bash..."
    bash "$@"
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/terminal"

# Install Settings
echo "[4/5] Installing Settings..."
cat > "$ROOTFS_DIR/usr/local/bin/settings" << 'EOF'
#!/bin/bash
# fkOs Settings - Minimal wrapper
# Uses system settings with fkOs branding

if command -v gnome-control-center &>/dev/null; then
    gnome-control-center "$@"
elif command -v systemsettings &>/dev/null; then
    systemsettings "$@"
else
    echo "fkOs Settings: No settings application found"
    echo "Available settings:"
    echo "  - Display: xrandr"
    echo "  - Network: nmcli"
    echo "  - Audio: pavucontrol"
    echo "  - System: lsb_release -a"
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/settings"

# Install AI Assistant
echo "[5/5] Installing AI Assistant..."
cat > "$ROOTFS_DIR/usr/local/bin/fkai" << 'EOF'
#!/bin/bash
# fkOs AI Assistant - Minimal implementation
# Uses local LLM when available, falls back to system tools

FKAI_CONFIG="/etc/fkos/fkai.conf"
FKAI_MODEL="/opt/fkai/models/llama-model.gguf"

echo "fkOs AI Assistant (fkai)"
echo "=========================="

# Check if local model exists
if [ -f "$FKAI_MODEL" ]; then
    echo "Using local model: $FKAI_MODEL"
    # Placeholder for llama.cpp integration
    echo "Local AI: Ready"
else
    echo "No local model found. Using system tools."
    echo "To enable local AI, install model at: $FKAI_MODEL"
fi

# Simple command router
case "$1" in
    "search")
        echo "Searching for: ${2:-all}"
        find / -name "*${2:-*}*" 2>/dev/null | head -20
        ;;
    "file")
        if [ -n "$2" ]; then
            echo "File info for: $2"
            ls -la "$2" 2>/dev/null || echo "File not found: $2"
        else
            echo "Usage: fkai file <path>"
        fi
        ;;
    "system")
        echo "System Information:"
        echo "  OS: fkOs"
        echo "  Kernel: $(uname -r)"
        echo "  Uptime: $(uptime)"
        echo "  Memory: $(free -h | grep Mem)"
        echo "  Disk: $(df -h / | tail -1)"
        ;;
    "help"|*)
        echo "Commands:"
        echo "  fkai search <query>    - Search files"
        echo "  fkai file <path>       - Show file info"
        echo "  fkai system            - System info"
        echo "  fkai help              - Show this help"
        ;;
esac
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/fkai"

# Create fkOs configuration
echo "Creating fkOs configuration..."
cat > "$ROOTFS_DIR/etc/fkos/fkai.conf" << 'EOF'
# fkOs AI Assistant Configuration

# Model settings
model_path=/opt/fkai/models/llama-model.gguf
model_context_size=4096

# Voice settings
voice_enabled=true
voice_input=auto
voice_output=auto

# Search settings
search_local_files=true
search_cloud=false

# Privacy
cloud_opt_in=false
data_collection=false

# Logging
log_level=info
log_file=/var/log/fkai.log
EOF

echo ""
echo "=== Core Apps Installation Complete ==="
echo "Installed:"
echo "  - file-manager"
echo "  - browser"
echo "  - terminal"
echo "  - settings"
echo "  - fkai (AI Assistant)"
echo ""
echo "Configuration: /etc/fkos/fkai.conf"