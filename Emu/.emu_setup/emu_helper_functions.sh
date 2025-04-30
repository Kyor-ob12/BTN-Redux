#!/bin/sh
# Custom functions for manual config scripts
get_next_item() {
    
    # Input parameters
    current_option=$1
    arr_options=$2

    # Variables
    found=0
    first=""

    for option in $arr_options; do
        [ -z "$first" ] && first=$option

        if [ "$found" -eq 1 ]; then
            echo "$option"
            exit 0
        fi

        [ "$option" = "$current_option" ] && found=1
    done

    if [ "$found" -eq 1 ]; then
        echo "$first"
    else
        echo "Error: '$target' not found in array" >&2
        return 1
    fi
}

get_selected_item_display() {
    array="$2"
    target="$1"

    echo "$array" | sed "s/\b$target\b/(✓ $(printf %s "$target" | tr 'a-z' 'A-Z'))/g" | sed 's/ \?-/-/g'
}
