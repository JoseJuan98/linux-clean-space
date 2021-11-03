#!/bin/bash

LAST_KERNEL=$(uname -r)
sudo dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r) | awk '{print $2}' | while read img_version; do
	if [ "$img_version" != "linux-image-"$LAST_KERNEL ] || [ "$img_version" != "linux-image-5.13.0-20-generic" ]; then 
		echo "Deleting kernel $img_version ..."
		#sudo dpkg ––remove $img_version
		sudo apt remove $img_version -y
	fi
done
  
echo "Checking the linux-images left:"
dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r)
