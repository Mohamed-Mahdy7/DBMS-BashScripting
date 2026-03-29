#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"

update_row(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

        if [[ ! -f "$data_file" ]];
        then
            echo "Error: data file for '$table' not found"
            return 1
        fi
    local pk_col
    local pk_index
    pk_col=$(get_pk "$db_path" "$table")
    pk_index=$(get_col_index "$db_path" "$table" "$pk_col")

    read -p "Enter PK value to update: " pk_value

    echo "Current row:"
    awk -F'|' \
    -v col="$pk_index" \
    -v val="$pk_value" \
    '
    {
        if($col==val)
        {
            print $0
        }
    }
    ' "$data_file"

    echo "Available Columns:"
    get_columns "$db_path" "$table"

    read -p "Enter column name to update: " target_col

    local target_index
    target_index=$(get_col_index "$db_path" "$table" "$target_col")
    if [[ $? -ne 0 ]];
    then
        echo "Error: column '$target_col' not found"
        return 1
    fi

    local target_type
    target_type=$(get_types "$db_path" "$table"| awk -v idx="$target_index" 'NR==idx{print $0}')

    read -p "Enter new value: " new_value

    validate_type "$new_value" "$target_type" || return 1

    local tmp_file
    tmp_file=$(mktemp)

    awk -F'|' \
        -v col="$pk_index" \
        -v val="$pk_value" \
        -v target="$target_index" \
        -v newval="$new_value" \
    '
    BEGIN{
        OFS="|"
        updated=0
    }
    {
        if($col == val)
        {
            $target=newval
            updated=1
        }
        print $0
    }
    END{
        exit !updated
    }
    ' "$data_file" > "$tmp_file"

    if [[ $? -eq 0 ]];
    then
        mv "$tmp_file" "$data_file"
        echo "Row updated successfully"
    else
        rm "$tmp_file"
        echo "Error: PK '$pk_value' not found"
        return 1
    fi
}