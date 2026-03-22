#! /usr/bin/bash

createDB() {
    echo 'type "exit" if you want to exit create DB'
    read -p "Enter DB Name: " db_name

    if [[ $db_name =~ ^[Ee][Xx][Ii][Tt]$ ]]
    then
        echo exiting...
        return 0
    fi

    if [[ $db_name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] 
    then
        echo Valid DB Name

        if [[ -d "$BASE_DIR/$db_name" ]]
        then
            echo DB with that name already exist!
            return 1
        else
            echo DB initiated successfully!
            mkdir $BASE_DIR/$db_name
        return 0
        fi
    else
        echo Invalid name!
        echo "DB must start with letter or underscore, only letters/digits/underscores allowed"
        return 1
    fi
}