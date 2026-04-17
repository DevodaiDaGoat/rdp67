#!/bin/bash
set -e

echo "🔧 Running system repair..."

sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean
sudo apt-get update

# Fix broken dpkg states if any
sudo dpkg --configure -a || true

echo "✅ Repair complete"