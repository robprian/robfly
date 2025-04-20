#!/bin/bash

# Init SSH password dari GitHub Secret
echo "robby:${SSH_PASSWORD}" | chpasswd

# Buat symlink SSH config ke volume
ln -s /robby/ssh /etc/ssh

# Generate SSH host keys jika belum ada
if [ ! -f /robby/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
    cp /etc/ssh/* /robby/ssh/
fi

# Aktifkan SSH server di port 1995
sed -i 's/#Port 22/Port 1995/' /robby/ssh/sshd_config
sed -i 's@/home/robby@/robby@g' /robby/ssh/sshd_config

# UFW rules: hanya allow 1995 (SSH) dan 6080 (VNC)
ufw --force reset
ufw allow 1995/tcp
ufw allow 6080/tcp
ufw --force enable

# Jalankan ssh server dan supervisor (GUI)
/usr/sbin/sshd -D -p 1995 -o ListenAddress=0.0.0.0
supervisord -c /etc/supervisor/supervisord.conf
