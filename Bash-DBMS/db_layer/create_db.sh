#! /usr/bin/bash

createDB() {
    read -p "Enter DataBase Name: " db_name

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
        echo Name not valid!
        echo "DB must start with letter or underscore, only letters/digits/underscores allowed"
        return 1
    fi
}