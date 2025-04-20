#!/bin/bash

# Cek env var password
if [ -z "$ROBBY_PASSWORD" ]; then
  echo "ERROR: ROBBY_PASSWORD environment variable is not set!"
  exit 1
fi

# Create user 'robby' with password from env
echo ">> Creating user robby with password from env..."
useradd -m -s /bin/bash robby
echo "robby:$ROBBY_PASSWORD" | chpasswd
adduser robby sudo

# Configure SSH and noVNC ports
echo ">> Starting SSH on port 1995..."
service ssh start

echo ">> Starting VNC server for user 'robby'..."
sudo -u robby vncserver :1 -geometry ${VNC_RESOLUTION:-1024x768}

echo ">> Starting noVNC on port 6080..."
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

# Configure firewall - block all ports except SSH (1995) and noVNC (6080)
echo ">> Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 1995/tcp
ufw allow 6080/tcp
ufw enable

echo ">> Firewall configured: Allowed ports - 1995 (SSH), 6080 (noVNC)"

# Keep container running
tail -f /dev/null
