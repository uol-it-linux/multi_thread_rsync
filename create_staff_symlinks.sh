#!/bin/sh

# Read the array of usernames from the file
readarray -t user_dirs < /root/multi_thread_rsync/staff_usernames.txt

# Read the array of target directories from another file
readarray -t target_dirs < /root/multi_thread_rsync/staff_directories.txt

# Redirect all script output to a log file
exec >> /root/symlink.log 2>&1

# Loop through the user directories and create symbolic links
for i in "${!user_dirs[@]}"; do
  for dir in "${target_dirs[@]}"; do
    full_path="/export/cserv1_a/${dir}/${user_dirs[$i]}"
    if [ -d "$full_path" ]; then
      echo -e ln -s "$full_path" "/home/csunix/${user_dirs[$i]}" >> /root/symlink.log
      ln -s "$full_path" "/home/csunix/${user_dirs[$i]}"
      break  # No need to check other target directories for this user
    fi
  done
done