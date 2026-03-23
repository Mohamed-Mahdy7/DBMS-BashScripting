#! /urs/bin/bash

dropTable() {
    local table_name
    read -p "Enter table name to drop: " table_name

    if [[ -f "$CURRENT_DB/$table_name".meta && "$CURRENT_DB/$table_name".db ]]
    then
        echo deleting table...
        rm "$CURRENT_DB/$table_name".meta "$CURRENT_DB/$table_name".db
        return 0
    else
        echo "Table not found!"
        return 1
    fi
}