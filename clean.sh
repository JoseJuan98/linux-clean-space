#!/bin/bash

## ----------------------------------
# Variables
# ----------------------------------
RED='\033[0;41;30m'
STD='\033[0;0;39m'
DISTRO=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)

# ----------------------------------
# Defined function
# ----------------------------------

continue_distro(){
  local key
  read key
  case $key in
    '') ;; # Enter
    exit) exit 0;;
    *) echo -e "${RED}Error key 'key'.${STD} Expected [Enter/exit]" && sleep 1
  esac
}

# Choose if yo execute function by typing yes, y or n, no, and if it is not valid, it will ask again
choose(){
  local choice
  while true; do
    read -p "Do you want to clean $1? (yes/no) -> " choice
    case $choice in
      y|Y|yes|Yes) return 0;;
      n|N|no|No) return 1;;
      *) echo -e "${RED}Error key ${choice}${STD}. Valid values are yes, y, no or n." && sleep 1
    esac
  done
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

echo -e "\n\n _____ Other Caches _____"

# Journal storage (logs)
echo -e "\nSize of journals:"
journalctl --disk-usage
sudo journalctl --vacuum-time=3d

echo -e "\nSize of journals after clean:"
journalctl --disk-usage

# Thumbail
echo -e "\nSize of thumbnails:"
du -sh ~/.cache/thumbnails
rm -rf ~/.cache/thumbnails/*

# Flatpak
if [ -x "$(command -v flatpak)" ]; then
  echo -e "\n\n _____ Flatpak Cache _____\n"
  echo "Cleaning flatpak cache"
  flatpak uninstall --unused -y
fi

# Cleaning Snap packages
sudo bash -c ./src/snap.sh

# Clean pip
echo -e "\n\n_____ Pip Cache _____\n"
choose "pip's cache"
if [ $? -eq 0 ]; then
  echo "Cleaning pip cache"
  sudo pip cache purge
fi

# Clean poetry cache
# If poetry exist
if [ -x "$(command -v poetry)" ]; then
  echo -e "\n\n _____ Poetry Cache _____\n"
  choose "poetry's cache"
  if [ $? -eq 0 ]; then
    echo "Cleaning poetry cache"
    poetry cache clear PyPI --all
  fi
fi

# Clean conda
# If conda exist
if [ -x "$(command -v conda)" ]; then
  echo -e "\n\n _____ Conda Cache _____\n"
  choose "Conda's cache"
  if [ $? -eq 0 ]; then
    echo "Cleaning conda cache"
    conda clean --all
  fi
fi

# Docker
if [ -x "$(command -v docker)" ]; then
  echo -e "\n\n _____ Docker Cache _____"
  docker system prune
fi

# Jetbrains
echo -e "\n\n _____ Jetbrains Cache _____"
echo -e "\nIf you are using Jetbrain products cleaning old installations and caches can"
echo -e " save a few Gbs, so it's worth to check https://www.jetbrains.com/help/pycharm/cleaning-system-cache.html"