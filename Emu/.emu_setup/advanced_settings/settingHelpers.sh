#!/bin/sh

CFG_FILE="/path/to/opt"

is_number() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;  # Not a number
        *) return 0 ;;
    esac
}

quick_check() {
    [ $# -eq 1 ] || return 1
    value=$(grep "export $1=" "${CFG_FILE}" | cut -d'=' -f2)
    if [ -z "$value" ]; then
        return 1
    else
       return "$value"
    fi
}

update_setting() {
    [ $# -eq 2 ] || return 1
    key="$1"
    value="$2"

    case "$value" in
    "on" | "true" | "1") value=0 ;;
    "off" | "false" | "0") value=1 ;;
    *)
        if ! is_number "$value"; then
            value="\"$value\""
        fi
    esac

    if grep -q "export $key=" "${CFG_FILE}"; then
        sed -i "s/export $key=.*/export $key=$value/" "${CFG_FILE}"
    else
        # Ensure there's a newline at the end of the file before appending
        sed -i -e '$a\' "${CFG_FILE}"
        echo "export $key=$value" >>"${CFG_FILE}"
    fi
}

# Check if arguments are provided and run smart helpers
if [ $# -eq 2 ] && [ "$1" = "check" ]; then
    if quick_check "$2"; then
        echo -n "on"
    else
        echo -n "off"
    fi
elif [ $# -eq 3 ] && [ "$1" = "get" ]; then
    value=$(grep "export $2=" "${CFG_FILE}" | cut -d'=' -f2)
    if [ -z "$value" ]; then
        echo -n "$3"
    else
        echo -n "$value"
    fi
elif [ $# -eq 3 ] && [ "$1" = "update" ]; then
    update_setting "$2" "$3"
fi
