#!/bin/bash 

# Function to print messeges
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[1;33m'
print_messege() {
  local color=$1
  local messege=$2
  local width=$(tput cols 2>/dev/null) 2>/dev/null
  local line=$(printf '=%.0s' $(seq 1 "$width" 2>/dev/null)) 2>/dev/null
  local NC='\033[0m'  # Define No Color
  printf "${color}${line}\n${messege}\n${line}${NC}\n"
}

# Distro check
distribution=""
if [[ -e /etc/yum.repos.d ]]; then
  distribution="rhel"
elif [[ -e /etc/apt ]]; then
  distribution="debian"
else
  print_messege "${RED}" " Setup Not available for the current distribution "
  exit 0
fi
print_messege "${YELLOW}" " Detected distribution family: $distribution "

print_messege "${YELLOW}" " Installing and setting up cloudflared tunnel"

if [[ $distribution == "debian" ]]
then 
  apt update
  apt install curl -y
  curl -LJO# https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.deb
  dpkg -i cloudflared-linux-x86_64.deb
elif [[ $distribution == "rhel" ]]
then
    yum update
    yum install curl -y
    curl -LJO# https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
    rpm -i cloudflared-linux-x86_64.rpm
else
    print_messege "${RED}" " Setup Not available for the current distribution "
    exit 0
fi

print_messege "${GREEN}" " Installed and setup cloudflared tunnel for quick tunneling "
print_messege "${YELLOW}" " To start tunnel run - cloudflared tunnel --url http://localhost:PORT-NUMBER"
