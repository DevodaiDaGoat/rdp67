#!/bin/bash
set -e

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Virtual display
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# XFCE session (ChromeOS-like lightweight desktop)
dbus-launch --exit-with-session startxfce4 &
sleep 5

# Clipboard sync
autocutsel -fork
autocutsel -selection PRIMARY -fork

# VNC server
x11vnc -display :1 \
  -forever \
  -shared \
  -rfbport 5900 \
  -nopw \
  -quiet &

sleep 2

# noVNC web access
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# Auto-launch Chrome (non-kiosk, normal full browser)
(sleep 10 && DISPLAY=:1 google-chrome --no-sandbox https://google.com) &