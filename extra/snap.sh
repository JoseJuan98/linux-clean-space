#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

echo -e "\n\n _____ Clean Unused Snaps _____"
snaps_to_remove=$(LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}')

# if snaps_to_remove is empty
if [ -z "$snaps_to_remove" ]; then
  echo "No snaps to remove.\n\n"
fi

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
  echo $snapname $revision
done