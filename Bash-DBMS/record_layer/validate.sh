#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"

validate_type(){
    local value=$1
    local type=$2

    case $type in
    int)
        [[ "$value" =~ ^-?[0-9]+$ ]] || {
            echo "Error: '$value' is not a valid int" >&2
            return 1
        }
        ;;
    str)
        [[ -z "$value" ]] && {
            echo "Error: string value cannot be empty" >&2
            return 1
        }
        ;;
    date)
        [[ "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || {
            echo "Error: '$value' is not a valid date (YYY-MM-DD)" >&2
            return 1
        }
        ;;
    *)
        echo "Error: unkown type '$type'" >&2
        return 1
        ;;
    esac
    return 0
}

check_pk(){
    local db_path=$1
    local table=$2
    local pk_value=$3
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found" >&2
        return 1
    fi

    local pk_col
    pk_col=$(get_pk "$db_path" "$table")

    local pk_index
    pk_index=$(get_col_index "$db_path" "$table" "$pk_col")

    local found
    found=$(awk -F'|' \
                -v col="$pk_index" \
                -v val="$pk_value" \
            '
            BEGIN{
                found=0
            }
            {
                if($col == val){
                    found=1
                }
            }
            END{
                print found
            }
            ' "$data_file")

    if [[ "$found" -eq 1 ]];
    then
        echo "Error: primary key '$pk_value' already exists" >&2
        return 1
    fi
    
    return 0
}