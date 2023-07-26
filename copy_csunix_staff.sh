#!/bin/bash

## This has dry run enabled by default. Remove the 'n' from "rsync - avzn" to run fully. 

# Set the number of parallel processes
PARALLEL=40

# Set the source and destination paths
csunix_dir="/export/cserv1_a/"
eufs_dir="/mnt/eufs003/staff_lnxhome01/"
log_file="/tmp/rsync.log"

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/staff_directories.txt

# Debug test: verify csunix path is correct
for i in "${!user_dirs[@]}"; do
  source_dir="$csunix_dir/${user_dirs[$i]}"
  echo "$source_dir"
done

# Loop through the user directories and run rsync in parallel (dry-run)
for i in "${!user_dirs[@]}"; do
  ((i=i%PARALLEL)); ((i++==0)) && wait
  source_dir="$csunix_dir/${user_dirs[$i]}"
  if [ -d "$source_dir" ]; then
    rsync -avzn --exclude-from=/root/rsync-homedir-excludes --progress "$source_dir/" "$eufs_dir" --delete >> "$log_file" 2>&1 &
  else
    echo "Directory $source_dir does not exist."
  fi
done

# Wait for all rsync processes to finish
wait