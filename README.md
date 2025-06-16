# `dash.sh` 脚本说明文档

## 目录

- [概述](#概述)
- [特色](#特色)
- [使用说明](#使用说明)
- [卸载说明](#卸载说明)

## 概述

`dash.sh` 是一个一键脚本，用于自动安装和配置 NodePassDash。该脚本支持通过 Docker 或 Podman 进行容器管理，提供灵活的部署选项。

## 特色

- **系统支持**: 支持 Debian、Ubuntu 和 CentOS 三大主流 Linux 发行版。
- **环境检测**: 自动检测系统环境。
- **依赖安装**: 安装必要的依赖项，如 Docker 或 Podman。
- **反向代理配置**: 配置反向代理和 Docker/Podman 容器。
- **CA 证书申请**: 如果输入的是域名，脚本会自动申请 CA 证书，以确保通过 HTTPS 安全访问面板。

## 使用说明

1. **运行脚本**: 在终端中以管理员权限运行脚本：
```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh)
```
或
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh)
```

2. **用户输入**:
   - 脚本会提示您输入一个有效的域名或 IPv4/IPv6 地址。
   - 输入 IP 地址时，不会安装 Caddy。
   - 输入域名时，脚本会检测并安装 Caddy，并申请 CA 证书，以确保安全访问。

3. **输入端口**: 脚本会询问您要使用的端口，默认值为 3000。

4. **端口检查**: 检查用户指定的端口是否被占用。

5. **Docker/Podman 容器管理**: 下载并运行 NodePassDash Docker 或 Podman 容器。

6. **挂载说明**: 在运行 Docker/Podman 容器时，脚本会将以下目录挂载到容器中：
   - **日志目录**: `~/nodepassdash/logs` 挂载到容器的 `/app/logs`，用于存储应用程序的日志文件。
   - **公共目录**: `~/nodepassdash/public` 挂载到容器的 `/app/public`，用于存储公共访问的文件。

7. **查看输出**: 安装完成后，脚本会输出面板地址和管理员账户信息。

## 卸载说明

如果您需要卸载 NodePassDash，可以使用以下命令。将停止并删除 NodePassDash 容器，并清理相关的挂载目录和配置文件。

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) uninstall
```
或
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh) uninstall
```
