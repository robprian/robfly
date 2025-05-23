FROM dorowu/ubuntu-desktop-lxde-vnc

RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Install packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    build-essential \
    libssl-dev \
    libffi-dev \
    net-tools \
    iproute2 \
    iputils-ping \
    ufw \
    && rm -rf /var/lib/apt/lists/*

# Create /robby as the full home + ssh + data base
RUN useradd -m -d /robby -s /bin/bash robby \
    && mkdir -p /robby/ssh \
    && chown -R robby:robby /robby

# Remove default ssh config, we'll link it later
RUN rm -rf /etc/ssh

# Copy entry script
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

# Expose all ports (will be filtered by ufw inside)
EXPOSE 1-65535

CMD ["/entry.sh"]
