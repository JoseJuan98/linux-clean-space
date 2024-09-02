#!/bin/bash

# Kernel without "-generic"
LAST_KERNEL=$(uname -r | awk -F'-' '{print $1"-"$2}')

echo -e "\n\n _____ Old Kernels _____"
echo -e "\nThis script will delete old kernel packages (linux-[image|modules|headers]-X.YY.Z-AA-[-generic]*) that are different to the current Kernel"
echo ""
echo "CURRENT KERNEL VERSION: "$LAST_KERNEL
echo -e $"\n"

regex="linux-(image|headers|modules)-${LAST_KERNEL}[-generic]*"
sudo dpkg -l | tail -n +6 | grep -E 'linux-[a-zA-Z]*-[0-9]+' | grep -Fv $(uname -r) | awk '{print $2}' | while read img_version; do
  if [[ ! $img_version =~ $regex ]]; then
		echo "Deleting package $img_version ..."
		sudo apt remove --purge $img_version -y
	fi
done

echo -e "\n Checking the linux-[image|modules|headers] left:\n"
dpkg -l | tail -n +6 | grep -E 'linux-[a-zA-Z]*-[0-9]+[-generic]*' | grep -Fv $(uname -r)