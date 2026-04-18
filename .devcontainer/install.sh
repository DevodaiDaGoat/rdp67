#!/bin/bash
echo "📦 Installing KDE Plasma + VNC stack..."

sudo apt-get update
# Install KDE Plasma Desktop and essential X11 tools
sudo apt-get install -y --no-install-recommends \
    kde-plasma-desktop \
    plasma-desktop \
    kwin-x11 \
    dbus-x11 \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    x11-xserver-utils \
    curl \
    ca-certificates

# Fix for KDE rendering in containers
sudo apt-get install -y libgl1-mesa-dri libglx-mesa0 libegl1-mesa

# Install Fastfetch & Chrome as you had them
sudo apt-get install -y fastfetch

# ✅ Install Google Chrome
echo "🌐 Installing Chrome..."
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
| sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update
sudo apt-get install -y google-chrome-stable
echo 'alias chrome="google-chrome --no-sandbox --disable-dev-shm-usage"' >> ~/.bashrc

# ✅ Git LFS setup
git lfs install

echo "✅ Everything installed"