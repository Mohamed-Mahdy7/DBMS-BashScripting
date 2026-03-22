#! /usr/bin/bash

. ./db_layer/create_db.sh
. ./db_layer/list_dbs.sh
. ./db_layer/drop_db.sh
. ./db_layer/rename_db.sh
. ./db_layer/connect_db.sh

menu() {
    echo Select what do you want to do?
    select opt in Connect Create Rename List Drop Exit
    do 
        case $REPLY in
        [Cc][Oo][Nn][Nn][Ee][Cc][Tt]|1)
            connectDB
            ;;
        [Cc][Rr][Ee][Aa][Tt][Ee]|2)
            createDB
            ;;
        [Rr][Ee][Nn][Aa][Mm][Ee]|3)
            renameDB
            ;;
        [Ll][Ii][Ss][Tt]|4)
            listDBs
            ;;
        [Dd][Rr][Oo][Pp]|5)
            dropDB
            ;;
        [Ee][Xx][Ii][Tt]|6)
            echo "exiting..."
            return 0
            ;;
        *)
            echo Invalid Selection!
            echo Try Again
            return 1
        esac
    done
}