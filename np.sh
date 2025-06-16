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
else
  echo -e "${RED}不支持的操作系统${NC}"
  exit 1
fi

# 检查并安装 curl 或 wget
if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
  echo -e "${GREEN}curl 和 wget 都未安装，正在安装 curl...${NC}"
  if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
    apt update >/dev/null 2>&1
    apt install -y curl >/dev/null 2>&1
  elif [ "$OS" == "centos" ]; then
    yum install -y curl >/dev/null 2>&1
  fi
fi

# 选择下载命令
if command -v wget &>/dev/null; then
  DOWNLOAD_CMD="wget -qO-"
else
  DOWNLOAD_CMD="curl -fsSL"
fi

# 检查并选择容器命令（优先使用 Podman）
if command -v podman &>/dev/null; then
  CONTAINER_CMD="podman"
  echo -e "${GREEN}已检测到 Podman，将使用 Podman 执行容器相关操作。${NC}"
else
  if ! command -v docker &>/dev/null; then
    echo -e "${GREEN}Podman 和 Docker 都未安装，正在安装 Docker...${NC}"
    bash <($DOWNLOAD_CMD get.docker.com) >/dev/null 2>&1
    systemctl start docker >/dev/null 2>&1
    systemctl enable docker >/dev/null 2>&1
    echo -e "${GREEN}Docker 安装完成。${NC}"
    DAEMON_JSON="/etc/docker/daemon.json"
    if [ -f $DAEMON_JSON ]; then
      cp $DAEMON_JSON $DAEMON_JSON.bak
    fi
    cat >$DAEMON_JSON <<EOF
{
  "ipv6": true,
  "fixed-cidr-v6": "fd00::/80",
  "experimental": true,
  "ip6tables": true
}
EOF
    systemctl restart docker >/dev/null 2>&1
    echo -e "${GREEN}Docker 服务已重启。${NC}"
  else
    echo -e "${GREEN}Docker 已安装。${NC}"
  fi
  CONTAINER_CMD="docker"
fi

# 验证输入格式
validate_input() {
  local input=$1
  if [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  elif [[ $input =~ ^[0-9a-fA-F:]+$ ]]; then
    return 0
  elif [[ $input =~ ^[a-zA-Z0-9.-]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# 输入域名或IP
while true; do
  read -p "$(echo -e ${YELLOW}请输入域名或IPv4/IPv6地址（此项为必填）： ${NC})" INPUT
  if validate_input "$INPUT"; then
    echo -e "${GREEN}您输入的内容是: $INPUT${NC}"
    break
  else
    echo -e "${RED}输入无效，请输入有效的域名或IPv4/IPv6地址。${NC}"
  fi
done

# 输入端口号
while true; do
  read -p "$(echo -e ${YELLOW}请输入要使用的端口（默认3000）： ${NC})" PORT
  PORT=${PORT:-3000}
  if command -v lsof &>/dev/null && lsof -i:$PORT &>/dev/null; then
    echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
    continue
  elif command -v netstat &>/dev/null && netstat -tuln | grep ":$PORT" &>/dev/null; then
    echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
    continue
  elif command -v ss &>/dev/null && ss -tuln | grep ":$PORT" &>/dev/null; then
    echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
    continue
  fi
  break
done

# 安装 Caddy
if [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+$ ]]; then
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
      dnf install -y 'dnf-command(copr)' >/dev/null 2>&1
      dnf -y copr enable @caddy/caddy >/dev/null 2>&1
      dnf -y install caddy >/dev/null 2>&1
    fi
  fi
  CADDYFILE="/etc/caddy/Caddyfile"
  if [ -f $CADDYFILE ]; then
    cp $CADDYFILE $CADDYFILE.bak
  fi
  cat >$CADDYFILE <<EOF
$INPUT {
    reverse_proxy localhost:$PORT
}
EOF
  echo -e "${GREEN}正在重启 Caddy 服务...${NC}"
  systemctl restart caddy >/dev/null 2>&1
fi

# 创建目录
mkdir -p ~/nodepassdash/logs ~/nodepassdash/public

# 检查容器是否已存在
if $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
  echo -e "${RED}nodepassdash 容器已存在，退出脚本。${NC}"
  exit 1
fi

# 拉取镜像并运行容器
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

# 获取日志
sleep 5
if [[ "$INPUT" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${GREEN}面板地址: http://$INPUT:$PORT${NC}"
elif [[ "$INPUT" =~ ^[0-9a-fA-F:]+$ ]]; then
  echo -e "${GREEN}面板地址: http://[$INPUT]:$PORT${NC}"
else
  echo -e "${GREEN}面板地址: https://$INPUT${NC}"
fi

$CONTAINER_CMD logs nodepassdash 2>&1 | grep -A 5 "管理员账户信息："
