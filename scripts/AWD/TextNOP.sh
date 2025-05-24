#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <binary> <virtual_address> <nop_length>"
    echo "Example: $0 ./shell 0x8048468 5"
    exit 1
fi

BINARY="$1"
VA="$2"
NOP_LENGTH="$3"
if [ ! -f "$BINARY" ]; then
    echo "Error: File '$BINARY' not found!"
    exit 1
fi

cp "$BINARY" "$BINARY.bak"

# Find the .text section of the binary
TEXT_INFO=$(readelf -S "$BINARY" | grep -A1 '\.text')
if [ -z "$TEXT_INFO" ]; then
    echo "Error: Could not find .text section!"
    exit 1
fi

# Extract the virtual address and offset of the.text section
TEXT_VA=$(echo "$TEXT_INFO" | awk '{print $4}' | head -1)
TEXT_OFFSET=$(echo "$TEXT_INFO" | awk '{print $5}' | head -1)
# Remove leading zeros from the virtual address and offset
TEXT_VA_CLEAN=${TEXT_VA##0}
TEXT_OFFSET_CLEAN=${TEXT_OFFSET##0}

# Convert the virtual address and offset to decimal
TEXT_VA_DEC=$((16#$TEXT_VA_CLEAN))
TEXT_OFFSET_DEC=$((16#$TEXT_OFFSET_CLEAN))
VA_DEC=$((VA))

# Calculate the file offset of the virtual address

FILE_OFFSET_DEC=$((VA_DEC - TEXT_VA_DEC + TEXT_OFFSET_DEC))

for ((i=0; i<NOP_LENGTH; i++)); do
    NOP_STRING+="\x90"
done

# Apply the NOP patch
printf "$NOP_STRING" | dd of="$BINARY" bs=1 seek=$FILE_OFFSET_DEC conv=notrunc

# debug output
echo -n "$NOP_STRING" | xxd -p
echo "$BINARY"
echo "Virtual address: $VA"
echo "NOP length: $NOP_LENGTH"
echo "VA: $VA"
echo "Text VA: 0x$TEXT_VA"
echo "Offset: 0x$TEXT_OFFSET"
echo "VA_DEC: $VA_DEC"
echo "Text VA_DEC: $TEXT_VA_DEC"
echo "Offset_DEC: $TEXT_OFFSET_DEC"
echo "File offset: $FILE_OFFSET_DEC"
echo "Command >  printf '$NOP_STRING' | dd of='$BINARY' bs=1 seek=$FILE_OFFSET_DEC conv=notrunc"
