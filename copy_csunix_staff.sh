#!/bin/bash

# Set the number of parallel processes
PARALLEL=4

# Set the source and destination paths
csunix_dir=/mnt/cserv1_a/
eufs_dir=/uolstore/home/staff_lnxhome01/
log_file=/tmp/rsync.log

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/staff_directories.txt

# Debug test: verify csunix path is correct
for i in "${user_dirs[@]}"; do
 echo $csunix_dir/$i
done

# Loop through the user directories and run rsync in parallel
for i in "${user_dirs[@]}"; do
  ((i=i%PARALLEL)); ((i++==0)) && wait
  rsync -avz --exclude-from=/root/rsync-homedir-excludes "$csunix_dir/$i" "$eufs_dir/" --delete &
done

# Wait for all rsync processes to finish
wait