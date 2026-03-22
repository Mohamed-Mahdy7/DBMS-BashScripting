#! /usr/bin/bash

renameDB() {
    echo 'type "exit" if you want to exit rename DB'
    read -p "Enter DB name: " old_name

    if [[ $old_name =~ ^[Ee][Xx][Ii][Tt]$ ]]
    then
        echo exiting...
        return 0
    fi

    if [[ -d "$BASE_DIR/$old_name" ]]
    then
        read -p "Enter new name: " new_name
        if [[ $new_name =~ ^[Ee][Xx][Ii][Tt]$ ]]
        then
            echo exiting...
            return 0
        fi

        if [[ $new_name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
        then
            mv $BASE_DIR/$old_name $BASE_DIR/$new_name
            echo DB $old_name changed to $new_name
            return 0
        else
            echo "Invalid Name"
            echo "DB must start with letter or underscore, only letters/digits/underscores allowed"
            return 1
        fi
    else
        echo "No DB with that name!"
        echo "Make sure you entered the name correctly"
        return 1
    fi
    case $old_name in
    [Ee][Xx][Ii][Ss][Tt])
        echo exiting...
        return 0
        ;;
    esac
    case $new_name in
    [Ee][Xx][Ii][Ss][Tt])
        echo exiting...
        return 0
        ;;
    esac
}