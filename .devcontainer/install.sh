#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "📦 Installing core system..."

sudo apt-get update

sudo apt-get install -y \
xfce4 \
xfce4-terminal \
xvfb \
x11vnc \
novnc \
websockify \
dbus-x11 \
autocutsel \
git-lfs \
wget \
curl \
gnupg

# Enable Git LFS
git lfs install

echo "🌐 Installing Google Chrome..."

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true

sudo apt install -y ./google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y || true

rm -f google-chrome-stable_current_amd64.deb

echo "🧹 Cleaning desktop..."
rm -rf /home/vscode/Desktop/* || true

echo "✅ Install complete"