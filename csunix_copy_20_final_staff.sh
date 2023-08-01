#!/bin/bash
## To be run from csunix ##
# Set the number of parallel processes
#PARALLEL=40

# Get date for log file
current_date=$(date +%Y%m%d)

# Set the source and destination paths
#csunix_dir="/export/cserv1_a/soc_staff"
eufs_dir="/mnt/eufs003/staff_lnxhome01/"
log_file="/tmp/staff_20_rsync_$current_date.log"

# Read the array of user directories from the file
readarray -t user_dirs < /root/multi_thread_rsync/first_twenty.txt

# Debug test: verify csunix path is correct
for i in "${!user_dirs[@]}"; do
  echo "${user_dirs[$i]}"
done

# Loop through the user directories and run rsync in parallel
for i in "${!user_dirs[@]}"; do
  #((i=i%PARALLEL)); ((i++==0)) && wait
    /usr/bin/rsync -avz --progress --delete "${user_dirs[$i]}" "$eufs_dir" >> "$log_file" 2>&1 &
done

# Wait for all rsync processes to finish
wait