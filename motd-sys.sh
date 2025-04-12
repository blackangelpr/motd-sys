#!/bin/bash
# motd-sys.sh - A modern MOTD dashboard for Ubuntu Server
# Author: Cristobal Ortiz Ortiz
#
# License: GNU General Public License v3.0 (GPL-3.0)
# https://www.gnu.org/licenses/gpl-3.0.html
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

INSTALL_PATH="/opt/motd-sys.sh"
ALIAS_NAME="sys"
PROFILE_HOOK="/etc/profile.d/sys.sh"
VERSION="v1.0.0"

# === Installation phase ===
if [[ "$0" != "$INSTALL_PATH" ]]; then
  echo "🔧 Installing MOTD script system-wide..."

  sudo cp "$0" "$INSTALL_PATH"
  sudo chmod +x "$INSTALL_PATH"
  echo "✅ Script copied to $INSTALL_PATH"

  if ! grep -q "alias $ALIAS_NAME=" "$HOME/.bashrc"; then
    echo "alias $ALIAS_NAME='bash $INSTALL_PATH'" >> "$HOME/.bashrc"
    echo "✅ Alias added: $ALIAS_NAME"
  else
    echo "⚠️  Alias '$ALIAS_NAME' already exists in .bashrc"
  fi

  echo "#!/bin/bash" | sudo tee "$PROFILE_HOOK" > /dev/null
  echo "bash $INSTALL_PATH" | sudo tee -a "$PROFILE_HOOK" > /dev/null
  sudo chmod +x "$PROFILE_HOOK"
  echo "✅ Login hook set: $PROFILE_HOOK"

  if [ -d /etc/update-motd.d ]; then
    echo "🧹 Disabling default Ubuntu MOTD scripts..."
    sudo chmod -x /etc/update-motd.d/* &>/dev/null
  fi

  echo ""
  echo "🎉 MOTD installed globally! You can now type: sys"
  echo "💡 To activate the alias now, run: source ~/.bashrc"
  echo ""
  exit 0
fi

# === Display phase ===

BOLD="\e[1m"
WHITE="\e[97m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

ICON_WELCOME="🖥️"
ICON_DATE="📅"
ICON_USER="🧑"
ICON_HOST="🖥️"
ICON_IP="🌐"
ICON_LOGIN="📥"
ICON_SESSIONS="👥"
ICON_CPU="🧠"
ICON_UPTIME="⏱"
ICON_RAM="📊"
ICON_LOAD="🧮"
ICON_DOCKER="🐳"
ICON_DISK="📦"

KERNEL=$(uname -r)
HOST=$(hostname)
USER=$(whoami)
DATE=$(date "+%A, %B %d, %Y – %T")
UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^ //')
PUBLIC_IP=$(curl -s ifconfig.me || echo "Unavailable")
LAST_LOGIN=$(last -w -n 1 "$USER" | head -n 1 | awk '{for(i=4;i<=NF;++i)printf $i" "; print ""}')
SSH_SESSIONS=$(who | wc -l)
MEM=$(free -h | awk '/Mem:/ {printf "%s / %s", $3, $2}')
CPU_LOAD=$(awk -v l="$(awk '{print $1}' /proc/loadavg)" -v c="$(nproc)" 'BEGIN { printf "%.0f%%", (l/c)*100 }')
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "^" | awk '{print $1 - 1}')
UPGRADE_LIST=$(apt list --upgradable 2>/dev/null | tail -n +2 | cut -d/ -f1 | paste -sd "," -)
ICON_UPDATES="🧩"
ICON_UPGRADE="🔁"

mounts=$(findmnt -rn -o TARGET,FSTYPE | grep -Ev '^(tmpfs|proc|sysfs|devtmpfs|cgroup|debugfs|hugetlbfs|mqueue|configfs|fuse|bpf)' | awk '{print $1}' | grep -E '^(/$|/home|/mnt|/media|/boot)' | sort -u)
max_mount_len=0
for mnt in $mounts; do
    len=$(printf "%s" "$mnt" | wc -c)
    (( len > max_mount_len )) && max_mount_len=$len
done

function disk_line() {
    MOUNT=$1
    if df -h "$MOUNT" &>/dev/null; then
        USAGE=$(df -h "$MOUNT" | awk 'NR==2 {print $3}')
        TOTAL=$(df -h "$MOUNT" | awk 'NR==2 {print $2}')
        FREE=$(df -h "$MOUNT" | awk 'NR==2 {print $4}')
        printf "  %-$(($max_mount_len))s${WHITE} :${RESET} %s used / %s total (%s free)\n" "$MOUNT" "$USAGE" "$TOTAL" "$FREE"
    fi
}

DOCKER_COUNT=$(docker ps -q | wc -l)
containers=$(docker ps --format "{{.Names}}::::{{.Status}}" 2>/dev/null)
if [ -z "$containers" ]; then
    containers="  (No running containers)"
else
    formatted_containers=""
    while IFS='::::' read -r name status; do
        formatted_containers+="  - $(printf "%-20s" "$name") : $status\n"
    done <<< "$containers"
    containers="$formatted_containers"
fi

DIVIDER="${YELLOW}────────────────────────────────────────────────────────────${RESET}"
echo -e "$DIVIDER"
echo -e "${BOLD}Welcome $ICON_WELCOME  $HOST | Ubuntu Server ($KERNEL)${RESET}"
echo -e "$DIVIDER"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_DATE" "Date" "$DATE"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_USER" "User" "$USER"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_HOST" "Hostname" "$HOST"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_IP" "Public IP" "$PUBLIC_IP"
printf "${WHITE}%-2s %-20s :${RESET} %s active\n" "$ICON_SESSIONS" "SSH Sessions" "$SSH_SESSIONS"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_LOGIN" "Last Login" "$LAST_LOGIN"
echo ""
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_CPU" "CPU Model" "$CPU_MODEL"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_UPTIME" "Uptime" "$UPTIME"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_RAM" "RAM Used" "$MEM"
printf "${WHITE}%-2s %-20s :${RESET} %s\n" "$ICON_LOAD" "CPU Load" "$CPU_LOAD"
echo ""
printf "${WHITE}${ICON_DISK} Disk Storage:${RESET}\n"
for mnt in $mounts; do disk_line "$mnt"; done
echo ""
echo -e "${CYAN}${ICON_DOCKER} Docker Apps ($DOCKER_COUNT):${RESET}"
echo -e "$containers"
echo -e "$DIVIDER"
