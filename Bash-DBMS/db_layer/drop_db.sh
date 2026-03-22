#! /usr/bin/bash

dropDB() {
    read -p "Enter DataBase Name: " db_name

    if [[ -d "$BASE_DIR/$db_name" ]]
    then
        read -p "Are you sure You want to drop this DB? (y|n): " answer
        case $answer in
        "y"|"Y"|[Yy][Es][Ss])
            `rm -r "$BASE_DIR/$db_name"`
            echo "DB $db_name deleted successfully!"
            return 0
            ;;
        "n"|"N"|[Nn][Oo])
            return 0
            ;;
        esac
    else
        echo NO DB with that name exist!
        return 1
    fi
}