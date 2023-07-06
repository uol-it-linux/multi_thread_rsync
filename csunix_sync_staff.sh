#!/bin/bash

readarray -t user_dirs < /root/multi_thread_rsync/staff_directories.txt

touch ~/.parallel/willcite

csunix_dir=/mnt/cserv1_a/
eufs_dir=/uolstore/home/staff_lnxhome01/
log_file=/tmp/rsync.log

# Debug: Print the array contents
echo "Array contents:"
for i in "${user_dirs[@]}"; do
  echo "$i"
done

for i in "${user_dirs[@]}"; do
  parallel -j 10 --progress --bibtex --citation --joblog "$log_file" rsync -avz "$csunix_dir/${i}" "$eufs_dir/" --delete &
done

wait