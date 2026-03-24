#! /usr/bin/bash

listDBs() {
    local found=flase
    for db in "$BASE_DIR"/*/
    do
        if [[ -d "$db" ]] 
        then 
            basename "$db"
            found=true
        fi
    done

    if ! $found
    then
        echo "No DBs found!"
        return 1
    fi
}