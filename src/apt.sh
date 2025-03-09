#!/bin/bash
# Clean apt cache

echo -e "\n\n _____ APT cache _____"

echo "Apt packages cleaning"
echo -e "\n\nSize of cache: $(sudo du -sh /var/cache/apt)\n"

sudo apt autoremove -y
sudo apt autoclean
sudo apt clean

echo -e "\nSize of data after clean: $(sudo du -sh /var/cache/apt)"