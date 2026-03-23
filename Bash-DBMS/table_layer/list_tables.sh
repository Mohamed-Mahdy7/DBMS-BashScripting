#! /usr/bin/bash

listTables() {
    local found=false
    
    for table in "databases/db2"/*
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