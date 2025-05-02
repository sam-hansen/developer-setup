#!/usr/bin/env bash

#   System Info with Emoji
#   Bash script to display key system information with emojis
#   The output and order are fully customizable: edit DISPLAY_ORDER
#   to control which info blocks are shown and in what order.
#   Supported blocks: user, hostname, ip, city, domain, isp, os, 
#   cpu, disk_used, top_process, device, kernel, pacman.
#   Network info (ip, city, domain, isp) is fetched from ipinfo.io 
#   only if needed.
#   Each info block uses standard Linux utilities and is only executed 
#   if its keyword is present in DISPLAY_ORDER.
#   Output is a single, emoji-enhanced line for quick server status review.
#
#   If run with --install, sets up the script as a shell greeting and silences default login messages.
#
#   Dependencies:
#     - Standard Linux tools (whoami, hostname, ps, df, awk, grep, uname, etc.)
#     - wget (for ipinfo.io)
#     - hostname: sudo pacman -S inetutils;
#         sudo apt-get install hostname
#
#   Author: vtempest (2022-25) https://github.com/vtempest/Server-Shell-Setup/tree/master
#   License: MIT
# */

# Set what to display and in what order (edit this line!)
DISPLAY_ORDER="user hostname disk_used top_process uptime \
  ip city domain isp os cpu device kernel pacman"

# Fetch IP info only if needed
NEED_IPINFO=0
for key in $DISPLAY_ORDER; do
    [[ "$key" =~ ^(ip|isp|domain|city)$ ]] && NEED_IPINFO=1
done
if [ $NEED_IPINFO -eq 1 ]; then
    INFO=$(wget -qO- -T1 ipinfo.io 2>/dev/null) || { echo -e "\033[31m ❌ No internet connection"; exit 1; }
fi

for key in $DISPLAY_ORDER; do
    case $key in
        user)
            echo -ne "\e[31m👤 $(whoami) "
            ;;
        hostname)
            echo -ne "\e[91m🏠 $(hostname)"
            ;;
        top_process)
            export TOP_PROC=$(ps -eo pcpu,comm --sort=-%cpu --no-headers \
                | head -1 | sed 's/\.[0-9]/%/' | awk '{$1=$1};1' )
            echo -ne "\e[95m 🔝 $TOP_PROC"
            ;;
        disk_used)
            export DISK_USED=$(df | grep '/$' | awk '{print $5}')
            echo -ne "\e[35m 📁 $DISK_USED"
            export RAM_USED=$(awk '/MemFree|MemTotal/ {a[$1]=$2/1024/1024} END {printf "%.0f/%.0fGB\n", a["MemFree:"], a["MemTotal:"]}' /proc/meminfo)
            echo -ne "\e[35m 💾 $RAM_USED"
            ;;
        uptime)
            UPTIME=$(awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if(d>0) printf "%dd ",d; if(h>0 || d>0) printf "%dh ",h; printf "%dm\n",m}' /proc/uptime  2>/dev/null)
            [ -n "$UPTIME" ] && echo -ne "\033[36m ⏱️ ${UPTIME}"
            ;;
        ip)
            IP=$(echo "$INFO" | grep -oP 'ip"\s*:\s*"\K[^"]+' 2>/dev/null)
            [ -n "$IP" ] && echo -ne "\033[32m 🌎 ${IP:-No IP}"|| echo  -ne "\033[37m 🌎 No Network"
            ;;
        city)
            CITY=$(echo "$INFO" | grep -oP 'city"\s*:\s*"\K[^"]+' 2>/dev/null)
            [ -n "$CITY" ] && echo -ne "\033[32m 📍 ${CITY:-No City}"
            ;;
        domain)
            DOMAIN=$(echo "$INFO" | grep -oP 'hostname"\s*:\s*"\K[^"]+' 2>/dev/null)
            [ -n "$DOMAIN" ] && echo -ne "\033[37m 🔗 http://$DOMAIN"
            ;;
        isp)
            export ISP=$(echo $INFO | grep -oP 'org\": "\K[^"]+' | cut -f 1 -d ' ' --complement)
            echo -ne "\e[33m 👮 $ISP"
            ;;
        cpu)
            export CPU=$(sed -n '/model name/p' /proc/cpuinfo | \
                cut -d':' -f2 | head -1 | awk '{$1=$1};1' )
            echo -ne "\e[91m 📈 $CPU"
            ;;
        os)
            export OS=$([ -f /etc/os-release ] && grep -oP "^NAME=\"\K[^\"]+" /etc/os-release)
            echo -ne "\e[34m ⚡ $OS"
            ;;
        device)
            if test -f /sys/devices/virtual/dmi/id/product_name; then
                DEVICE=$(cat /sys/devices/virtual/dmi/id/product_name  )
                echo -ne "\e[34m 💻 $DEVICE"
            fi
            ;;
        kernel)
            export KERNEL=$(uname -r)
            echo -ne "\e[32m 🔧 $KERNEL"
            ;;
        pacman)
            echo -ne "\e[31m 🚀"
            # \ "pkg" "flatpak"  "yum" "snap" "pacman"\
            # \ "apk"  "brew" "yarn" "pnpm" "cargo" "gem" "go" 
            for cmd in "apt" "npm" "pip" "docker" "hx" "nvim" "bun"; do
                if [ -x "$(command -v $cmd)" ]; then
                    echo -ne " $cmd";
                fi
            done
            ;;
        *)
            ;;
    esac
done

# Reset color
echo -e "\e[0m"


install_shell_greeting() {
    # Silence default login messages
    sudo rm -f /etc/motd
    sudo rm -rf /etc/update-motd.d
    touch ~/.hushlogin

    # Ensure target directory exists
    mkdir -p ~/.config/systeminfo

    # Copy this script (assumes it's named systeminfo.sh)
    cp "$(realpath "$0")" ~/.config/systeminfo/systeminfo.sh

    # Add to Nushell config if Nushell is installed
    if command -v nu > /dev/null; then
        NU_CONFIG_PATH=$(nu -c 'echo $nu.config-path' 2>/dev/null)
        if [ -n "$NU_CONFIG_PATH" ] && ! grep -q 'systeminfo.sh' "$NU_CONFIG_PATH"; then
            echo 'bash ~/.config/systeminfo/systeminfo.sh' >> "$NU_CONFIG_PATH"
            echo "Added systeminfo greeting to Nushell config."
        fi
    fi

    echo "Shell greeting installed!"
}

# Main logic: check for --install argument
if [[ "$1" == "--install" ]]; then
    install_shell_greeting
    exit 0
fi


