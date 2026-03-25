#! /usr/bin/bash

listTables() {
    local found=false
    
    for table in "$CURRENT_DB"/*.db
    do
        if [[ -f "$table" ]]
        then
            basename "$table" .db
            found=true
        fi
    done

    if ! $found
    then
        echo "No tables in this DB yet!"
        return 1
    fi
}