#! /usr/bin/bash

listDBs() {
    for db in "$BASE_DIR"/*/
    do
        [[ -d "$db" ]] && basename "$db"
    done
}