#! /usr/bin/bash

. ./table_layer/create_table.sh
. ./table_layer/list_tables.sh
. ./table_layer/drop_table.sh

source "$(dirname "${BASH_SOURCE[0]}")/../record_layer/select.sh"

table_menu(){
    select menu in create list drop insert_row select_all delete_row update_row back
        do
            case $menu in
                "create")
                    createTable
                    ;;
                "list")
                    listTables
                    ;;
                "drop")
                    dropTable
                    ;;
                "insert_row")
                    echo "Coming soon..."
                    ;;
                "select_all")
                    read -p "Enter table name: " table_name
                    select_all "$CURRENT_DB" "$table_name"
                    ;;
                "delete_row")
                    echo "Coming soon..."
                    ;;
                "update_row")
                    echo "Coming soon..."
                    ;;
                "back")
                    break
                    ;;
                *)
                    echo "Input invalid" 
                    ;;
            esac
        done
}    