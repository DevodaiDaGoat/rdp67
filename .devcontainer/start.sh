#!/bin/bash

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Start virtual display
Xvfb :1 -screen 0 1280x800x24 &

# Start DBus session + KDE properly
dbus-launch --exit-with-session startplasma-x11 &

# Clipboard sync
autocutsel -fork
autocutsel -selection PRIMARY -fork

# Start VNC
x11vnc -display :1 -forever -nopw -shared &

# Start noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5900