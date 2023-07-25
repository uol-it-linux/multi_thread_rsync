#!/bin/bash
## To be run from csunix ##
# Set the number of parallel processes
PARALLEL=15

# Set the source and destination paths
source_dir="/export/cserv1_a/soc_ug/"
dest_dir="/mnt/eufs003/student_lnxhome01/"

# Function to perform rsync for a subset of directories
rsync_subset() {
  local subset=("$@")
  rsync -avh -z --progress --partial --delete "${subset[@]}" "$dest_dir"  # Perform rsync for the subset
}

# Read the list of sub-directories in source_dir into an array
mapfile -t sub_dirs < <(find "$source_dir" -mindepth 1 -maxdepth 1 -type d)

# Calculate the number of sub-directories per process
((dirs_per_process = (${#sub_dirs[@]} + PARALLEL - 1) / PARALLEL))

# Loop through the sub-directories and distribute them among the parallel rsync processes
for ((i = 0; i < ${#sub_dirs[@]}; i += dirs_per_process)); do
  rsync_subset "${sub_dirs[@]:i:dirs_per_process}" &
done

# Wait for all rsync processes to finish
wait