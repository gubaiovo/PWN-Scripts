#!/bin/bash

# This script is used to get the data from ELF files and store it in a file.
# It takes two arguments:
# 1. The path to the ELF file
# 2. The path to the output file

# Example usage:
# ./getData.sh /path/to/elf/file /path/to/output/file

if [ $# -ne 2 ]; then
    echo "Usage: $0 /path/to/elf/file /path/to/output/file"
    exit 1
fi

elf=$1
output=$2

if [ -f $elf ]; then
    objdump -d $elf > $output
else
    echo "Error: $elf does not exist."
    exit 1
fi
exit 0 