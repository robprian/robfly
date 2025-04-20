FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update && apt install -y \
    sudo wget curl vim git gnupg net-tools iputils-ping \
    unzip software-properties-common \
    build-essential libssl-dev libffi-dev python3-dev \
    xfce4 tightvncserver dbus-x11 x11-xserver-utils \
    openssh-server websockify novnc \
    && apt clean

# Setup SSH port config
RUN mkdir /var/run/sshd && \
    sed -i 's/#Port 22/Port 1995/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose all ports including SSH and noVNC
EXPOSE 1-65535
EXPOSE 1995 6080 5901

# Copy entrypoint
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD ["/entry.sh"]
