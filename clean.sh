#!/bin/bash

## ----------------------------------
# Variables
# ----------------------------------
EDITOR=vi
RED='\033[0;41;30m'
GREEN='\e[32m'
RD='\033[1;31m'
YELLOW='\033[0;33m'
STD='\033[0;0;39m'
DISTRO=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
# WSL_DISTRO_NAME=$(env | grep -i WSL_DISTRO_NAME | awk -F= '$1=="WSL_DISTRO_NAME" { print $2 ;}')
VERSION_ID=$(awk -F= '$1=="VERSION_ID" { print $2 ;}' /etc/os-release)
DEBUG=0

# ----------------------------------
# Defined function
# ----------------------------------

continue_distro(){
  local key
  read key
  case $key in
    '') ;; # Enter
    exit) exit 0;;
    *) echo -e "${RED}Error key '$choice'.${STD} Expected [Enter/exit]" && sleep 1
  esac
}

clean_packages(){
  if [ $DISTRO == 'ubuntu' ]; then

    sudo bash -c src/apt.sh
    sudo bash -c src/apt_old_kernels.sh

  elif [ $DISTRO == 'fedora' ]; then

    sudo bash -c src/dnf.sh

  else

    echo -e "${RED} Distro $DISTRO is not supported by this script ${STD}"

  fi
}

# Check heaviest folders in /
#sudo du --exclude="/home" -x -h -a / | sort -r -h | head -30

# Clean packages
clean_packages


# Journal storage (logs)
echo "Size of journals:"
journalctl --disk-usage
sudo journalctl --vacuum-time=3d

echo "Size of journals after clean:"
journalctl --disk-usage

# Thumbail
echo "Size of thumbnails:"
du -sh ~/.cache/thumbnails
rm -rf ~/.cache/thumbnails/*

# Docker
echo -e "\n\n/!\ Careful!!!!!\n"
docker system prune -a

# Jetbrains
echo -e "\n\n _____ Jetbrains cache _____"
echo -e "\nIf you are using Jetbrain products cleaning old installations and caches can"
echo -e " save a few Gbs, so it's worth to check https://www.jetbrains.com/help/pycharm/cleaning-system-cache.html \n\n"

sudo bash -c ./src/snap.sh


# Flatpak
# flatpak uninstall --unused


#echo "Do you want to clean conda?"
#local choice
# read -p "Enter choice [ 1 - 8] -> " choice
#if [ choice -e "y"] then
#fi
