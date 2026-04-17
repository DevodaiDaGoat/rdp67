#!/bin/bash

export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

echo "🖥 Starting Xvfb..."
Xvfb :0 -screen 0 1280x800x24 &

sleep 2

echo "🔌 Starting full KDE session (fixed)..."
dbus-run-session -- bash -c "
  export DISPLAY=:0

  # Force software rendering (fixes Codespaces GPU issues)
  export LIBGL_ALWAYS_SOFTWARE=1

  # Start window manager FIRST (critical)
  kwin_x11 &

  sleep 2

  # Then Plasma shell
  plasmashell &
" &

sleep 3

echo "📋 Clipboard..."
autocutsel -fork || true
autocutsel -selection PRIMARY -fork || true

echo "🖥 Starting VNC..."
x11vnc -display :0 -forever -nopw -shared -noxdamage &

sleep 2

echo "🌐 Starting noVNC..."
websockify --web=/usr/share/novnc/ 6080 localhost:5900