#!/bin/bash
# Clean dnf cache

echo -e "\n\n _____ DNF Cache _____"
echo -e "\nSize of cache: $(sudo du -sh /var/cache/dnf)\n"

# Remove old versions of kernel
sudo dnf remove -y $(dnf repoquery --installonly --latest-limit=-2 -q)

# When upgrading to a new version of Fedora, a cache is created. In theory, the cache is cleaned after the upgrade. If not, cleaning can be forced using the following command:
sudo dnf autoremove -y
sudo dnf system-upgrade clean
sudo dnf clean packages

echo -e "\nSize of data after clean: $(sudo du -sh /var/cache/dnf)\n"