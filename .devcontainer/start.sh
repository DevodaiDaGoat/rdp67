#!/bin/bash
set -e

echo "🪟 Starting KDE Plasma Cloud Desktop..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# 1. Virtual display
Xvfb :1 -screen 0 1280x800x24 &
sleep 3

# 2. DBus session (CRITICAL for KDE)
eval "$(dbus-launch --sh-syntax --exit-with-session)"

# 3. Start KDE Plasma
startplasma-x11 &
sleep 8

# 4. VNC server attached to correct display
x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &
sleep 2

# 5. Detect noVNC path safely
NOVNC_PATH="/usr/share/novnc"
if [ ! -d "$NOVNC_PATH" ]; then
  NOVNC_PATH=$(find /usr/share -type d -name "novnc" | head -n 1)
fi

echo "✅ Using noVNC: $NOVNC_PATH"

# 6. Websockify bridge (THIS is what makes site work)
websockify --web=$NOVNC_PATH 6080 localhost:5900 &

# 7. Auto Chrome inside KDE session
(
sleep 12
DISPLAY=:1 google-chrome --no-sandbox https://google.com &
) &

# 8. Fastfetch (system info like Windows “About”)
(
sleep 5
fastfetch || true
) &

echo "✅ KDE Desktop running on port 6080"