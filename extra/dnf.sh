#!/bin/bash
# Clean dnf cache

echo -e "\n\n _____ DNF cache _____"

echo "Dnf packages cleaning"
# Remove old versions of kernel
sudo dnf remove -y $(dnf repoquery --installonly --latest-limit=-2 -q)
# When upgrading to a new version of Fedora, a cache is created. In theory, the cache is cleaned after the upgrade. If not, cleaning can be forced using the following command:
sudo dnf system-upgrade clean
sudo dnf clean packages