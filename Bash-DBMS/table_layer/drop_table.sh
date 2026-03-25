#! /urs/bin/bash

dropTable() {
    local table_name
    read -p "Enter table name to drop: " table_name

    if [[ -f "$CURRENT_DB/$table_name".meta && "$CURRENT_DB/$table_name".db ]]
    then
        read -p "Are you sure You want to drop this DB? (y|n): " answer
        case $answer in
        [Yy]|[Yy][Ee][Ss])
            echo deleting table...
            rm "$CURRENT_DB/$table_name".meta "$CURRENT_DB/$table_name".db
            echo "Table $table_name deleted successfully!"
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
        return 0
    else
        echo "Table not found!"
        return 1
    fi
}