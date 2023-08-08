#!/bin/sh

# Read the array of usernames from the file
readarray -t user_dirs < /root/multi_thread_rsync/first_twenty_usernames.txt

# Loop through the user directories and create symbolic links
for i in "${!user_dirs[@]}"; do
  if [ -d "/export/cserv1_a/soc_staff/${user_dirs[$i]}" ]; then
  echo -e ln -s /export/cserv1_a/soc_staff/${user_dirs[$i]}" "/mnt/eufs003/staff_lnxhome01/${user_dirs[$i]} >> /root/symlink.log
    #ln -s "/export/cserv1_a/soc_staff/${user_dirs[$i]}" "/mnt/eufs003/staff_lnxhome01/${user_dirs[$i]}"
  #else
    #echo "Directory /export/cserv1_a/soc_staff/${user_dirs[$i]} does not exist."
  fi
done