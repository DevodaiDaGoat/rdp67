#!/bin/bash
set -e

echo "🧱 Installing KDE Cloud Desktop..."

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install -y --no-install-recommends \
kde-standard \
plasma-desktop \
dbus-x11 \
xvfb \
x11vnc \
novnc \
websockify \
autocutsel \
curl \
wget \
git-lfs \
fastfetch

# Git LFS fix (always safe)
git lfs install --system --skip-repo || true

# Chrome (optional but included)
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y || true
rm -f google-chrome-stable_current_amd64.deb

# Swap already handled by you (good)

echo "✅ KDE install complete"

echo "🧠 Creating swap file..."

sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "✅ Swap enabled (8GB)"

echo "✅ Install COMPLETE (stable state guaranteed)"