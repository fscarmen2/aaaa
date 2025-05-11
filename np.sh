#!/usr/bin/env bash

# 当前脚本版本号
VERSION='0.0.1'

# 环境变量用于在Debian或Ubuntu操作系统中设置非交互式（noninteractive）安装模式
export DEBIAN_FRONTEND=noninteractive

# Github 反代加速代理
GH_PROXY='https://ghfast.top/'

# 工作目录和临时目录
TEMP_DIR='/tmp/nodepass'
WORK_DIR='/etc/nodepass'

trap "rm -rf $TEMP_DIR >/dev/null 2>&1 ; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

E[0]="\n Language:\n 1. 简体中文 (default)\n 2. English"
C[0]="${E[0]}"
E[1]="1. Client's Warp mode (network interface) has been fixed to deal with the problem that it does not work after reboot; 2. Fixed the regularity of Team IPv6 judgment."
C[1]="1. Client 的 Warp 模式(网络接口)处理了重启后不工作的问题; 2. 修正 Team IPv6 判断的正则"
E[2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/NodePassProject/nodepass-core/issues]"
C[2]="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/NodePassProject/nodepass-core/issues]"
E[3]="Unsupported architecture: \$(uname -m)"
C[3]="不支持的架构: \$(uname -m)"
E[4]="Please choose: "
C[4]="请选择: "
E[5]="The script supports Linux systems only. Feedback: [https://github.com/NodePassProject/nodepass-core/issues]"
C[5]="本脚本只支持 Linux 系统，问题反馈:[https://github.com/NodePassProject/nodepass-core/issues]"
E[6]="NodePass help menu"
C[6]="NodePass 帮助菜单"
E[7]="Install dependence-list:"
C[7]="安装依赖列表:"
E[8]="Failed to install download tool (curl). Please install wget or curl manually."
C[8]="无法安装下载工具（curl）。请手动安装 wget 或 curl。"
E[9]="Failed to download or extract"
C[9]="下载或解压失败"
E[10]="NodePass installed successfully!"
C[10]="NodePass 安装成功！"
E[11]="NodePass has been uninstalled"
C[11]="NodePass 已卸载"
E[12]="Please enter the correct server IP (press Enter for localhost 127.0.0.1):"
C[12]="请输入确认的服务器 IP (直接回车使用本地地址 127.0.0.1):"
E[13]="Please enter the port (1000-65535, leave empty for random port):"
C[13]="请输入端口 (1000-65535，留空则使用随机端口):"
E[14]="Please enter API prefix (default path is /):"
C[14]="请输入 API 前缀 (可选API路径默认/):"
E[15]="Please select TLS mode (leave empty for no TLS encryption):"
C[15]="请选择TLS模式 (留空表示不使用TLS加密):"
E[16]="0. No TLS encryption (plain TCP/UDP) - Fastest performance, no overhead (default)\n 1. Self-signed certificate (auto-generated) - Good security with simple setup\n 2. Custom certificate (requires pre-prepared crt and key files) - Highest security with certificate validation"
C[16]="0. 不使用TLS加密（明文TCP/UDP） - 最快性能，无开销（默认）\n 1. 自签名证书（自动生成） - 设置简单的良好安全性\n 2. 自定义证书（须预先准备好crt和key证书文件） - 具有证书验证的最高安全性"
E[17]="Please enter the correct option"
C[17]="请输入正确的选项"
E[18]="NodePass is already installed, please uninstall it first if you want to reinstall"
C[18]="NodePass 已安装，如需重新安装请先卸载"
E[19]="Starting to download NodePass \$LATEST_VERSION ..."
C[19]="开始下载 NodePass \$LATEST_VERSION ..."
E[20]="Failed to get latest version information"
C[20]="无法获取最新版本信息"
E[21]="Running in container environment, skipping service creation and starting process directly"
C[21]="在容器环境中运行，跳过服务创建，直接启动进程"
E[22]="NodePass Script Usage / NodePass 脚本使用方法:\n $(basename $0)          - Show menu / 显示菜单\n $(basename $0) -i       - Install NodePass / 安装 NodePass\n $(basename $0) -u       - Uninstall NodePass / 卸载 NodePass\n $(basename $0) -v       - Upgrade NodePass / 升级 NodePass\n $(basename $0) -o       - Toggle service status (start/stop) / 切换服务状态（开启/停止)\n $(basename $0) -s       - Show NodePass API info / 显示 NodePass API 信息\n $(basename $0) -h       - Show help information / 显示帮助信息"
C[22]="${E[22]}"
E[23]="Please enter the path to your SSL certificate file (*.crt, *.pem):"
C[23]="请输入您的 SSL 证书文件路径 (*.crt, *.pem):"
E[24]="Please enter the path to your SSL private key file (*.key):"
C[24]="请输入您的 SSL 私钥文件路径 (*.key):"
E[25]="Certificate file does not exist:"
C[25]="证书文件不存在:"
E[26]="Private key file does not exist:"
C[26]="私钥文件不存在:"
E[27]="Using custom SSL certificate"
C[27]="使用自定义 SSL 证书"
E[28]="Install NodePass"
C[28]="安装 NodePass"
E[29]="Uninstall NodePass"
C[29]="卸载 NodePass"
E[30]="Upgrade NodePass"
C[30]="升级 NodePass"
E[31]="Exit"
C[31]="退出"
E[32]="Not install"
C[32]="未安装"
E[33]="stop"
C[33]="停止"
E[34]="running"
C[34]="运行中"
E[35]="NodePass Installation Information:"
C[35]="NodePass 安装信息:"
E[36]="Port is already in use, please try another one."
C[36]="端口已被占用，请尝试其他端口。"
E[37]="Using random port:"
C[37]="使用随机端口:"
E[38]="Please select: "
C[38]="请选择: "
E[39]="API URL:"
C[39]="API URL:"
E[40]="API KEY:"
C[40]="API KEY:"
E[41]="Invalid port number, please enter a number between 1000 and 65535."
C[41]="无效的端口号，请输入1000到65535之间的数字。"
E[42]="NodePass service has been stopped"
C[42]="NodePass 服务已关闭"
E[43]="NodePass service has been started"
C[43]="NodePass 服务已开启"
E[44]="Unable to get local version information"
C[44]="无法获取本地版本信息"
E[45]="Local version: \$LOCAL_VERSION"
C[45]="本地版本: \$LOCAL_VERSION"
E[46]="Latest version: \$LATEST_VERSION"
C[46]="最新版本: \$LATEST_VERSION"
E[47]="Current version is already the latest, no need to upgrade"
C[47]="当前已是最新版本，不需要升级"
E[48]="Found new version, upgrade? (y/N)"
C[48]="发现新版本，是否升级？(y/N)"
E[49]="Upgrade cancelled"
C[49]="取消升级"
E[50]="Stopping NodePass service..."
C[50]="停止 NodePass 服务..."
E[51]="Starting NodePass service..."
C[51]="启动 NodePass 服务..."
E[52]="NodePass upgrade successful!"
C[52]="NodePass 升级成功！"
E[53]="NodePass service failed to start, please check logs"
C[53]="NodePass 服务启动失败，请检查日志"
E[54]="Rolled back to old version"
C[54]="已回滚到旧版本"
E[55]="Rollback failed, please check manually"
C[55]="回滚失败，请手动检查"
E[56]="Stop service"
C[56]="关闭服务"
E[57]="Create shortcut [ np ] successfully."
C[57]="创建快捷 [ np ] 指令成功!"
E[58]="Start service"
C[58]="开启服务"
E[59]="NodePass is not installed. Configuration file not found"
C[59]="NodePass 未安装，配置文件不存在"
E[60]="NodePass status:"
C[60]="NodePass 状态:"

# 自定义字体彩色，read 函数
warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 红色
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; }  # 红色
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 绿色
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 黄色
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

# 显示帮助信息
help() {
  hint " ${E[22]} "
}

# 必须以root运行脚本
check_root() {
  [ "$(id -u)" != 0 ] && error " $(text 2) "
}

# 检查系统要求
check_system() {
  # 只判断是否为 Linux 系统
  [ "$(uname -s)" != "Linux" ] && error " $(text 5) "

  # 检测是否在容器环境中
  if grep -q 'container=\|docker\|lxc' /proc/1/environ 2>/dev/null || [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then
    IN_CONTAINER=1
    SERVICE_MANAGE="none"
  else
    IN_CONTAINER=0
  fi

  # 自定义 Alpine 系统若干函数
  if grep -qi 'alpine' /etc/os-release 2>/dev/null; then
    PACKAGE_INSTALL='apk add'
    PACKAGE_UPDATE='apk update'
    PACKAGE_UNINSTALL='apk del'
    SERVICE_MANAGE='rc-service'
    SERVICE_START='rc-service nodepass start'
    SERVICE_STOP='rc-service nodepass stop'
    SERVICE_RESTART='rc-service nodepass restart'
    SERVICE_STATUS='rc-service nodepass status'
    SYSTEMCTL='rc-service'
    SYSTEMCTL_ENABLE='rc-update add nodepass'
    SYSTEMCTL_DISABLE='rc-update del nodepass'

  # 自定义 Arch 系统若干函数
  elif grep -qi 'arch' /etc/os-release 2>/dev/null; then
    PACKAGE_INSTALL='pacman -S --noconfirm'
    PACKAGE_UPDATE='pacman -Syu --noconfirm'
    PACKAGE_UNINSTALL='pacman -R --noconfirm'
    SERVICE_MANAGE='systemctl'
    SERVICE_START='systemctl start nodepass'
    SERVICE_STOP='systemctl stop nodepass'
    SERVICE_RESTART='systemctl restart nodepass'
    SERVICE_STATUS='systemctl status nodepass'
    SYSTEMCTL='systemctl'
    SYSTEMCTL_ENABLE='systemctl enable nodepass'
    SYSTEMCTL_DISABLE='systemctl disable nodepass'

  # 自定义 Debian 和 Ubuntu 系统若干函数
  elif grep -qi 'debian\|ubuntu' /etc/os-release 2>/dev/null; then
    PACKAGE_INSTALL='apt-get -y install'
    PACKAGE_UPDATE='apt-get update'
    PACKAGE_UNINSTALL='apt-get -y autoremove'
    SERVICE_MANAGE='systemctl'
    SERVICE_START='systemctl start nodepass'
    SERVICE_STOP='systemctl stop nodepass'
    SERVICE_RESTART='systemctl restart nodepass'
    SERVICE_STATUS='systemctl status nodepass'
    SYSTEMCTL='systemctl'
    SYSTEMCTL_ENABLE='systemctl enable nodepass'
    SYSTEMCTL_DISABLE='systemctl disable nodepass'

  # 自定义 CentOS 和 Fedora 系统若干函数
  elif grep -qi 'centos\|fedora' /etc/os-release 2>/dev/null; then
    PACKAGE_INSTALL='yum -y install'
    PACKAGE_UPDATE='yum -y update'
    PACKAGE_UNINSTALL='yum -y autoremove'
    SERVICE_MANAGE='systemctl'
    SERVICE_START='systemctl start nodepass'
    SERVICE_STOP='systemctl stop nodepass'
    SERVICE_RESTART='systemctl restart nodepass'
    SERVICE_STATUS='systemctl status nodepass'
    SYSTEMCTL='systemctl'
    SYSTEMCTL_ENABLE='systemctl enable nodepass'
    SYSTEMCTL_DISABLE='systemctl disable nodepass'

  # 默认使用通用的系统命令
  else
    PACKAGE_INSTALL='apt-get -y install'
    PACKAGE_UPDATE='apt-get update'
    PACKAGE_UNINSTALL='apt-get -y autoremove'
    SERVICE_MANAGE='systemctl'
    SERVICE_START='systemctl start nodepass'
    SERVICE_STOP='systemctl stop nodepass'
    SERVICE_RESTART='systemctl restart nodepass'
    SERVICE_STATUS='systemctl status nodepass'
    SYSTEMCTL='systemctl'
    SYSTEMCTL_ENABLE='systemctl enable nodepass'
    SYSTEMCTL_DISABLE='systemctl disable nodepass'
  fi
}

# 检查安装状态，状态码: 2 未安装， 1 已安装未运行， 0 运行中
check_install() {
  if [ ! -f "$WORK_DIR/nodepass" ]; then
    return 2
  elif [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      if pgrep -f "nodepass" &>/dev/null; then
        return 0
      else
        return 1
      fi
    else
      if ps -ef | grep -v grep | grep -q "nodepass"; then
        return 0
      else
        return 1
      fi
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ] && ! systemctl is-active nodepass &>/dev/null; then
    return 1
  elif [ "$SERVICE_MANAGE" = "rc-service" ] && ! rc-service nodepass status &>/dev/null; then
    return 1
  else
    return 0
  fi
}

# 安装系统依赖及定义下载工具
check_dependencies() {
  DEPS_INSTALL=()

  # 检查 wget 和 curl
  if [ -x "$(type -p wget)" ]; then
    DOWNLOAD_TOOL="wget"
    DOWNLOAD_CMD="wget -q"
  elif [ -x "$(type -p curl)" ]; then
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  else
    # 如果都没有，安装 curl
    DEPS_INSTALL+=("curl")
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  fi

  # 检查是否有 ps 或 pkill 命令
  if [ ! -x "$(type -p ps)" ] && [ ! -x "$(type -p pkill)" ]; then
    # 根据不同系统添加对应的包名
    if grep -qi 'alpine' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps")
    elif grep -qi 'debian\|ubuntu' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps")
    elif grep -qi 'centos\|fedora' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps-ng")
    elif grep -qi 'arch' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps-ng")
    else
      DEPS_INSTALL+=("procps")
    fi
  fi

  # 检查其他依赖
  local DEPS_CHECK=("tar")
  local PACKAGE_DEPS=("tar")

  for g in "${!DEPS_CHECK[@]}"; do
    [ ! -x "$(type -p ${DEPS_CHECK[g]})" ] && DEPS_INSTALL+=("${PACKAGE_DEPS[g]}")
  done

  if [ "${#DEPS_INSTALL[@]}" -gt 0 ]; then
    info "\n $(text 7) ${DEPS_INSTALL[@]} \n"
    ${PACKAGE_UPDATE} >/dev/null 2>&1
    ${PACKAGE_INSTALL} ${DEPS_INSTALL[@]} >/dev/null 2>&1
  fi
}

# 检查架构
check_arch() {
  # 判断架构
  case "$(uname -m)" in
    x86_64 )
      ARCH="amd64"
      ;;
    aarch64 | arm64 )
      ARCH="arm64"
      ;;
    armv7l )
      ARCH="arm"
      ;;
    * )
      error " $(text 3) "
      ;;
  esac
}

# 检查端口是否可用
check_port() {
  local PORT=$1
  if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1000 ] || [ "$PORT" -gt 65535 ]; then
    return 1
  fi

  # 检查端口是否被占用
  # 方法1: 使用 nc 命令
  if [ $(type -p nc) ]; then
    nc -z 127.0.0.1 "$PORT" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      return 1
    fi
  # 方法2: 使用 lsof 命令
  elif [ $(type -p lsof) ]; then
    lsof -i:"$PORT" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      return 1
    fi
  # 方法3: 使用 netstat 命令
  elif [ $(type -p netstat) ]; then
    netstat -nltup 2>/dev/null | grep -q ":$PORT "
    if [ $? -eq 0 ]; then
      return 1
    fi
  # 方法4: 使用 ss 命令
  elif [ $(type -p ss) ]; then
    ss -nltup 2>/dev/null | grep -q ":$PORT "
    if [ $? -eq 0 ]; then
      return 1
    fi
  # 方法5: 尝试使用/dev/tcp检查
  else
    (echo >/dev/tcp/127.0.0.1/"$PORT") >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      return 1
    fi
  fi

  return 0
}

# 检测是否需要启用 Github CDN，如能直接连通，则不使用
check_cdn() {
  if [ -n "$GH_PROXY" ]; then
    if [ "$DOWNLOAD_TOOL" = "wget" ]; then
      wget --server-response --quiet --output-document=/dev/null --no-check-certificate --tries=2 --timeout=3 https://raw.githubusercontent.com/NodePassProject/nodepass-core/refs/heads/main/README.md >/dev/null 2>&1 && unset GH_PROXY
    else
      curl -sL --connect-timeout 3 --max-time 3 https://raw.githubusercontent.com/NodePassProject/nodepass-core/refs/heads/main/README.md -o /dev/null >/dev/null 2>&1 && unset GH_PROXY
    fi
  fi
}

# 选择语言，先判断 ${WORK_DIR}/language 里的语言选择，没有的话再让用户选择，默认英语。处理中文显示的问题
select_language() {
  UTF8_LOCALE=$(locale -a 2>/dev/null | grep -iEm1 "UTF-8|utf8")
  [ -n "$UTF8_LOCALE" ] && export LC_ALL="$UTF8_LOCALE" LANG="$UTF8_LOCALE" LANGUAGE="$UTF8_LOCALE"

  # 优先使用命令行参数指定的语言
  if [ -n "$ARGS_LANGUAGE" ]; then
    case "$ARGS_LANGUAGE" in
      1|zh|CN|cn|chinese|C|c)
        L=C
        ;;
      2|en|EN|english|E|e)
        L=E
        ;;
      *)
        L=C  # 默认使用中文
        ;;
    esac
  # 其次读取保存的配置信息
  elif [ -s ${WORK_DIR}/data ]; then
    source ${WORK_DIR}/data
    L=$LANGUAGE
  # 最后使用交互方式选择
  else
    L=C && hint " $(text 0) \n" && reading " $(text 4) " LANGUAGE_CHOICE
    [ "$LANGUAGE_CHOICE" = 2 ] && L=E
  fi
}

# 查询 NodePass API URL
get_api_url() {
  # 从data文件中获取SERVER_IP
  [ -s "$WORK_DIR/data" ] && source "$WORK_DIR/data"

  # 检查是否已安装
  if [ -s "$WORK_DIR/nodepass.gob" ]; then
    # 在容器环境中直接从进程命令行获取参数
    if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
      if [ $(type -p pgrep) ]; then
        local CMD_LINE=$(pgrep -af "nodepass" | grep -v "grep\|sed" | sed -n 's/.*nodepass \(.*\)/\1/p')
      else
        local CMD_LINE=$(ps -ef | grep -v "grep\|sed" | grep "nodepass" | sed -n 's/.*nodepass \(.*\)/\1/p')
      fi
    # 根据不同系统类型获取守护文件路径
    elif [ "$SERVICE_MANAGE" = "systemctl" ] && [ -s "/etc/systemd/system/nodepass.service" ]; then
      local CMD_LINE=$(sed -n 's/.*ExecStart=.*\(master.*\)"/\1/p' "/etc/systemd/system/nodepass.service")
    elif [ "$SERVICE_MANAGE" = "rc-service" ] && [ -s "/etc/init.d/nodepass" ]; then
      # 从OpenRC服务文件中提取CMD行
      local CMD_LINE=$(sed -n 's/.*command_args.*\(master.*\)/\1/p' "/etc/init.d/nodepass")
    fi

    # 如果找到了CMD行，通过正则提取各个参数
    if [ -n "$CMD_LINE" ]; then
      PORT=$(sed -n 's#.*:\([0-9]\+\)\/.*#\1#p' <<< "$CMD_LINE")
      PREFIX=$(sed -n 's#.*/\([^?]*\).*#\1#p' <<< "$CMD_LINE")
      LOG_LEVEL=$(sed -n 's#.*log=\([^&]*\).*#\1#p' <<< "$CMD_LINE")
      TLS_MODE=$(sed -n 's#.*tls=\([^&]*\).*#\1#p' <<< "$CMD_LINE")
      grep -qw '0' <<< "$TLS_MODE" && HTTP_S="http" || HTTP_S="https"
    fi

    # 处理IPv6地址格式
    grep -q ':' <<< "$SERVER_IP" && URL_SERVER_IP="[$SERVER_IP]" || URL_SERVER_IP="$SERVER_IP"

    # 构建API URL
    API_URL="${HTTP_S}://${URL_SERVER_IP}:${PORT}/${PREFIX:+${PREFIX%/}/}v1"
    grep -q 'output' <<< "$1" && info " $(text 39) $API_URL "
  else
    warning " $(text 59) "
  fi
}

# 查询 NodePass TOKEN
get_token() {
  # 从nodepass.gob文件中提取TOKEN
  if [ -s "$WORK_DIR/nodepass.gob" ]; then
    TOKEN=$(grep -a -o '[0-9a-f]\{32\}' $WORK_DIR/nodepass.gob)
    grep -q 'output' <<< "$1" && info " $(text 40) $TOKEN "
  else
    warning " $(text 59) "
  fi
}

# 获取随机可用端口，目标范围是 1024-8192，共7168个
get_random_port() {
  local RANDOM_PORT
  while true; do
    RANDOM_PORT=$((RANDOM % 7168 + 1024))
    check_port "$RANDOM_PORT" && break
  done
  echo "$RANDOM_PORT"
}

# 获取最新版本
get_latest_version() {
  # 获取最新版本号
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    LATEST_VERSION=$(wget -qO- "${GH_PROXY}https://api.github.com/repos/yosebyte/nodepass/releases/latest" | awk -F '"' '/tag_name/{print $4}')
  else
    LATEST_VERSION=$(curl -sL "${GH_PROXY}https://api.github.com/repos/yosebyte/nodepass/releases/latest" | awk -F '"' '/tag_name/{print $4}')
  fi

  if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
    error " $(text 20) "
  fi

  # 去掉版本号前面的v
  VERSION_NUM=${LATEST_VERSION#v}
}

# 切换 NodePass 服务状态（开启/停止）
on_off() {
  # 检查当前状态
  local INSTALL_STATUS=$1

  # 根据不同系统和当前状态执行不同操作
  if [ $INSTALL_STATUS -eq 0 ]; then
    # 服务正在运行，停止服务
    info " $(text 50) "
    stop_nodepass
    
    # 等待服务状态变更
    sleep 2
    
    # 检查服务是否已停止
    check_install
    local NEW_STATUS=$?
    [ $NEW_STATUS -eq 1 ] && info " $(text 42) " || warning " $(text 53) "
  else
    # 服务未运行，启动服务
    info " $(text 51) "
    start_nodepass
    
    # 等待服务状态变更
    sleep 2
    
    # 检查服务是否已启动
    check_install
    local NEW_STATUS=$?
    [ $NEW_STATUS -eq 0 ] && info " $(text 43) " || warning " $(text 53) "
  fi
}

# 启动 NodePass 服务
start_nodepass() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    nohup "$WORK_DIR/nodepass" "$CMD" >/dev/null 2>&1 &
    sleep 2
    if [ $(type -p pgrep) ]; then
      pgrep -f "nodepass" &>/dev/null
      return $?
    else
      ps -ef | grep -v grep | grep -q "nodepass"
      return $?
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl start nodepass
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass start
  else
    nohup "$WORK_DIR/nodepass" "$CMD" >/dev/null 2>&1 &
  fi

  # 检查服务是否成功启动
  sleep 2
  if [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl is-active nodepass &>/dev/null
    return $?
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass status &>/dev/null
    return $?
  else
    if [ $(type -p pgrep) ]; then
      pgrep -f "nodepass" &>/dev/null
      return $?
    else
      ps -ef | grep -v grep | grep -q "nodepass"
      return $?
    fi
  fi
}

# 停止 NodePass
stop_nodepass() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    # 容器环境下的停止方法
    if [ $(type -p pgrep) ]; then
      # 首先尝试正常终止进程
      pkill -f "nodepass"
      sleep 1
      
      # 检查是否有僵尸进程，直接强制终止进程
      local ZOMBIE_PIDS=$(pgrep -laf "nodepass.*defunct" | awk '{print $1}')
      if [ -n "$ZOMBIE_PIDS" ]; then
        for pid in $ZOMBIE_PIDS; do
          kill -9 $pid 2>/dev/null
        done
      fi
      
      # 如果还有任何nodepass进程存在，使用强制终止
      pgrep -f "nodepass" &>/dev/null && pkill -9 -f "nodepass"
    else
      # 如果没有pgrep/pkill命令，尝试使用ps和kill
      ps -ef | grep -v grep | grep "nodepass" | awk '{print $2}' | xargs -r kill
      sleep 1
      
      # 检查是否有僵尸进程，直接强制终止
      local ZOMBIE_PIDS=$(ps -ef | grep -v grep | grep "nodepass.*defunct" | awk '{print $2}')
      if [ -n "$ZOMBIE_PIDS" ]; then
        for pid in $ZOMBIE_PIDS; do
          kill -9 $pid 2>/dev/null
        done
      fi
      
      # 如果还有进程存在，使用强制终止
      ps -ef | grep -v grep | grep -q "nodepass" && ps -ef | grep -v grep | grep "nodepass" | awk '{print $2}' | xargs -r kill -9
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl stop nodepass
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass stop
  fi
}

# 升级 NodePass
upgrade_nodepass() {
  # 获取本地版本
  local LOCAL_VERSION=$(${WORK_DIR}/nodepass -v 2>/dev/null | sed -n '/Version/s/.*\(v[0-9.]\+\).*/\1/gp')

  if [ -z "$LOCAL_VERSION" ]; then
    warning " $(text 44) "
    return 1
  fi

  # 获取远程最新版本
  get_latest_version
  info "\n $(text 45) "
  info " $(text 46) "

  # 比较版本
  if [ "$LOCAL_VERSION" = "$LATEST_VERSION" ]; then
    info " $(text 47) "
    return 0
  fi

  # 询问用户是否升级
  reading " $(text 48) " UPGRADE_CHOICE

  if [ "${UPGRADE_CHOICE,,}" != "y" ]; then
    info " $(text 49) "
    return 0
  fi

  # 停止服务
  info " $(text 50) "
  stop_nodepass

  # 下载并解压新版本
  info " $(text 50) "
  stop_nodepass

  # 备份旧版本
  cp "$WORK_DIR/nodepass" "$WORK_DIR/nodepass.old"

  # 下载新版本
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    wget "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
  else
    curl -sL "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
  fi

  if [ ! -f "$TEMP_DIR/nodepass" ]; then
    warning " $(text 9) "
    # 恢复旧版本
    mv "$WORK_DIR/nodepass.old" "$WORK_DIR/nodepass"
    info " $(text 54) "
    return 1
  fi

  # 移动到工作目录
  mv "$TEMP_DIR/nodepass" "$WORK_DIR/"
  chmod +x "$WORK_DIR/nodepass"

  # 启动服务
  info " $(text 51) "
  if start_nodepass; then
    info " $(text 52) "
    # 删除备份
    rm -f "$WORK_DIR/nodepass.old"
  else
    warning " $(text 53) "
    # 回滚
    mv "$WORK_DIR/nodepass.old" "$WORK_DIR/nodepass"
    if start_nodepass; then
      info " $(text 54) "
    else
      error " $(text 55) "
    fi
  fi
}

# 解析命令行参数
parse_args() {
  # 初始化变量
  unset ARGS_SERVER_IP ARGS_PORT ARGS_PREFIX ARGS_TLS_MODE ARGS_LANGUAGE ARGS_CERT_FILE ARGS_KEY_FILE

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --server_ip)
        ARGS_SERVER_IP="$2"
        shift 2
        ;;
      --user_port)
        ARGS_PORT="$2"
        shift 2
        ;;
      --prefix)
        ARGS_PREFIX="$2"
        shift 2
        ;;
      --tls_mode)
        ARGS_TLS_MODE="$2"
        shift 2
        ;;
      --language)
        ARGS_LANGUAGE="$2"
        shift 2
        ;;
      --cert_file)
        ARGS_CERT_FILE="$2"
        shift 2
        ;;
      --key_file)
        ARGS_KEY_FILE="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
}

# 主安装函数
install() {
  # 处理 SERVER_IP 的函数
  process_server_ip() {
    local IP="$1"
    # 如果为空或者是本地地址的各种形式，都统一为 127.0.0.1
    if [ -z "$IP" ] || [ "$IP" = "127.0.0.1" ] || [ "$IP" = "::1" ] || [ "$IP" = "localhost" ]; then
      SERVER_IP="127.0.0.1"
      LOCALHOST="127.0.0.1"
    else
      SERVER_IP="$IP"
      LOCALHOST=""
    fi
  }

  # 服务器 IP
  if [ -n "$ARGS_SERVER_IP" ]; then
    process_server_ip "$ARGS_SERVER_IP"
  else
    while true; do
      reading "\n (1/4) $(text 12) " USER_INPUT
      process_server_ip "$USER_INPUT"
      break
    done
  fi
  grep -q ':' <<< "$SERVER_IP" && URL_SERVER_IP="[$SERVER_IP]" || URL_SERVER_IP="$SERVER_IP"

  # 端口
  if [ -n "$ARGS_PORT" ]; then
    PORT="$ARGS_PORT"
    if ! check_port "$PORT"; then
      error " $(text 36) "
    fi
  else
    while true; do
      reading "\n (2/4) $(text 13) " PORT
      if [ -z "$PORT" ]; then
        PORT=$(get_random_port)
        info " $(text 37) $PORT"
        break
      elif ! check_port "$PORT"; then
        warning " $(text 36) "
      else
        break
      fi
    done
  fi

  # API 前缀
  [ -n "$ARGS_PREFIX" ] && PREFIX="$ARGS_PREFIX" || reading "\n (3/4) $(text 14) " PREFIX

  # TLS 模式
  if [ -n "$ARGS_TLS_MODE" ]; then
    TLS_MODE="$ARGS_TLS_MODE"
    if [[ ! "$TLS_MODE" =~ ^[0-2]$ ]]; then
      TLS_MODE=0
    fi

    # 如果是自定义证书模式，检查证书文件
    if [ "$TLS_MODE" = "2" ]; then
      if [ -n "$ARGS_CERT_FILE" ]; then
        if [ ! -f "$ARGS_CERT_FILE" ]; then
          error " $(text 25) $ARGS_CERT_FILE"
        fi
        CERT_FILE="$ARGS_CERT_FILE"
      else
        reading " $(text 23) " CERT_FILE
        [ ! -f "$CERT_FILE" ] && error " $(text 25) $CERT_FILE"
      fi

      if [ -n "$ARGS_KEY_FILE" ]; then
        if [ ! -f "$ARGS_KEY_FILE" ]; then
          error " $(text 26) $ARGS_KEY_FILE"
        fi
        KEY_FILE="$ARGS_KEY_FILE"
      else
        reading " $(text 24) " KEY_FILE
        [ ! -f "$KEY_FILE" ] && error " $(text 26) $KEY_FILE"
      fi
      CRT_PATH="&crt=${CERT_FILE}&key=${KEY_FILE}"
      info " $(text 27) "
    fi
  else
    info "\n (4/4) $(text 15) "
    hint " $(text 16) "
    reading " $(text 38) " TLS_MODE
    if [ -z "$TLS_MODE" ]; then
      TLS_MODE=0
    elif [[ ! "$TLS_MODE" =~ ^[0-2]$ ]]; then
      warning " $(text 17) "
      exit 1
    fi
  fi

  grep -qw '0' <<< "$TLS_MODE" && HTTP_S="http" || HTTP_S="https"

  # 获取最新版本
  get_latest_version

  info " $(text 19) "

  # 下载并解压
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    wget "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
  else
    curl -sL "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
  fi

  [ ! -f "$TEMP_DIR/nodepass" ] && error " $(text 9) "

  # 移动到工作目录
  # 保存语言选择和服务器IP信息到单个文件
  mkdir -p $WORK_DIR
  echo -e "LANGUAGE=$L\nSERVER_IP=$SERVER_IP" > $WORK_DIR/data

  # 移动NodePass可执行文件并设置权限
  mv "$TEMP_DIR/nodepass" "$WORK_DIR/"
  chmod +x "$WORK_DIR/nodepass"

  # 构建命令行
  CMD="master://${LOCALHOST}:${PORT}/${PREFIX}?log=info&tls=${TLS_MODE}${CRT_PATH:-}"

  # 创建服务文件
  create_service

  # 检查服务是否成功启动
  sleep 2  # 等待服务启动

  check_install
  local INSTALL_STATUS=$?

  if [ $INSTALL_STATUS -eq 0 ]; then
    # 创建快捷方式
    create_shortcut
    get_token
    info "\n $(text 10) "

    # 输出安装信息
    echo "------------------------"
    info " $(text 60) $(text 34) "
    info " $(text 35) "
    info " $(text 39) ${HTTP_S}://${URL_SERVER_IP}:${PORT}/${PREFIX:+${PREFIX%/}/}v1"
    info " $(text 40) ${TOKEN}"

    echo "------------------------"
  else
    warning " $(text 53) "
  fi

  help
}

# 创建系统服务
create_service() {
  # 如果在容器环境中，不创建服务文件，直接启动进程
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    info " $(test 21) "
    nohup "$WORK_DIR/nodepass" "$CMD" >/dev/null 2>&1 &
    return
  fi

  if [ "$SERVICE_MANAGE" = "systemctl" ]; then
    cat > /etc/systemd/system/nodepass.service << EOF
[Unit]
Description=NodePass Service
Documentation=https://github.com/NodePassProject/nodepass-core
After=network.target

[Service]
Type=simple
ExecStart=$WORK_DIR/nodepass "$CMD"
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable nodepass
    systemctl start nodepass

  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    cat > /etc/init.d/nodepass << EOF
#!/sbin/openrc-run

name="nodepass"
description="NodePass Service"
command="$WORK_DIR/nodepass"
command_args="$CMD"
command_background=true
pidfile="/run/\${RC_SVCNAME}.pid"
output_log="/var/log/\${RC_SVCNAME}.log"
error_log="/var/log/\${RC_SVCNAME}.log"

depend() {
    need net
    after net
}
EOF

    chmod +x /etc/init.d/nodepass
    rc-update add nodepass default
    rc-service nodepass start
  fi
}

# 创建快捷方式
create_shortcut() {
  # 根据下载工具构建下载命令
  local DOWNLOAD_COMMAND
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    DOWNLOAD_COMMAND="wget --no-check-certificate -qO-"
  else
    DOWNLOAD_COMMAND="curl -ksSL"
  fi

  # 创建快捷方式脚本
  cat > ${WORK_DIR}/np.sh << EOF
#!/usr/bin/env bash

bash <($DOWNLOAD_COMMAND https://raw.githubusercontent.com/yosebyte/nodepass/main/np.sh) \$1
EOF
  chmod +x ${WORK_DIR}/np.sh
  ln -sf ${WORK_DIR}/np.sh /usr/bin/np
  [ -s /usr/bin/np ] && info "\n $(text 57) "
}

# 卸载 NodePass
uninstall() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      pkill -f "nodepass"
    else
      ps -ef | grep -v grep | grep "nodepass" | awk '{print $2}' | xargs -r kill
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl stop nodepass
    systemctl disable nodepass
    rm -f /etc/systemd/system/nodepass.service
    systemctl daemon-reload
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass stop
    rc-update del nodepass
    rm -f /etc/init.d/nodepass
  fi

  rm -rf "$WORK_DIR" /usr/bin/np
  info " $(text 11) "
}

# 菜单设置函数 - 根据当前状态设置菜单选项和对应的动作
menu_setting() {
  # 检查安装状态
  INSTALL_STATUS=$1

  # 清空数组
  unset OPTION ACTION

  # 根据安装状态设置菜单选项和动作
  if [ "$INSTALL_STATUS" = 2 ]; then
    # 未安装状态
    NODEPASS_STATUS=$(text 32)
    OPTION[1]="1. $(text 28)"
    OPTION[0]="0. $(text 31)"

    ACTION[1]() { install; exit 0; }
    ACTION[0]() { exit 0; }
  else
    get_token
    get_api_url
    # 已安装状态
    if [ $INSTALL_STATUS -eq 0 ]; then
      NODEPASS_STATUS=$(text 34)
      # 服务已开启
      OPTION[1]="1. $(text 56) (np -o)"
    else
      # 服务已安装但未开启
      NODEPASS_STATUS=$(text 33)
      OPTION[1]="1. $(text 58) (np -o)"
    fi

      OPTION[2]="2. $(text 30) (np -v)"
      OPTION[3]="3. $(text 29) (np -u)"
      OPTION[0]="0. $(text 31)"

      # 服务未开启时的动作
      ACTION[1]() { on_off $INSTALL_STATUS; exit 0; }
      ACTION[2]() { upgrade_nodepass; exit 0; }
      ACTION[3]() { uninstall; exit 0; }
      ACTION[0]() { exit 0; }
  fi
}

# 菜单显示函数 - 显示菜单选项并处理用户输入
menu() {
  # 使用 echo 和转义序列清屏
  echo -e "\033[H\033[2J\033[3J"
  echo "
╭─────────────────────────────────────────────╮
│     ░░█▀█░█▀█░░▀█░█▀▀░█▀█░█▀█░█▀▀░█▀▀░░     │
│     ░░█░█░█░█░█▀█░█▀▀░█▀▀░█▀█░▀▀█░▀▀█░░     │
│     ░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀░░     │
├─────────────────────────────────────────────┤
│    >Universal TCP/UDP Tunneling Solution    │
│    >https://github.com/yosebyte/nodepass    │
╰─────────────────────────────────────────────╯  "
  grep -qEw '0|1' <<< "$INSTALL_STATUS" && info " $(text 60)  $NODEPASS_STATUS "
  grep -q '.' <<< "$API_URL" && info " $(text 39) $API_URL "
  grep -q '.' <<< "$TOKEN" && info " $(text 40) $TOKEN "
  echo "------------------------"

  # 显示菜单选项，但将索引为0的选项放在最后
  for ((b=1;b<=${#OPTION[*]};b++)); do [ "$b" = "${#OPTION[*]}" ] && hint " ${OPTION[0]} " || hint " ${OPTION[b]} "; done

  echo "------------------------"

  # 读取用户选择
  reading " $(text 38) " MENU_CHOICE

  # 处理用户选择，输入必须是数字且在菜单选项范围内
  if grep -qE "^[0-9]+$" <<< "$MENU_CHOICE" && [ "$MENU_CHOICE" -ge 0 ] && [ "$MENU_CHOICE" -lt ${#OPTION[@]} ]; then
    ACTION[$MENU_CHOICE]
  else
    warning " $(text 17) [0-$((${#OPTION[@]}-1))] " && sleep 1 && menu
  fi
}

# 主程序入口
main() {
  # 解析命令行参数
  parse_args "$@"

  # 获取脚本参数
  OPTION="${1,,}"

  # 检查是否为帮助（帮助不需要检查安装状态）
  [ "${1,,}" = "-h" ] && help && exit 0

  # 检查 root 权限
  check_root

  # 检查系统架构
  check_arch

  # 检查系统
  check_system

  # 检查依赖
  check_dependencies

  # 检查是否需要启用 Github CDN
  check_cdn
  
  # 检查安装状态
  check_install
  local INSTALL_STATUS=$?

  # 选择语言
  if [ "$INSTALL_STATUS" != 2 ]; then
    select_language
  fi

  # 根据参数执行相应操作
  case "$1" in
    -i)
      # 安装操作
      if [ "$INSTALL_STATUS" != 2 ]; then
        warning " ${E[18]}\n ${C[18]} "
      else
        grep -q '^$' <<< "$L" && select_language
        install
      fi
      ;;
    -u)
      # 卸载操作
      if [ "$INSTALL_STATUS" = 2 ]; then
        warning " ${E[59]}\n ${C[59]} "
      else
        uninstall
      fi
      ;;
    -v)
      # 升级操作
      if [ "$INSTALL_STATUS" = 2 ]; then
        warning " ${E[59]}\n ${C[59]} "
      else
        upgrade_nodepass
      fi
      ;;
    -o)
      # 切换服务状态
      if [ "$INSTALL_STATUS" = 2 ]; then
        warning " ${E[59]}\n ${C[59]} "
      else
        on_off $INSTALL_STATUS
      fi
      ;;
    -s)
      # 显示API信息
      if [ "$INSTALL_STATUS" = 2 ]; then
        warning " ${E[59]}\n ${C[59]} "
      else
        if [ "$INSTALL_STATUS" = 0 ]; then
          info " $(text 60) $(text 34) "
        else
          info " $(text 60) $(text 33) "
        fi

        get_api_url output
        get_token output
      fi
      ;;
    *)
      # 默认菜单
      grep -q '^$' <<< "$L" && select_language
      menu_setting $INSTALL_STATUS
      menu
      ;;
  esac
}

# 执行主程序
main "$@"