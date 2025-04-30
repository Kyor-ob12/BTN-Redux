#!/bin/bash

# Step 1: Clean up incorrectly created icons folders inside subdirectories
for dir in */ ; do
    if [ -d "$dir/defaultIcons" ]; then
        echo "Removing $dir/defaultIcons"
        rm -rf "$dir/defaultIcons"
    fi
done

# Step 2: Create centralized 'icons' folder in the current directory
mkdir -p defaultIcons

# Step 3: Copy all .png files from subdirectories into the centralized icons folder
for dir in */ ; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Find all .png files in the subdirectory (not recursively), and copy to ./icons
        find "$dir" -maxdepth 1 -type f -name '*.png' -exec cp {} defaultIcons/ \;
    fi
done
