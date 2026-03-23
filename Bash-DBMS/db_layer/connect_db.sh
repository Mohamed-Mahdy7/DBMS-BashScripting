#! /usr/bin/bash

connectDB() {
    echo 'type "exit" if you want to exit connect DB'
    read -p "Enter DB Name to connect to: " db_name

    if [[ $db_name =~ ^[Ee][Xx][Ii][Tt]$ ]]
    then
        echo exiting...
        CURRENT_DB=""
        echo CURRENT_BD $CURRENT_DB
        return 0
    fi

    if [[ -d "$BASE_DIR/$db_name" ]]
    then
        CURRENT_DB=$BASE_DIR/$db_name
        echo CURRENT_BD $CURRENT_DB
        echo Connected to $db_name
        # call table_menu here
        return 0
    else
        echo "No DB with that name!"
        echo "Make sure you entered the name correctly"
        return 1
    fi
}