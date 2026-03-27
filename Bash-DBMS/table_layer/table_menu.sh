#! /usr/bin/bash

. ./table_layer/create_table.sh
. ./table_layer/list_tables.sh
. ./table_layer/drop_table.sh

source "$(dirname "${BASH_SOURCE[0]}")/../record_layer/select.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../record_layer/insert.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../record_layer/update.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../record_layer/delete.sh"

table_menu() {
    
    select opt in Create List Drop Insert Select Delete Update Back
    do
        case $REPLY in
        [Cc][Rr][Ee][Aa][Tt][Ee]|1)
            createTable
            ;;
        [Ll][Ii][Ss][Tt]|2)
            listTables
            ;;
        [Dd][Rr][Oo][Pp]|3)
            dropTable
            ;;
        [Ii][Nn][Ss][Ee][Rr][Tt]|4)
            read -p "Enter table name: " table_name
            insert_row "$CURRENT_DB" "$table_name"
            ;;
        [Ss][Ee][Ll][Ee][Cc][Tt]|5)
            read -p "Enter table name: " table_name
            select_by_column "$CURRENT_DB" "$table_name"
            ;;
        [Dd][Ee][Ll][Ee][Tt][Ee]|6)
            read -p "Enter table name: " table_name
            delete_row "$CURRENT_DB" "$table_name"
            ;;
        [Uu][Pp][Dd][Aa][Tt][Ee]|7)
            read -p "Enter table name: " table_name
            update_row "$CURRENT_DB" "$table_name"
            ;;
        [Ee][Xx][Ii][Tt]|8)
            echo "exiting..."
            return 0
            ;;
        *)
            echo Input invalid!
            echo Try Again!
        esac
    done
}    