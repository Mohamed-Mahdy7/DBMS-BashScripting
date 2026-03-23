#! /usr/bin/bash

createTable() {
    
    local table_name="$1"
    local pk_col="$2"
    col_defs=("${@:3}")

    local meta_file="$CURRENT_DB/$table_name.meta"
    local data_file="$CURRENT_DB/$table_name.db"

    if [[ -f $meta_file || -f $data_file ]]
    then
        echo "Error: Table '$table_name' already exists"
        return 1
    fi

    # echo "Enter your table creation in that order: "
    # echo "<table name> <pk col> <col name>:<col type>"
    # echo "Ex) students id id:int name:str age:int email:str"
    

    for col_def in "${col_defs[@]}"
    do
        local col_name=$(echo "$col_def" | cut -d':' -f1)
        local col_type=$(echo "$col_def" | cut -d':' -f2)

        case $col_type in
        "int"|"str")
            ;;
        *)
            echo "Error: column type not supported! only 'int' 'str' supported"
            return 1
            break
        esac

        if [[ "$col_name" == "$pk_col" ]]
        then
            echo "$col_name:$col_type:pk" >> "$meta_file"
        else
            echo "$col_name:$col_type" >> "$meta_file"
        fi
    done
    
    touch "$data_file" 
}