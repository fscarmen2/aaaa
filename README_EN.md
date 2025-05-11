# NodePass Deployment Script

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Deployment Methods](#deployment-methods)
  - [Interactive Deployment](#interactive-deployment)
  - [Non-interactive Deployment](#non-interactive-deployment)
- [Quick Commands](#quick-commands)
- [System Requirements](#system-requirements)
- [Feedback](#feedback)

# NodePass Deployment Script

## Introduction

NodePass is a universal TCP/UDP tunnel solution with configuration-free single-file multi-mode operation. It employs a control-data dual-path separation architecture with built-in zero-latency adaptive connection pooling, enabling fast and secure access across network restrictions.

This script provides easy-to-use master mode (API mode) installation, configuration, and management functions.

[简体中文](README.md) | English

## Features

- **Multi-System Support**: Compatible with various Linux distributions including Debian, Ubuntu, CentOS, Fedora, Alpine, and Arch
- **Bilingual Interface**: Provides both Chinese and English interfaces to meet different language preferences
- **Automatic Detection**: Auto-detects system architecture, dependencies, and environment to ensure smooth installation
- **Flexible Configuration**: Supports custom ports, API prefixes, and TLS encryption modes
- **TLS Encryption**: Offers multiple TLS encryption options including no encryption, self-signed certificates, and custom certificates
- **Service Management**: Supports one-click start, stop, and restart services
- **Auto Updates**: Checks and installs the latest version to keep software up-to-date
- **Container Support**: Automatically identifies container environments and adapts service management accordingly
- **Quick Commands**: Creates shortcuts after installation for convenient management

## Deployment Methods

### Interactive Deployment

1. Download and execute the script:

```bash
bash <$(wget -qO- https://raw.githubusercontent.com/NodePassProject/nodepass-core/main/np.sh)
```

or

```bash
bash <$(curl -sSL https://raw.githubusercontent.com/NodePassProject/nodepass-core/main/np.sh)
```

2. Follow the prompts to select language (default is Chinese)
3. Choose "Install NodePass" from the main menu
4. Enter the following information as prompted:
   - Server IP (default is 127.0.0.1)
   - Port number (1000-65535, leave empty for random port between 1024-8191)
   - API prefix (default is /)
   - TLS mode (0: no encryption, 1: self-signed certificate, 2: custom certificate)
5. Wait for installation to complete

### Non-interactive Deployment

Use the following commands for non-interactive installation with command-line parameters:

```bash
# Example 1: Chinese interface, specify server IP, port, API prefix, and no TLS encryption
bash np.sh -i --language zh --server_ip 127.0.0.1 --user_port 18080 --prefix api --tls_mode 0

# Example 2: English interface, specify server IP, port, API prefix, and self-signed certificate
bash np.sh -i --language en --server_ip localhost --user_port 18080 --prefix api --tls_mode 1

# Example 3: Chinese interface, specify server IP, port, API prefix, custom certificate and certificate file paths
bash np.sh -i --language zh --server_ip 1.2.3.4 --user_port 18080 --prefix api --tls_mode 2 --cert_file /tmp/cert.pem --key_file /tmp/key.pem
```

If parameters are not specified, default configuration will be used:
- Server IP: 127.0.0.1
- Port: Random port
- API prefix: /
- TLS mode: No encryption

## Quick Commands

After installation, the system creates `np` shortcuts that can be used as follows:

- `np` - Display menu
- `np -i` - Install NodePass
- `np -u` - Uninstall NodePass
- `np -v` - Upgrade NodePass
- `np -o` - Toggle service status (start/stop)
- `np -s` - Show NodePass API information
- `np -h` - Show help information

## System Requirements

- Operating System: Supports Linux distributions including Debian, Ubuntu, CentOS, Fedora, Alpine, and Arch
- Architecture: Supports x86_64 (amd64), aarch64 (arm64), and armv7l (arm)
- Permissions: Requires root privileges to run the script

## Feedback

If you encounter any issues, please submit feedback at [GitHub Issues](https://github.com/NodePassProject/nodepass-core/issues).
        
