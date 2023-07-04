#!/bin/bash

readarray -t staff_dirs < /root/multi_thread_rsync/staff_directories.txt

csunix_dir=/mnt/cserv1_a/
eufs_dir=/uolstore/home/staff_lnxhome01/
log_file=/tmp/rsync.log

for i in "${staff_dirs[@]}"; do
  parallel -j 10 --progress --joblog "$log_file" rsync -avz "$csunix_dir/${i}" "$eufs_dir/*" --delete &
done

wait
