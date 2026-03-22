#! /usr/bin/bash

dropDB() {
    echo 'type "exit" if you want to exit drop DB'
    read -p "Enter DataBase Name: " db_name

    if [[ $db_name =~ ^[Ee][Xx][Ii][Tt]$ ]]
    then
        echo exiting...
        return 0
    fi

    if [[ -d "$BASE_DIR/$db_name" ]]
    then
        read -p "Are you sure You want to drop this DB? (y|n): " answer
        case $answer in
        [Yy]|[Yy][Ee][Ss])
            rm -r "$BASE_DIR/$db_name"
            echo "DB $db_name deleted successfully!"
            return 0
            ;;
        [Nn]|[Nn][Oo])
            return 0
            ;;
        *)
            echo "Invalid input!"
            return 1
            ;;
        esac
    else
        echo NO DB with that name exist!
        return 1
    fi
}