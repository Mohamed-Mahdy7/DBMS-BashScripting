#! /usr/bin/bash

# gets column names of each table
get_columns(){
    local db_path=$1
    local table=$2
    local meta_file="$db_path/$table.meta"
    if [[ ! -f "$meta_file" ]];
    then
        echo "Error: table '$table' not found" >&2
        return 1
    fi

    cut -d':' -f1 "$meta_file"
}

#gets the data types of the columns
get_types(){
    local db_path=$1
    local table=$2
    local meta_file="$db_path/$table.meta"
    if [[ ! -f "$meta_file" ]];
    then
        echo "Error: table '$table' not found" >&2
        return 1
    fi
    
    cut -d':' -f2 "$meta_file"
}

get_pk(){
    local db_path=$1
    local table=$2
    local meta_file="$db_path/$table.meta"
    if [[ ! -f "$meta_file" ]];
    then
        echo "Error: table '$table' not found" >&2
        return 1
    fi
    
    sed -n '/:pk$/s/:.*//p' "$meta_file"
}

get_col_index(){
    local db_path=$1
    local table=$2
    local col_name=$3
    local meta_file="$db_path/$table.meta"
    if [[ ! -f "$meta_file" ]];
    then
        echo "Error: table '$table' not found" >&2
        return 1
    fi

    while IFS=':' read -r name type rest;
    do
        if [[ "$name" == "$col_name" ]]
        then
            echo $index
            return 0
        fi
        (( index++ ))
    done < "$meta_file"
    
    echo "Error: column '$col_name' not found" >&2
    return 1
}