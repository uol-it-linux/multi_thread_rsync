#!/bin/bash

# Set the number of parallel processes
PARALLEL=4

# Set the source and destination paths
csunix_dir="/mnt/cserv1_a"
eufs_dir="/uolstore/home/staff_lnxhome01/"
log_file="/tmp/rsync.log"

# Loop through the user directories and run rsync in parallel
while IFS="" read -r thisDir || [ -n "$thisDir" ]
do
  if [ -d "$csunix_dir/$thisDir" ]; then
    if [ $(ps -efa | grep "rsync.*exclude-from.*rsync-homedir-excludes" | wc -l) -lt $PARALLEL ]; then
      rsync -avz --exclude-from=/root/rsync-homedir-excludes -v "$csunix_dir/$thisDir/" "$eufs_dir" --delete >> "$log_file" 2>&1 &
    else
      sleep 10
    fi
  else
    echo "Directory $csunix_dir/$thisDir does not exist."
  fi
done < /root/multi_thread_rsync/staff_directories.txt
