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

# installing dependencies
print_messege "${YELLOW}" " Installing dependencies "
if [[ $distribution == "debian" ]]; then
  apt update
  apt install ca-certificates curl openssh-server postfix tzdata perl wget libc6 ufw git -y
  curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
else
  yum update
  yum install ca-certificates curl openssh-server postfix tzdata perl policycoreutils-python-utils glibc firewalld git -y
  rpm --import https://packages.gitlab.com/gpg.key
  curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh
fi
print_messege "${GREEN}" " Installed dependencies "

# modifying firewall
print_messege "${YELLOW}" " Modifying firewall "
if [[ $distribution == "debian" ]]; then
  sudo ufw enable
  sudo ufw allow http
  sudo ufw allow https
  sudo ufw allow OpenSSH
  sudo ufw reload
else
  sudo systemctl start firewalld
  sudo firewall-cmd --permanent --add-service=http
  sudo firewall-cmd --permanent --add-service=https
  sudo firewall-cmd --permanent --add-service=ssh
  sudo firewall-cmd --permanent --add-port=8080/tcp
  sudo firewall-cmd --reload
fi
print_messege "${GREEN}" " Modified firewall "

# gitlab setup
print_messege "${YELLOW}" " Running dependencies and setting up gitlab "
if [[ $distribution == "debian" ]]; then
  bash script.deb.sh
  rm -r script.deb.sh
  apt install gitlab-ce -y || {
    print_messege "${RED}" " Trying low-level package manager to install gitlab-ce";
    wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/bullseye/gitlab-ce_16.5.2-ce.0_amd64.deb/download.deb;
    print_messege "${YELLOW}" " Progressing to install gitlab-ce with a low-level package manager";
    dpkg -i gitlab-ce_16.5.2-ce.0_amd64.deb;
    print_messege "${GREEN}" " Installation of gitlab-ce with a low-level package manager is successful ";
    } 

else
  bash script.rpm.sh
  rm -r script.rpm.sh
  yum install gitlab-ce -y || {
    print_messege "${RED}" " Trying low-level package manager to install gitlab-ce";
    wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/8/gitlab-ce-16.5.2-ce.0.el8.x86_64.rpm/download.rpm;
    print_messege "${YELLOW}" " Progressing to install gitlab-ce with a low-level package manager";
    rpm -i gitlab-ce-16.5.2-ce.0.el8.x86_64.rpm;
    print_messege "${GREEN}" " Installation of gitlab-ce with a low-level package manager is successful ";
    }
fi

print_messege "${GREEN}" " Dependicies status = OK , Gitlab setup status = OK "

# Configure 
print_messege "${YELLOW}" " Configuring gitlab "
sudo gitlab-ctl reconfigure
print_messege "${GREEN}" " Configured gitlab "

print_messege "${GREEN}" " Access link and password ~ "
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && print_messege "${YELLOW}" "Link to access server internally = http://$internal_url/users_sign_in") # available in all cases , internal access link

# (external_url=$(sudo cat /etc/gitlab/gitlab.rb | grep -w "^external_url" | awk '{print $2}') && echo -e "${YELLOW}" "Link to access server externally = $external_url") # available in case of cloud , external access link
print_messege "${YELLOW}" "http://$(curl -s ifconfig.me)/users/sign_in"

print_messege "${YELLOW}" "$(sudo cat /etc/gitlab/initial_root_password | grep "Password:")" # available in all cases , password for root user but deleted after 24 hrs needs to be resetted
print_messege "${GREEN}" " Setup completed Successfully "

