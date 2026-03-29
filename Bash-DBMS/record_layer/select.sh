#! /usr/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../table_layer/table_utils.sh"

select_all(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found"
        return 1
    fi

    if [[ ! -s "$data_file" ]];
    then
        echo "Error: Table '$table' is empty"
        return 0
    fi

    local header
    header=$(get_columns "$db_path" "$table" | tr '\n' '|' | sed 's/|$//')

    echo "$header"
    cat "$data_file"
}

select_by_column(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found"
        return 1
    fi

    if [[ ! -s "$data_file" ]];
    then
        echo "Error: Table '$table' is empty"
        return 0
    fi

    echo Available Columns: $(get_columns "$db_path" "$table")

    read -p "Enter columns to display (space seperated or * for all): " -a selected_cols

    if [[ "${selected_cols[0]}" == "*" ]];
    then
        select_all "$db_path" "$table"
        return 0
    fi

    local header=""
    local awk_cols=""

    for cols in "${selected_cols[@]}";
    do
        local idx
        idx=$(get_col_index "$db_path" "$table" "$cols")
        if [[ $? -ne 0 ]];
        then
            echo "Error: column '$cols' not found"
            return 1
        fi
        header="$header|$cols"
        awk_cols="$awk_cols,$idx"
    done


    header="${header#|}"
    awk_cols="${awk_cols#,}"

    {
        echo "$header"
        awk -F'|' \
            -v cols="$awk_cols" \
            -v OFS='|' \
        '
            BEGIN{
                n = split(cols, colidx, ",")
            }
            {
                line=""
                for(i=1; i<=n; i++){
                    if (i==1)
                        line = $colidx[i]
                    else
                        line = line "|" $colidx[i]
                }
                print line
            }
        ' "$data_file"
    }    
}

select_where(){
    local db_path=$1
    local table=$2
    local data_file="$db_path/$table.db"

    if [[ ! -f "$data_file" ]];
    then
        echo "Error: data file for '$table' not found"
        return 1
    fi

    if [[ ! -s "$data_file" ]];
    then
        echo "Error: Table '$table' is empty"
        return 0
    fi

    echo Available Columns: $(get_columns "$db_path" "$table")

    read -p "Enter column to filter by: " filter_col
    read -p "Enter value to search for: " filter_val
    filter_val="${filter_val,,}"

    local header
    header=$(get_columns "$db_path" "$table" | tr '\n' '|' | sed 's/|$//')
    
    local col_index
    col_index=$(get_col_index "$db_path" "$table" "$filter_col")
    if [[ $? -ne 0 ]]
    then
        echo "Error: column '$filter_col' not found"
        return 1
    fi

    local count
    count=$(awk -F'|' \
        -v col="$col_index" \
        -v val="$filter_val" \
        '
        {
            field = tolower($col)
            if(field == val){
                print $0
            }
        }
        ' "$data_file" | wc -l
    )

    if [[ "$count" -eq 0 ]];
    then
        echo "No rows found where '$filter_col' = '$filter_val'"
        return 0
    fi

    echo "$header"
    awk -F'|' \
    -v col="$col_index" \
    -v val="$filter_val" \
    '
    {
        field = tolower($col)
        if(field == val){
            print $0
        }
    }
    ' "$data_file"
}