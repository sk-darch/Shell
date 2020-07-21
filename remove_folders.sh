#!/bin/bash

#deleting 7 days old folder but the same time ignoring folders are create on Monday
base_dir='/usr/share/nginx/html'
cd $base_dir || exit 0
find -type d -mtime +7 -printf '%Ta\t%p\n' | egrep "^(Sun|Tue|Wed|Thu|Fri|Sat)" | cut -f 2- >> output.txt
while IFS= read -r folder_names
do
    rm -rf $folder_names
done < "$base_dir/output.txt"
truncate -s 0 $base_dir/output.txt