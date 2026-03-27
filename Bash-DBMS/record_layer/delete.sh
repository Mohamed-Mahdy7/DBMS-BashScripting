#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"

delete_row(){
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

    read -p "Enter PK value to delete: " pk_value

    local tmp_file
    tmp_file=$(mktemp)

    awk -F'|' \
    -v col="$pk_index" \
    -v val="$pk_value" \
    '
    BEGIN{
        deleted=0
    }
    {
        if($col==val)
        {
            deleted=1
        }
        else{
            print $0
        }
    }
    END{
        exit !deleted
    }
    ' "$data_file" > "$tmp_file"

    if [[ $? -eq 0 ]];
    then
        mv "$tmp_file" "$data_file"
        echo "Row deleted successfully"
    else
        rm "$tmp_file"
        echo "Error: PK '$pk_value' not found"
        return 1
    fi
}