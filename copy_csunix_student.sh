#!/bin/bash

# Set the number of parallel processes
PARALLEL=40

# Set the source and destination paths
csunix_dir="/mnt/cserv1_a"
eufs_dir="/uolstore/home/student_lnxhome01/"
log_file="/tmp/rsync.log"

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/student_directories.txt

# Debug test: verify csunix path is correct
for i in "${!user_dirs[@]}"; do
  echo "$csunix_dir/${user_dirs[$i]}"
done

# Loop through the user directories and run rsync in parallel
for i in "${!user_dirs[@]}"; do
  ((i=i%PARALLEL)); ((i++==0)) && wait
  if [ -d "$csunix_dir/${user_dirs[$i]}" ]; then
    log_file="/tmp/rsync_$i.log"  # Use a separate log file for each rsync process
    rsync -avz --compress --inplace --partial --exclude-from=/root/rsync-homedir-excludes --exclude=BACKUP --exclude=scsysadm --progress "$csunix_dir/${user_dirs[$i]}/" "$eufs_dir" --log-file="$log_file" 2>&1 &
  else
    echo "Directory $csunix_dir/${user_dirs[$i]} does not exist."
  fi
done

# Wait for all rsync processes to finish
wait