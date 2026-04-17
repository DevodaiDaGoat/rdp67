#!/bin/bash
set -e

echo "🚀 Starting Bulletproof Cloud OS..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# --- Start virtual display ---
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# --- XFCE desktop ---
dbus-launch --exit-with-session startxfce4 &
sleep 5

# --- clipboard ---
autocutsel -fork
autocutsel -selection PRIMARY -fork

# --- VNC ---
x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &

sleep 2

# --- noVNC ---
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# --- SELF-HEALING LOOP (important) ---
(
while true; do
  # ensure git-lfs exists
  command -v git-lfs >/dev/null 2>&1 || sudo apt-get install -y git-lfs

  # ensure chrome exists
  command -v google-chrome >/dev/null 2>&1 || true

  sleep 60
done
) &

# --- AUTO OPEN CHROME ---
(
sleep 12
DISPLAY=:1 google-chrome --no-sandbox https://google.com >/dev/null 2>&1 &
) &

echo "✅ System ready at http://localhost:6080"