# 📘 NodePass Deployment and Management Guide

[简体中文](README.md) | English

`np.sh`: One-click deployment of the NodePass main program, providing high-performance TCP/UDP tunneling with multi-system support and flexible configuration.  
`dash.sh`: One-click deployment of the NodePassDash control panel, simplifying tunnel management and monitoring with containerization and HTTPS support.

- Standard: v1.12.0
- Development: v1.122.0-b3
- LTS: v1.10.3

---

## 📑 Table of Contents

- [Introduction](#introduction)
- [System Requirements](#system-requirements)
- [1. `np.sh` Script (Main Program Installation)](#1-npsh-script-main-program-installation)
  - [Features](#features)
  - [Deployment Methods](#deployment-methods)
    - [Interactive Deployment](#interactive-deployment)
    - [Non-interactive Deployment](#non-interactive-deployment)
  - [Quick Commands](#quick-commands)
  - [Directory Structure](#directory-structure)
- [2. `dash.sh` Script (Control Panel Installation)](#2-dashsh-script-control-panel-installation)
  - [Features](#features-1)
  - [Usage Instructions](#usage-instructions)
  - [Uninstallation Instructions](#uninstallation-instructions)
- [Feedback](#feedback)
- [Deployment Screenshots](#deployment-screenshots)

---

## Introduction

**NodePass** is a universal TCP/UDP tunneling solution with a control-data separation architecture, supporting zero-latency connection pools and multi-mode communication for high-performance, secure access across network restrictions.

---

## System Requirements

- **Operating System**: Compatible with Debian, Ubuntu, CentOS, Fedora, Alpine, Arch, OpenWRT, and more
- **Architecture**: Supports x86_64 (amd64), aarch64 (arm64), armv7l (arm)
- **Permissions**: Requires root privileges to run

---

## 1. `np.sh` Script (Main Program Installation)

### Features

- ✅ Multi-system support
- 🌐 Bilingual interface (Chinese/English)
- 🔍 Automatic detection of architecture and dependencies
- 🔧 Flexible configuration of ports, API prefixes, and TLS modes
- 🔐 Supports no encryption, self-signed certificates, or custom certificates
- 🛠️ One-click service start, stop, restart, and uninstall
- 🔄 Automatic updates to the latest version
- 🐳 Automatic recognition of container environments

---

### Deployment Methods

#### Interactive Deployment

```bash
bash <(wget -qO- https://run.nodepass.eu/np.sh)
```
or
```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh)
```

Follow the prompts to provide the following information:

- Language selection (default: Chinese)
- Server IP (default: 127.0.0.1)
- Port (leave blank for auto-assigned port in the 1024–8192 range)
- API prefix (default: `api`)
- TLS mode (0: no encryption, 1: self-signed certificate, 2: custom certificate)

---

#### Non-interactive Deployment

<details>
    <summary>Example 1: No TLS encryption</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 127.0.0.1 \
  --user_port 18080 \
  --prefix api \
  --tls_mode 0
```

</details>

<details>
    <summary>Example 2: Self-signed certificate</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language en \
  --server_ip localhost \
  --user_port 18080 \
  --prefix api \
  --tls_mode 1
```

</details>

<details>
    <summary>Example 3: Custom certificate</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 1.2.3.4 \
  --user_port 18080 \
  --prefix api \
  --tls_mode 2 \
  --cert_file </path/to/cert.pem> \
  --key_file </path/to/key.pem>
```

</details>

---

### Quick Commands

After installation, the `np` shortcut command is created:

| Command   | Description                   |
|-----------|-------------------------------|
| `np`      | Display interactive menu      |
| `np -i`   | Install NodePass             |
| `np -u`   | Uninstall NodePass           |
| `np -v`   | Upgrade NodePass             |
| `np -o`   | Start/stop service           |
| `np -k`   | Change API key               |
| `np -s`   | View API information         |
| `np -h`   | Display help information     |

---

### Directory Structure

```
/etc/nodepass/
├── data                # Configuration data
├── nodepass            # Main program
├── nodepass.gob        # Data storage file
└── np.sh               # Deployment script
```

---

## 2. `dash.sh` Script (Control Panel Installation)

### Features

- 🚀 One-click deployment of NodePassDash control panel
- 🐧 Supports Debian, Ubuntu, CentOS
- 🔧 Automatic detection of system and dependencies
- 🐳 Supports Docker and Podman for container deployment
- 🔄 Automatic reverse proxy configuration (with HTTPS support)
- 🔐 Automatic CA SSL certificate issuance (for domain-based deployment)
- 📂 Automatic mounting of logs and public resource directories

---

### Usage Instructions

1. **Run the script**:

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh)
```
or
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh)
```

2. **Provide information**:

- Domain or IP: Entering a domain enables HTTPS reverse proxy and SSL certificate issuance; entering an IP skips reverse proxy and Caddy installation.
- Port: Default is 3000, customizable.

3. **Container deployment**:

- Automatically uses Docker or Podman to run the control panel container
- Checks for port conflicts

4. **Mounted directories**:

| Host Path                   | Container Path      | Purpose       |
|-----------------------------|---------------------|---------------|
| `~/nodepassdash/logs`       | `/app/logs`         | Log files     |
| `~/nodepassdash/public`     | `/app/public`       | Public resources |

5. **Completion prompt**: The script will output the access address and admin account details upon completion.

---

### Uninstallation Instructions

To uninstall the NodePassDash control panel:

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) uninstall
```
or
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh) uninstall
```

This will clean up the container, configuration files, and mounted directories.

---

## Feedback

For installation or usage issues, please submit feedback at [GitHub Issues](https://github.com/NodePassProject/npsh/issues).

---

## Deployment Screenshots

<img width="690" alt="image" src="https://github.com/user-attachments/assets/893a3856-ec69-488f-bb99-5df26b4fb4e7" />

<img width="690" alt="image" src="https://github.com/user-attachments/assets/61e01872-f401-485d-aa9a-8c1388e76a5b" />
