#!/bin/bash

dir_to_remove="/uolstore/home/student_lnxhome01/"
num_jobs=40

find "$dir_to_remove" -type d -print0 |
  parallel -0 -j"$num_jobs" --progress --joblog /root/rm_student.log /bin/rm -rf {} > /dev/null 2>&1
