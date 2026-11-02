#!/bin/bash
set -e

# fkOs Desktop UI - Setup Script
# Installs desktop shell, panel, and theme

ROOTFS_DIR="./rootfs"

echo "=== fkOs Desktop UI Setup ==="

# Create directories
mkdir -p "$ROOTFS_DIR/usr/share/fkos/ui"
mkdir -p "$ROOTFS_DIR/usr/share/fkos/themes"
mkdir -p "$ROOTFS_DIR/usr/share/fkos/icons"
mkdir -p "$ROOTFS_DIR/etc/X11/xorg.conf.d"

# Create desktop shell entry
echo "[1/4] Creating desktop shell..."

# Desktop session file
cat > "$ROOTFS_DIR/usr/share/xsessions/fkos.desktop" << 'EOF'
[Desktop Entry]
Name=fkOs Desktop
Comment=fkOs Desktop Environment
Exec=/usr/local/bin/fkos-shell
Type=Application
EOF

# Create shell script
cat > "$ROOTFS_DIR/usr/local/bin/fkos-shell" << 'EOF'
#!/bin/bash
# fkOs Desktop Shell - Minimal implementation
# Uses available Wayland/X11 compositor

echo "Starting fkOs Desktop Shell..."

# Check for Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "Wayland detected"
    # Use available Wayland compositor
    if command -v sway &>/dev/null; then
        sway
    elif command -v weston &>/dev/null; then
        weston
    else
        echo "No Wayland compositor found"
        # Fall back to X11
        startx
    fi
else
    # X11 mode
    echo "X11 mode"
    if command -v openbox &>/dev/null; then
        openbox
    elif command -v i3 &>/dev/null; then
        i3
    else
        echo "No window manager found"
        echo "Starting basic X session..."
        startx
    fi
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/fkos-shell"

# Create panel/launcher script
echo "[2/4] Creating panel and launcher..."
cat > "$ROOTFS_DIR/usr/local/bin/fkos-panel" << 'EOF'
#!/bin/bash
# fkOs Panel - Minimal implementation
# Displays status bar with app launcher

echo "Starting fkOs Panel..."

# Simple panel using available tools
if command -v tint2 &>/dev/null; then
    tint2
elif command -v polybar &>/dev/null; then
    polybar fkOs
else
    echo "No panel found. Using basic status display."
    # Display basic info
    while true; do
        echo -ne "\r$(date '+%Y-%m-%d %H:%M:%S') | CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1)% | RAM: $(free -h | grep Mem | awk '{print $3"/"$2}')"
        sleep 1
    done
fi
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/fkos-panel"

# Create launcher script
cat > "$ROOTFS_DIR/usr/local/bin/fkos-launcher" << 'EOF'
#!/bin/bash
# fkOs App Launcher - Minimal implementation

echo "fkOs App Launcher"
echo "=================="
echo "Available apps:"
echo "  [1] File Manager    (file-manager)"
echo "  [2] Browser         (browser)"
echo "  [3] Terminal        (terminal)"
echo "  [4] Settings        (settings)"
echo "  [5] AI Assistant    (fkai)"
echo "  [6] Calculator      (calculator)"
echo "  [7] Calendar        (calendar)"
echo "  [8] Text Editor     (editor)"
echo "  [9] Media Player    (media-player)"
echo "  [0] Exit"
echo ""
read -p "Select app [0-9]: " choice

case $choice in
    1) file-manager & ;;
    2) browser & ;;
    3) terminal & ;;
    4) settings & ;;
    5) fkai & ;;
    6) calculator & ;;
    7) calendar & ;;
    8) editor & ;;
    9) media-player & ;;
    0) exit 0 ;;
    *) echo "Invalid choice" ;;
esac
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/fkos-launcher"

# Create theme
echo "[3/4] Creating theme..."
cat > "$ROOTFS_DIR/usr/share/fkos/themes/default.css" << 'EOF'
/* fkOs Default Theme */
:root {
    --primary-color: #0066cc;
    --secondary-color: #f0f0f0;
    --accent-color: #ff9800;
    --background: #ffffff;
    --text-color: #333333;
    --border-radius: 8px;
    --font-family: "Inter", "Noto Sans", sans-serif;
}

body {
    font-family: var(--font-family);
    background: var(--background);
    color: var(--text-color);
}

button {
    border-radius: var(--border-radius);
    padding: 8px 16px;
    background: var(--primary-color);
    color: white;
    border: none;
    cursor: pointer;
}

button:hover {
    background: #0055aa;
}

input, textarea {
    border-radius: var(--border-radius);
    border: 1px solid #ccc;
    padding: 8px;
}

.window {
    border-radius: var(--border-radius);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    background: white;
}

.panel {
    background: #f8f8f8;
    border-bottom: 1px solid #e0e0e0;
    padding: 8px 16px;
}

.launcher {
    background: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: var(--border-radius);
    padding: 16px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}
EOF

# Create icon theme
cat > "$ROOTFS_DIR/usr/share/fkos/icons/fkos-icons.svg" << 'EOF'
<!-- fkOs Icon Theme - Minimal -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <rect x="4" y="4" width="16" height="16" rx="2" fill="#0066cc"/>
  <text x="12" y="16" text-anchor="middle" fill="white" font-size="10">fk</text>
</svg>
EOF

echo "[4/4] UI setup complete!"
echo ""
echo "fkOs Desktop UI installed:"
echo "  - /usr/local/bin/fkos-shell"
echo "  - /usr/local/bin/fkos-panel"
echo "  - /usr/local/bin/fkos-launcher"
echo "  - /usr/share/xsessions/fkos.desktop"
echo "  - /usr/share/fkos/themes/default.css"
echo "  - /usr/share/fkos/icons/fkos-icons.svg"