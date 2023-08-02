#!/bin/bash

# Read the list of directories to be removed from the text file
mapfile -t directories_to_remove < /root/multi_thread_rsync/disabled_users.txt

# List of target directories
target_dirs=("/mnt/eufs003/staff_lnxhome01" "/mnt/eufs003/student_lnxhome01")

# Loop through the list of directories and remove matching ones from the target directories
for dir in "${directories_to_remove[@]}"; do
  for target_dir in "${target_dirs[@]}"; do
    if [ -d "$target_dir/$dir" ]; then
      echo "Removing directory: $target_dir/$dir"
      rm -r "$target_dir/$dir"
    else
      echo "Directory does not exist: $target_dir/$dir"
    fi
  done
done