#!/bin/bash

# 1. Environment Setup
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# 2. Cleanup old locks so it doesn't fail on restart
sudo rm -f /tmp/.X1-lock
sudo rm -f /tmp/.X11-unix/X1
killall -9 Xvfb x11vnc websockify startxfce4 2>/dev/null

# 3. Start X Virtual Framebuffer
Xvfb :1 -screen 0 1366x768x24 &
sleep 2

# 4. Start the Desktop Environment
startxfce4 &
sleep 3

# 5. Start VNC and noVNC
x11vnc -display :1 -forever -nopw -shared -rfbport 5900 -noxdamage &
websockify --web=/usr/share/novnc 6080 localhost:5900 &

# 6. Automated Chrome Launch (with the fixes we made)
(
  sleep 5
  google-chrome --no-sandbox --disable-dev-shm-usage --start-maximized https://google.com
) &

echo "✅ VNC and Chrome are automated!"