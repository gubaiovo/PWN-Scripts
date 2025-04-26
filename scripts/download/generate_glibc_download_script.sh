#!/bin/bash
./update_list
> download.sh

while read -r version; do
    echo "./download $version" >> download.sh
done < list

while read -r version; do
    echo "./download_old $version" >> download.sh
done < old_list

chmod +x download.sh
