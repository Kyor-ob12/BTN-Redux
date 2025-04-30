#!/bin/bash

# Use at your own risk. "mv" was comented in order to be executed without making changes

# Define the folders
EMU_FOLDER="/media/jose/A30BTN/Emu"
ROM_FOLDER="/media/jose/A30BTN/Roms"

EXTENSIONS=("*.7z" "*.zip" "*.rar" "*.dsk" "*.chd" "*.wad" "*.dosz" "*.n64" "*.p8.png" "*.fbl" "*.tic" "*.ecwolf")

# Ensure .unused exists
mkdir -p "$EMU_FOLDER/.unused"

echo "=== Part 1: Move to .unused if NO matching ROMs exist ==="

for subfolder in "$ROM_FOLDER"/*/; do
    name=$(basename "$subfolder")
    rom_path="$ROM_FOLDER/$name"
    emu_path="$EMU_FOLDER/$name"
    match_found=false

    echo "🔍 Checking ROM folder: $rom_path"

    # Check for any matching file using a single find command
    if find "$rom_path" -maxdepth 2 -type f \( \
        -name "*.7z" -o -name "*.zip" -o -name "*.rar" -o \
        -name "*.dsk" -o -name "*.chd" -o -name "*.wad" -o \
        -name "*.dosz" -o -name "*.n64" -o -name "*.p8.png" -o \
        -name "*.fbl" -o -name "*.tic" -o -name "*.ecwolf" \) | grep -q .; then
        echo "✅ Matching files found in $rom_path — will NOT move."
        match_found=true
    else
        echo "🚫 No matching files in $rom_path."
    fi

    if ! $match_found && [ -d "$emu_path" ]; then
        echo "➡️ Moving $emu_path → $EMU_FOLDER/.unused/"
        #mv "$emu_path" "$EMU_FOLDER/.unused/"
    else
        echo "⏭️ Skipping $emu_path (not found or matching ROMs exist)"
    fi
done

echo
echo "=== Part 2: Restore from .unused if matching ROMs DO exist ==="

for subfolder in "$EMU_FOLDER/.unused"/*/; do
    name=$(basename "$subfolder")
    rom_path="$ROM_FOLDER/$name"
    unused_path="$EMU_FOLDER/.unused/$name"
    restore_path="$EMU_FOLDER/$name"
    match_found=false

    echo "🔍 Checking ROM folder: $rom_path (for restoration)"

    if find "$rom_path" -maxdepth 2 -type f \( \
        -name "*.7z" -o -name "*.zip" -o -name "*.rar" -o \
        -name "*.dsk" -o -name "*.chd" -o -name "*.wad" -o \
        -name "*.dosz" -o -name "*.n64" -o -name "*.p8.png" -o \
        -name "*.fbl" -o -name "*.tic" -o -name "*.ecwolf" \) | grep -q .; then
        echo "✅ Matching files found in $rom_path — will restore."
        match_found=true
    else
        echo "🚫 No matching files in $rom_path — will NOT restore."
    fi

    if $match_found && [ ! -d "$restore_path" ]; then
        echo "⬅️ Restoring $unused_path → $restore_path"
        #mv "$unused_path" "$restore_path"
    else
        echo "⏭️ Skipping restore (already exists or no matching ROMs)"
    fi
done
