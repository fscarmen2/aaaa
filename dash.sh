#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无色

# 检查是否以管理员权限运行
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}请以管理员权限运行此脚本。${NC}"
  exit 1
fi

# 检测系统类型
if [ -f /etc/debian_version ]; then
  OS="debian"
elif [ -f /etc/lsb-release ]; then
  OS="ubuntu"
elif [ -f /etc/redhat-release ]; then
  OS="centos"
  # 检查 CentOS 版本
  CENTOS_VERSION=$(rpm -E '%{rhel}')
  if [ "$CENTOS_VERSION" -lt 8 ]; then
    echo -e "${RED}错误：您的 CentOS 版本 $CENTOS_VERSION 过低。请使用 CentOS 8 或 9 版本。${NC}"
    exit 1
  fi
else
  echo -e "${RED}不支持的操作系统${NC}"
  exit 1
fi

# 检查并安装 curl
if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
  echo -e "${GREEN}curl 和 wget 都未安装，正在安装 curl...${NC}"
  if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
    apt update >/dev/null 2>&1
    apt install -y curl >/dev/null 2>&1
  elif [ "$OS" == "centos" ]; then
    yum install -y curl >/dev/null 2>&1
  fi
fi

# 选择使用 wget 或 curl
if command -v wget &>/dev/null; then
  DOWNLOAD_CMD="wget -qO-"
else
  DOWNLOAD_CMD="curl -fsSL"
fi

# 函数：检查域名或IP地址格式
validate_input() {
  local input=$1
  # 检查是否是有效的IPv4地址
  if [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  # 检查是否是有效的IPv6地址
  elif [[ $input =~ ^[0-9a-fA-F:]+$ ]]; then
    return 0
  # 检查是否是有效的域名
  elif [[ $input =~ ^[a-zA-Z0-9.-]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# 函数：检查端口是否在有效范围内
validate_port() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo -e "${RED}错误：端口号 $port 无效。请提供一个在 1 到 65535 之间的端口号。${NC}"
        return 1
    fi
    return 0
}

# 询问用户输入域名或IP地址
while true; do
  read -p "$(echo -e ${YELLOW}请输入域名或IPv4/IPv6地址（此项为必填）： ${NC})" INPUT
  if validate_input "$INPUT"; then
    echo -e "${GREEN}您输入的内容是: $INPUT${NC}"
    break
  else
    echo -e "${RED}输入无效，请输入有效的域名或IPv4/IPv6地址。${NC}"
  fi
done

# 询问用户使用的端口，默认是3000
while true; do
  read -p "$(echo -e ${YELLOW}请输入要使用的端口（默认3000）： ${NC})" PORT
  PORT=${PORT:-3000} # 如果未输入，则使用默认值3000

  # 验证端口
  if ! validate_port "$PORT"; then
    continue
  fi

  # 检查端口是否被占用
  if command -v lsof &>/dev/null; then
    if lsof -i:$PORT &>/dev/null; then
      echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
      continue
    fi
  elif command -v netstat &>/dev/null; then
    if netstat -tuln | grep ":$PORT" &>/dev/null; then
      echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
      continue
    fi
  elif command -v ss &>/dev/null; then
    if ss -tuln | grep ":$PORT" &>/dev/null; then
      echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
      continue
    fi
  else
    echo -e "${GREEN}未检测到 lsof、netstat 或 ss，正在安装 iproute2...${NC}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
      apt update >/dev/null 2>&1
      apt install -y iproute2 >/dev/null 2>&1
    elif [ "$OS" == "centos" ]; then
      yum install -y iproute >/dev/null 2>&1
    fi
    echo -e "${GREEN}iproute2 安装完成，正在检查端口...${NC}"
    if ss -tuln | grep ":$PORT" &>/dev/null; then
      echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
      continue
    fi
  fi
  break # 端口未被占用，退出循环
done

# 检测容器管理工具并设置变量
if command -v podman &>/dev/null; then
  CONTAINER_CMD="podman"
  echo -e "${GREEN}检测到 Podman，将使用 Podman 作为容器管理工具${NC}"

  # 检查并设置 Podman 的 IPv6 支持
  PODMAN_CONFIG_DIR="$HOME/.config/containers"
  mkdir -p "$PODMAN_CONFIG_DIR"
  PODMAN_CONF="$PODMAN_CONFIG_DIR/containers.conf"

  # 创建或更新 containers.conf 文件以启用 IPv6
  if ! grep -q 'enable_ipv6' "$PODMAN_CONF" 2>/dev/null; then
    echo -e "${GREEN}正在配置 Podman 以支持 IPv6...${NC}"
    {
      echo "[network]"
      echo "enable_ipv6 = true"
    } >> "$PODMAN_CONF"
  else
    echo -e "${GREEN}Podman 已配置为支持 IPv6。${NC}"
  fi

elif command -v docker &>/dev/null; then
  CONTAINER_CMD="docker"
  echo -e "${GREEN}检测到 Docker，将使用 Docker 作为容器管理工具${NC}"
else
  echo -e "${GREEN}未检测到容器管理工具，正在安装 Docker...${NC}"
  # 使用官方脚本安装 Docker
  bash <($DOWNLOAD_CMD get.docker.com) >/dev/null 2>&1
  # 启动 Docker 并开启 IPv6
  systemctl start docker >/dev/null 2>&1
  systemctl enable docker >/dev/null 2>&1
  echo -e "${GREEN}Docker 安装完成，正在开启 IPv6...${NC}"

  # 检查是否存在 daemon.json，如果存在则备份
  DAEMON_JSON="/etc/docker/daemon.json"
  if [ -f $DAEMON_JSON ]; then
    echo -e "${GREEN}检测到已有 daemon.json，正在备份为 daemon.json.bak...${NC}"
    cp $DAEMON_JSON $DAEMON_JSON.bak
    echo -e "${GREEN}备份完成。${NC}"
  fi

  # 创建新的 daemon.json
  cat >$DAEMON_JSON <<EOF
{
  "ipv6": true,
  "fixed-cidr-v6": "fd00::/80",
  "experimental": true,
  "ip6tables": true
}
EOF
  echo -e "${GREEN}daemon.json 已创建，内容如下：${NC}"
  cat $DAEMON_JSON

  # 重启 Docker 服务
  systemctl restart docker >/dev/null 2>&1
  CONTAINER_CMD="docker"
  echo -e "${GREEN}Docker 服务已重启。${NC}"
fi

# 检测 Caddy 是否已安装
if ! [[ "$INPUT" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [[ "$INPUT" =~ ^[0-9a-fA-F:]+$ ]]; then  
  if ! command -v caddy &>/dev/null; then
    echo -e "${GREEN}Caddy 未安装，正在安装...${NC}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
      apt update >/dev/null 2>&1
      apt install -y debian-keyring debian-archive-keyring >/dev/null 2>&1
      $DOWNLOAD_CMD 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --yes --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
      $DOWNLOAD_CMD 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null 2>&1
      apt update >/dev/null 2>&1
      apt install -y caddy >/dev/null 2>&1
    elif [ "$OS" == "centos" ]; then
      dnf install 'dnf-command(copr)' >/dev/null 2>&1
      dnf -y copr enable @caddy/caddy >/dev/null 2>&1
      dnf install -y caddy >/dev/null 2>&1
    fi

    # 检查 Caddy 安装是否成功
    if ! command -v caddy &>/dev/null; then
      echo -e "${RED}Caddy 安装失败，请检查错误信息。${NC}"
      exit 1
    else
      echo -e "${GREEN}Caddy 安装完成${NC}"
    fi
  else
    echo -e "${GREEN}Caddy 已安装${NC}"
  fi

  # 创建 Caddyfile
  CADDYFILE="/etc/caddy/Caddyfile"

  # 检查是否存在 Caddyfile，如果存在则备份
  if [ -f $CADDYFILE ]; then
    echo -e "${GREEN}检测到已有 Caddyfile，正在备份为 Caddyfile.bak...${NC}"
    cp $CADDYFILE $CADDYFILE.bak
    echo -e "${GREEN}备份完成。${NC}"
  fi

  # 创建新的 Caddyfile
  cat >$CADDYFILE <<EOF
$INPUT {
    reverse_proxy localhost:$PORT
}
EOF
  echo -e "${GREEN}Caddyfile 已创建，内容如下：${NC}"
  cat $CADDYFILE

  # 重启 Caddy 服务
  echo -e "${GREEN}正在重启 Caddy 服务...${NC}"
  systemctl restart caddy >/dev/null 2>&1
  echo -e "${GREEN}Caddy 服务已重启。${NC}"
fi

# 创建 nodepassdash 目录
mkdir -p ~/nodepassdash/logs ~/nodepassdash/public

# 检查 nodepassdash 容器是否已存在
if $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
  echo -e "${RED}nodepassdash 容器已存在，退出脚本。${NC}"
  exit 1
fi

# 下载最新的镜像并运行容器
echo -e "${GREEN}正在下载最新的 nodepassdash 镜像...${NC}"
$CONTAINER_CMD pull ghcr.io/nodepassproject/nodepassdash:latest

echo -e "${GREEN}正在运行 nodepassdash 容器...${NC}"
$CONTAINER_CMD run -d \
  --name nodepassdash \
  --restart always \
  -p $PORT:3000 \
  -v ~/nodepassdash/logs:/app/logs \
  -v ~/nodepassdash/public:/app/public \
  ghcr.io/nodepassproject/nodepassdash:latest

# 获取容器日志并提取管理员账户信息
echo -e "${GREEN}获取面板和管理员账户信息...${NC}"

# 等待 5 秒以确保服务启动
sleep 5

# 显示面板地址
if [[ "$INPUT" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${GREEN}面板地址: http://$INPUT:$PORT${NC}"
elif [[ "$INPUT" =~ ^[0-9a-fA-F:]+$ ]]; then
  echo -e "${GREEN}面板地址: http://[$INPUT]:$PORT${NC}"
else
  echo -e "${GREEN}面板地址: https://$INPUT${NC}"
fi

$CONTAINER_CMD logs nodepassdash 2>&1 | grep -A 5 "管理员账户信息："
