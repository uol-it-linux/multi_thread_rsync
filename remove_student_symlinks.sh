#!/bin/sh

readarray -t user_dirs < /root/multi_thread_rsync/staff_usernames.txt

for i in "${!user_dirs[@]}"; do
rm /home/csunix/${user_dirs[$i]} 
done

/bin/bash /root/multi_thread_rsync/create_staff_symlinks.sh