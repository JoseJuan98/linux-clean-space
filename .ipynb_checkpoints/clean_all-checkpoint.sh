#!/bin/bash

echo "Apt packages cleaning"
echo "Size of data:"
sudo du -sh /var/cache/apt

sudo apt autoremove
sudo apt autoclean
sudo apt clean

echo "Size of data after clean:"
sudo du -sh /var/cache/apt

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

#
echo "Do you want to clean conda?"
#local choice
# read -p "Enter choice [ 1 - 8] -> " choice
#if [ choice -e "y"] then
#fi