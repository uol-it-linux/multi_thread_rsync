#!/bin/bash

readarray -t staff_dirs < student_directories.txt

csunix_dir=/home/source/
eufs_dir=/home/dest/
log_file=/tmp/rsync.log

for i in "${staff_dirs[@]}"; do
  parallel -j 10 --progress --joblog "$log_file" rsync -avz "$csunix_dir/${i}" "$eufs_dir/*" --delete &
done

wait
