#!/bin/sh

INFILE="$1"
OUTFILE="$2"

[ -z "$INFILE" ] || [ -z "$OUTFILE" ] && {
    echo "Usage: $0 input_file output_file"
    exit 1
}

: > "$OUTFILE"  # Clear output file

while IFS= read -r line; do
    # Skip empty lines and shebang
    [ -z "$line" ] && continue
    echo "$line" | grep -q '^#!' && continue

    # Only handle lines starting with export
    echo "$line" | grep -q '^export ' || continue

    # Extract key and value
    key=$(echo "$line" | cut -d'=' -f1 | awk '{print $2}')
    value=$(echo "$line" | cut -d'=' -f2-)

    # Strip surrounding quotes from value
    value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')

    # Convert CORE_LIST to pipe-separated
    [ "$key" = "CORE_LIST" ] && value=$(printf "%s" "$value" | tr ' ' '|')
    [ "$key" = "CPU_CORES" ] && value=$(printf "%s" "$value" | tr ' ' '|')

    echo "${key}=${value}" >> "$OUTFILE"
done < "$INFILE"
