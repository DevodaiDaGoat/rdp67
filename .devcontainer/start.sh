#!/bin/bash

export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR

echo "🖥 Starting Xvfb..."
sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix

Xvfb :0 -screen 0 1280x800x24 &

sleep 2

echo "🔌 Starting DBus + KDE..."

dbus-run-session -- bash -c '
  export DISPLAY=:0
  export XDG_RUNTIME_DIR=/tmp/runtime-vscode

  kwin_x11 &
  sleep 2
  startplasma-x11 &
'

sleep 3

echo "📋 Clipboard..."
autocutsel -fork
autocutsel -selection PRIMARY -fork

echo "🖥 Starting VNC..."
x11vnc -display :0 -forever -nopw -shared &

echo "🌐 Starting noVNC..."
websockify --web=/usr/share/novnc 6080 localhost:5900