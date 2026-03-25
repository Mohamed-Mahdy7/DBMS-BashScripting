#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"

select_all(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found" >&2
        return 1
    fi

    local header
    header=$(get_columns "$db_path" "$table" | tr '\n' '|' | sed 's/|$//')

    echo "$header"
    cat "$data_file"
}