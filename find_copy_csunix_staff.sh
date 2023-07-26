#!/bin/bash

# Set the number of parallel processes
PARALLEL=40

# Set the source and destination paths
csunix_dir="/export/cserv1_a"
eufs_dir="/mnt/eufs003/staff_lnxhome01/"
log_file="/tmp/rsync.log"

# Specify the files containing the exclude directories/patterns
first_twenty_excludes="/root/multi_thread_rsync/first_twenty_usernames.txt"
additional_excludes="/root/multi_thread_rsync/rsync-homedir-excludes"

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/staff_directories.txt

# Loop through the user directories and run rsync in parallel (dry-run - remove 'n' from "rsync -avzn" to run for real)
for i in "${!user_dirs[@]}"; do
  ((i=i%PARALLEL)); ((i++==0)) && wait
  source_dir="$csunix_dir/${user_dirs[$i]}"
  
  # Find the absolute paths of directories one level beneath the current user directory
  find "$source_dir" -mindepth 1 -maxdepth 1 -type d -name "user*" -exec realpath {} + > /tmp/target_directories.txt

  # Read the array of target directories from the temporary file
  readarray -t target_dirs < /tmp/target_directories.txt
  
  for j in "${!target_dirs[@]}"; do
    target_dir="${target_dirs[$j]}"
    if [ -d "$target_dir" ]; then
      rsync -avzn --inplace --partial --exclude-from="$first_twenty_excludes" --exclude-from="$additional_excludes" --progress "$target_dir" "$eufs_dir" --delete-delay >> "$log_file" 2>&1 &
    else
      echo "Directory $target_dir does not exist."
    fi
  done
done

# Wait for all rsync processes to finish
wait
