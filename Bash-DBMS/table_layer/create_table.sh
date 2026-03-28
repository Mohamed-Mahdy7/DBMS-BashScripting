#! /usr/bin/bash

createTable() {
    echo "Enter your table creation in that order: "
    echo "<table name> <pk col> <col name>:<col type>"
    echo "Ex) students id id:int name:str age:int email:str"
    echo
    read -p "Create your table : " -a input

    local table_name="${input[0]}"
    local pk_col="${input[1]}"
    col_defs=("${input[@]:2}")

    local meta_file="$CURRENT_DB/$table_name.meta"
    local data_file="$CURRENT_DB/$table_name.db"

    if [[ "$pk_col" == *:* ]]; then
    echo "Error: Primary key should be column name only (like: id), not id:int"
    return 1
    fi

    if [[ -f $meta_file || -f $data_file ]]
    then
        echo "Error: Table '$table_name' already exists"
        return 1
    fi

    if [[ $col_defs == "" ]]
    then
        echo "Error: Invalid input, make sure you entered the table columns and types!"
        return 1
    else
        for col_def in "${col_defs[@]}"
        do
            local col_name=$(echo "$col_def" | cut -d':' -f1)
            local col_type=$(echo "$col_def" | cut -d':' -f2)

            if [[ $col_type != "int" && $col_type != "str" ]]
            then 
                echo "Error: Invalid column type! Only 'int' and 'str' are allowed (no extra spaces allowed)."
                return 1
            fi
        done

        for col_def in "${col_defs[@]}"
        do
            local col_name=$(echo "$col_def" | cut -d':' -f1)
            local col_type=$(echo "$col_def" | cut -d':' -f2)

            if [[ "$col_name" == "$pk_col" ]]
                then
                    echo "$col_name:$col_type:pk" >> "$meta_file"
            else
                echo "$col_name:$col_type" >> "$meta_file"
            fi
        done

    touch "$data_file" 
    echo "Table $table_name created successfully!"
    fi
}