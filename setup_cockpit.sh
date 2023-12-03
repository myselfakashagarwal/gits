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

print_messege "${YELLOW}" " Installing and setting up cockpit"
if [[ $distribution == "debian" ]]
then 
  apt update
  apt install ufw -y
  ufw enable
  apt install cockpit -y
  systemctl enable --now cockpit.socket
  ufw allow 9090/tcp
  systemctl restart ufw
  systemctl enable --now cockpit.socket
  systemctl start cockpit.socket
  systemctl restart cockpit.socket
elif [[ $distribution == "rhel" ]]
then
    yum update
    yum install firewalld -y
    systemctl start firewalld
    systemctl enable firewalld
    yum install cockpit -y
    systemctl enable --now cockpit.socket
    firewall-cmd --permanent --add-service=cockpit
    firewall-cmd --permanent --add-port=9090/tcp
    firewall-cmd --reload
    systemctl enable --now cockpit.socket
    systemctl start cockpit.socket
    systemctl restart cockpit.socket    
else
    print_messege "${RED}" " Setup Not available for the current distribution "
    exit 0
fi

# Access cockpit
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && print_messege "${YELLOW}" "Link to access server internally = http://$internal_url:9090") # available in all cases, internal access link
print_messege "${GREEN}" " Installed and setup cockpit make sure to restart the system "

