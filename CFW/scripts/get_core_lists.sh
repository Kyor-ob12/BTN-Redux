#!/bin/sh

output_file="/mnt/SDCARD/CFW/scripts/launch_names.txt"
: > "$output_file"  # Empty the file if it exists

cd /mnt/SDCARD/Emu

for folder in */; do
    config="$folder/config.json"
    [ -f "$config" ] || continue

    # Extract "name" values, remove _libretro and quotes
    names=$(sed -n 's/.*"name": *"\([^"]*\)".*/\1/p' "$config" |
        sed 's/_libretro$//' |
        paste -sd' ' -)

    folder_name=$(basename "$folder")
    echo "$folder_name=\"$names\"" >> "$output_file"
done