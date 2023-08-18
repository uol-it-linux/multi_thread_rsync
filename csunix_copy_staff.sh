#!/bin/bash

# Set the number of parallel processes
PARALLEL=40

# Get date for log file
current_date=$(date +%Y%m%d)

# Set the source and destination paths
csunix_dir="/export/cserv1_a"
eufs_dir="/mnt/eufs003/staff_lnxhome01/"
#eufs_dir="/mnt/eufs003/Testvol"
log_file="/tmp/staff_rsync_$current_date.log"

# Specify the files containing the exclude directories/patterns
first_twenty_excludes="/root/multi_thread_rsync/first_twenty_usernames.txt"
additional_excludes="/root/multi_thread_rsync/rsync-homedir-excludes"
dir_excludes="/root/multi_thread_rsync/parent_dirs_exclude.txt"
symlink_excludes="/root/multi_thread_rsync/symlink_excludes.txt"
disabled_users="/root/multi_thread_rsync/disabled_users.txt"

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/staff_directories.txt

# Loop through the user directories and run rsync in parallel (dry-run - remove 'n' from "rsync -avzn" to run for real)
for i in "${!user_dirs[@]}"; do
  ((i=i%PARALLEL)); ((i++==0)) && wait
  source_dir="$csunix_dir/${user_dirs[$i]}"
  
  # Check if the source directory exists and is a directory
  if [ -d "$source_dir" ]; then
    # Loop through the immediate subdirectories of the source directory
    for target_dir in "$source_dir"/*/; do
      target_dir=${target_dir%/}  # Remove trailing slash if present

      # Check if the target directory is in the list of excluded directories
      if grep -qFx "${target_dir##*/}" "$dir_excludes"; then
        continue  # Skip processing the parent directory
      fi

      if [ -d "$target_dir" ]; then
        /usr/bin/rsync -avz --inplace --partial --exclude-from="$first_twenty_excludes" --exclude-from "$disabled_users" --exclude-from="$additional_excludes" --exclude-from="$dir_excludes" --exclude-from "$symlink_excludes" --progress "$target_dir" "$eufs_dir" --delete >> "$log_file" 2>&1 &
      else
        echo "Directory $target_dir does not exist."
      fi
    done
  else
    echo "Directory $source_dir does not exist."
  fi
done

# Wait for all rsync processes to finish
wait

# Tidy up broken symlinks in the destination directory
/usr/bin/find "$eufs_dir" -maxdepth 1 -mindepth 1 -type l -exec rm -f {} +

# Call remove_staff_symlinks.sh
#/bin/bash /root/multi_thread_rsync/remove_staff_symlinks.sh