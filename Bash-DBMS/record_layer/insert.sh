#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"

insert_row(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found"
        return 1
    fi
    local value
    local columns
    local types
    local pk_col
    local row
    local i=0
    columns=$(get_columns "$db_path" "$table")
    types=$(get_types "$db_path" "$table")
    pk_col=$(get_pk "$db_path" "$table")
    
    echo Columns: $(get_columns "$db_path" "$table")

    read -p "Enter values (space seperated): " -a values

    while IFS=$'\t' read -r col_name col_type;
    do
        echo "column: $col_name, type: $col_type"
        local value="${values[$i]}"
        validate_type "$value" "$col_type" || return 1
        if [[ "$col_name"  == "$pk_col" ]];
        then
            check_pk "$db_path" "$table" "$value" || return 1
        fi
        row="$row|$value"
        (( i++ ))
    done < <(paste <(echo "$columns") <(echo "$types"))

    row="${row#|}"

    echo "$row" >> "$data_file"
    echo "Row insterted successfully"
}