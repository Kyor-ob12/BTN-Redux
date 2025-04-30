#!/bin/sh

log_file="/mnt/SDCARD/CFW/btn.log"
exec >>"$log_file" 2>&1

CFG_FILE="./settings.conf"  # Change path as needed

# Helper: check if value is a number (integer only)
is_number() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;  # Not a number
        *) return 0 ;;
    esac
}

# Helper: safely get value of export KEY=...
get_setting() {
    key="$1"
    grep "^export $key=" "$CFG_FILE" | cut -d= -f2- | sed 's/^"\(.*\)"$/\1/'
}

# Helper: set or update value
update_setting() {
    key="$1"
    value="$2"

    if ! is_number "$value"; then
        echo "value ' $value ' is not a number. Formating quotes"
        formatted="\"$value\""
        echo "value is now '${formatted}' "
    fi

    if grep -q "^export $key=" "$CFG_FILE"; then
        sed -i "s|^export $key=.*|export $key=$formatted|" "$CFG_FILE"
        echo "key ' $key ' found! Value set to ' ${formatted} '"
    else
        #echo "export $key=$formatted" >> "$CFG_FILE"
        echo "ERROR! key ' $key ' NOT found!"
    fi
}

# --- Main logic ---
case "$1" in
    get)
        [ $# -eq 2 ] || { echo "Usage: $0 get KEY"; exit 1; }
        get_setting "$2"
        ;;
    update)
        [ $# -eq 3 ] || { echo "Usage: $0 update KEY VALUE"; exit 1; }
        update_setting "$2" "$3"
        ;;
    *)
        echo "Usage:"
        echo "  $0 get KEY"
        echo "  $0 update KEY VALUE"
        exit 1
        ;;
esac
