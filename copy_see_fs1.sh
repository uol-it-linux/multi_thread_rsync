 #!/bin/bash                                                                    
                                                                                
 # Set the number of parallel processes                                         
 PARALLEL=4                                                                     
                                                                                
 # Set the source and destination paths                                         
 SRC=/mnt/fs-01-teaching/                                                     
 DST=/uolstore/home/student_lnxhome02/                                     
                                                                                
 # Get a list of the home directories                                           
 HOMEDIRS=$(ls $SRC)                                                            
                                                                                
 # Loop through the home directories and run rsync in parallel                  
 for dir in $HOMEDIRS; do                                                       
   ((i=i%PARALLEL)); ((i++==0)) && wait                                         
   rsync -avz --exclude-from=/root/rsync-homedir-excludes $SRC/$dir $DST &                                             
 done                                                                           
                                                                                
 # Wait for all rsync processes to finish                                       
 wait
