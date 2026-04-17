#!/bin/bash
set -e

echo "🚀 Starting KDE noVNC environment..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# prevent prompts / freezes
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export APT_LISTCHANGES_FRONTEND=none

echo "🖥 Starting virtual display..."
Xvfb :1 -screen 0 1280x800x24 &

sleep 2

echo "🔌 Starting DBus session..."
dbus-run-session -- startplasma-x11 &

sleep 3

echo "📋 Starting clipboard sync..."
autocutsel -fork || true
autocutsel -selection PRIMARY -fork || true

echo "🖥 Starting VNC server..."
x11vnc -display :1 -forever -nopw -shared -bg || true

echo "🌐 Starting noVNC..."
websockify --web=/usr/share/novnc/ 6080 localhost:5900