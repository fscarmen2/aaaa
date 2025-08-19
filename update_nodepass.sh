#!/bin/bash

# NodePass 更新脚本 - 同时更新稳定版和开发版

set -e

# 设置变量
TEMP_DIR="/tmp/nodepass_update"
WORK_DIR="/etc/nodepass"
GH_PROXY="gh-proxy.com/"

# 清理临时目录
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

# 检查架构
ARCH=$(uname -m)
case "$ARCH" in
  x86_64 | amd64) ARCH="amd64" ;;
  armv8 | arm64 | aarch64) ARCH="arm64" ;;
  armv7l) ARCH="arm" ;;
  s390x) ARCH="s390x" ;;
  *)
    echo "不支持的架构: $ARCH"
    exit 1
    ;;
esac

echo "检测到架构: $ARCH"

# 获取最新版本信息
echo "正在获取最新版本信息..."
STABLE_LATEST_VERSION=$(curl -sL "https://${GH_PROXY}api.github.com/repos/yosebyte/nodepass/releases/latest" | awk -F '"' '/tag_name/{print $4}')
DEV_LATEST_VERSION=$(curl -sL "https://${GH_PROXY}api.github.com/repos/NodePassProject/nodepass-core/releases" | awk -F '"' '/tag_name/{print $4; exit}')

if [ -z "$STABLE_LATEST_VERSION" ] || [ "$STABLE_LATEST_VERSION" = "null" ] || [ -z "$DEV_LATEST_VERSION" ] || [ "$DEV_LATEST_VERSION" = "null" ]; then
  echo "无法获取最新版本"
  exit 1
fi

# 去掉版本号前面的v
STABLE_VERSION_NUM=${STABLE_LATEST_VERSION#v}
DEV_VERSION_NUM=${DEV_LATEST_VERSION#v}

echo "最新稳定版: $STABLE_LATEST_VERSION"
echo "最新开发版: $DEV_LATEST_VERSION"

# 停止服务
echo "正在停止 NodePass 服务..."
systemctl stop nodepass 2>/dev/null || pgrep -f "nodepass" | xargs -r kill -9 2>/dev/null || echo "服务已停止或未运行"

# 备份现有文件
echo "正在备份现有版本..."
cp "$WORK_DIR/stable-nodepass" "$WORK_DIR/stable-nodepass.backup" 2>/dev/null || echo "无现有稳定版可备份"
cp "$WORK_DIR/dev-nodepass" "$WORK_DIR/dev-nodepass.backup" 2>/dev/null || echo "无现有开发版可备份"

# 下载稳定版
echo "正在下载稳定版..."
curl -sL "https://${GH_PROXY}github.com/yosebyte/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
mv "$TEMP_DIR/nodepass" "$WORK_DIR/stable-nodepass"
chmod +x "$WORK_DIR/stable-nodepass"

# 下载开发版
echo "正在下载开发版..."
curl -sL "https://${GH_PROXY}github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
mv "$TEMP_DIR/nodepass-core" "$WORK_DIR/dev-nodepass"
chmod +x "$WORK_DIR/dev-nodepass"

# 链接到稳定版
echo "链接到稳定版..."
ln -sf "$WORK_DIR/stable-nodepass" "$WORK_DIR/nodepass"

# 启动服务
echo "正在启动 NodePass 服务..."
systemctl start nodepass 2>/dev/null || nohup "$WORK_DIR/nodepass" master:// 2>/dev/null &

# 清理
rm -rf $TEMP_DIR

# 显示版本信息
STABLE_VERSION=$("$WORK_DIR/stable-nodepass" 2>/dev/null | sed -n '/Version/s/.*\(v[0-9.]\+[^ ]*\).*/\1/gp')
DEV_VERSION=$("$WORK_DIR/dev-nodepass" 2>/dev/null | sed -n '/Version/s/.*\(v[0-9.]\+[^ ]*\).*/\1/gp')

echo "更新完成!"
echo "稳定版版本: $STABLE_VERSION"
echo "开发版版本: $DEV_VERSION"
echo "当前运行版本: 稳定版"
