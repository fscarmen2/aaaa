# 代理服务安装脚本说明

## 目录
- [脚本介绍](#脚本介绍)
- [系统支持](#系统支持)
- [安装方法](#安装方法)
  - [3proxy 安装](#3proxy-安装)
  - [Xray/Sing-box 安装](#xraysing-box-安装)
- [卸载方法](#卸载方法)
- [内核对比](#内核对比)
- [注意事项](#注意事项)

---

## 脚本介绍

本仓库包含两个代理服务安装脚本：

1. `3proxy.sh` - 轻量级代理服务
   - 支持 HTTP 和 SOCKS5 协议
   - 使用系统原生包管理安装
   - 自动配置 systemd 服务

2. `http_socks5.sh` - 高级代理服务
   - 支持 Xray-core 和 Sing-box 两种内核
   - 提供更丰富的协议支持
   - 自动从 GitHub 下载最新版本

---

## 系统支持

### 3proxy.sh
✅ 支持系统：
- Debian/Ubuntu (deb)
- RHEL/CentOS/Fedora (rpm)
- 其他 systemd 系统

❌ 不支持：
- Alpine (musl libc 兼容性问题)
- 非 systemd 系统

### http_socks5.sh
✅ 支持系统：
- 所有 Linux 发行版（包括 Alpine）
- 支持 systemd 和 OpenRC 初始化系统

✅ 支持架构：
- x86_64/amd64
- arm64/aarch64
- armv7/armhf

---

## 安装方法

### 3proxy 安装

```bash
# 下载脚本
curl -O https://example.com/3proxy.sh
chmod +x 3proxy.sh

# 基本安装（使用默认端口）
sudo ./3proxy.sh

# 自定义端口安装
sudo ./3proxy.sh -h 8888 -s 1088
```

### Xray/Sing-box 安装

```bash
# 下载脚本
curl -O https://example.com/http_socks5.sh
chmod +x http_socks5.sh

# 安装 Xray (默认)
sudo ./http_socks5.sh

# 安装 Sing-box
sudo ./http_socks5.sh -t sing-box

# 自定义端口
sudo ./http_socks5.sh -h 8888 -s 1088
```

---

## 卸载方法

### 3proxy 卸载
```bash
sudo ./3proxy.sh -u
```

### Xray/Sing-box 卸载
```bash
sudo ./http_socks5.sh -u
```

---

## 系统支持对比

| 特性               | 3proxy.sh                          | http_socks5.sh                     |
|--------------------|-----------------------------------|-----------------------------------|
| **支持系统**        |                                    |                                    |
| - Debian/Ubuntu    | ✅ 通过.deb包安装                  | ✅ 全功能支持                     |
| - RHEL/CentOS      | ✅ 通过.rpm包安装                  | ✅ 全功能支持                     |
| - Fedora           | ✅ 通过.rpm包安装                  | ✅ 全功能支持                     |
| - Alpine           | ❌ 不兼容musl libc                | ✅ 完整支持                      |
| - 其他Linux        | ⚠️ 仅限systemd系统                | ✅ 支持systemd/OpenRC            |
| **初始化系统**      |                                    |                                    |
| - systemd          | ✅ 完整支持                       | ✅ 完整支持                      |
| - OpenRC           | ❌ 不支持                         | ✅ 完整支持                      |
| **处理器架构**      |                                    |                                    |
| - x86_64/amd64     | ✅ 自动识别                       | ✅ 自动识别                      |
| - arm64/aarch64    | ✅ 自动识别                       | ✅ 自动识别                      |
| - armv7/armhf      | ✅ 自动识别                       | ✅ 自动识别                      |
| - s390x            | ❌ 不支持                         | ❌ 不支持                        |
| **性能**           | 轻量级	                           | 高性能                           |
| **资源占用**        | 极低	                           | 中等                            |
| **特殊限制**        | 依赖系统包管理器(apt/yum/dnf)      | 需要curl/unzip基础工具            |

---

## 注意事项

1. 端口冲突检查：
   - 脚本会自动检查端口占用情况
   - 如遇冲突请修改默认端口

2. 服务管理：
   ```bash
   # 3proxy 服务管理
   sudo systemctl status/restart/stop 3proxy

   # Xray/Sing-box 服务管理
   sudo systemctl status/restart/stop proxy
   ```

3. 日志查看：
   ```bash
   journalctl -u 3proxy -f
   journalctl -u proxy -f
   ```

4. Alpine 系统注意事项：
   - 仅支持 http_socks5.sh
   - 需要手动安装依赖：`apk add curl unzip`

5. 安全建议：
   - 默认仅监听 127.0.0.1
   - 如需外部访问请修改配置文件后重启服务
