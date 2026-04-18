#!/bin/bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# 1. Clean up old locks
sudo rm -f /tmp/.X1-lock

# 2. Start X Virtual Framebuffer (Crucial: add +extension GLX for KDE)
Xvfb :1 -screen 0 1280x800x24 +extension GLX +render -noreset &
sleep 3

# 3. Start DBus and KDE 
# We use dbus-run-session to ensure Plasma has a valid bus to talk to
dbus-run-session -- bash -c "
  export DISPLAY=:1
  # Disable heavy hardware acceleration for stability
  export KWIN_COMPOSE=N 
  export QT_X11_NO_MITSHM=1

  # Start Window Manager first
  kwin_x11 --replace & 
  sleep 2
  
  # Start the Desktop
  startplasma-x11 &
" &

sleep 5

# 4. Start VNC and noVNC
x11vnc -display :1 -forever -nopw -shared -rfbport 5900 &
websockify --web=/usr/share/novnc 6080 localhost:5900