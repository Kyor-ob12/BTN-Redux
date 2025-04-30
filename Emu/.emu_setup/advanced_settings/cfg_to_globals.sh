#!/bin/sh

INFILE="$1"
OUTFILE="$2"

[ -z "$INFILE" ] || [ -z "$OUTFILE" ] && {
    echo "Usage: $0 input_file output_file"
    exit 1
}

# Start fresh and write shebang line
echo "#!/bin/sh" > "$OUTFILE"

while IFS= read -r line; do
    [ -z "$line" ] && echo >> "$OUTFILE" && continue

    key=$(echo "$line" | cut -d= -f1)
    value=$(echo "$line" | cut -d= -f2-)

    if [ "$key" = "CORE_LIST" ] || [ "$key" = "CPU_CORES" ]; then
        value=$(printf "%s" "$value" | tr '|' ' ')
    fi

    case "$value" in
        ''|*[!0-9]*) value="\"$value\"" ;;
    esac

    echo "export ${key}=${value}" >> "$OUTFILE"
done < "$INFILE"
