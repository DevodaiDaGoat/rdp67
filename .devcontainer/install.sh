#!/bin/bash
set -e

echo "📦 Updating system..."

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install -y --no-install-recommends \
  kde-standard \
  kde-terminal \
  xvfb \
  x11vnc \
  novnc \
  websockify \
  dbus-x11 \
  autocutsel \
  git-lfs \
  || true

echo "🧠 Cleaning leftover prompts..."
sudo apt-get autoremove -y || true
sudo apt-get clean || true

echo "✅ KDE install complete (safe mode)"