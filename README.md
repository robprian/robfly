---

# Linux GUI on Fly.io (SSH & VNC)

This project sets up a **Linux GUI environment** on Fly.io with **SSH** and **VNC** access. It uses **Ubuntu Desktop LXDE** with a **VNC server** and an **SSH server** running on a custom user "robby", whose home directory is located at `/robby` with a **30GB volume**.

#### Deployment Status
![Deploy](https://github.com/robprian/robfly/actions/workflows/deploy.yml/badge.svg)
![Last Commit](https://img.shields.io/github/last-commit/robprian/robfly)
![Issues](https://img.shields.io/github/issues/robprian/robfly)
![Pull Requests](https://img.shields.io/github/issues-pr/robprian/robfly)

#### Project Info
![Repo Stars](https://img.shields.io/github/stars/robprian/robfly)
![Repo Forks](https://img.shields.io/github/forks/robprian/robfly)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen)

#### Tech Stack
![Node.js](https://img.shields.io/badge/node-%3E=18.0-blue)
![Python](https://img.shields.io/badge/python-3.11-blue)
![Docker](https://img.shields.io/badge/docker-ready-blue)


## Features:
- **SSH access** via port `1995`
- **VNC access** via port `6080`
- **Custom home directory** for user `robby` at `/robby`
- **Full volume (30GB)** dedicated to `/robby`
- **Firewall management** via `ufw` in `entry.sh` to filter open ports

## Setup

### Prerequisites
- You need to have a **Fly.io account** and **Fly CLI** installed on your system.
- Create a **Fly.io application** using the command:
  
  ```bash
  fly launch
  ```

Configuration

1. Fly.toml Configuration The fly.toml file defines the configuration for the Fly.io app, including the volume size and exposed ports.
```bash
app = "robfly"
primary_region = "sin"

[build]
  dockerfile = "Dockerfile"

[env]
# Add environment variables if needed

[vm]
  size = "performance-4x"  # 4 vCPU, 8 GB RAM

[[mounts]]
  source = "robby_data"
  destination = "/robby"
  initial_size = 30  # GB volume size

[[services]]
  internal_port = 1995
  protocol = "tcp"
  [[services.ports]]
    port = 1995

[[services]]
  internal_port = 6080
  protocol = "tcp"
  [[services.ports]]
    port = 6080

```


2. Environment Variables Make sure you set the necessary environment variables for SSH:

- SSH_PASSWORD → Password for user robby (should be set in GitHub Secrets or Fly.io Secrets).
- FLY_API_TOKEN → Token access for deploy apps to fly.io




How to Deploy

1. Deploy the application:

Run the following command to deploy the app:
```bash
flyctl deploy
```

2. Access via SSH:

After deploying, access the server via SSH at port 1995:
```bash
ssh robby@robfly.fly.dev -p 1995
```

3. Access via VNC:

You can connect to the Linux GUI via VNC at port 6080 using any VNC client.




Files in the Project

- Dockerfile: The Dockerfile sets up the environment and installs necessary packages.
- entry.sh: The entrypoint script to configure SSH, VNC, and UFW firewall rules.
- fly.toml: Configuration for Fly.io app deployment.
- deploy.yml: GitHub Actions workflow for CI/CD deployment to Fly.io.
- README.md: Documentation for the project.



---

Troubleshooting

- If you're unable to connect via SSH or VNC, check the firewall settings in entry.sh.
- Ensure that the volume size is properly configured in fly.toml (30GB) to avoid issues with space.
- Make sure you set up the correct Fly.io API token and environment variables (SSH_PASSWORD) during setup.



---

License

MIT License. See LICENSE for more details.

---
