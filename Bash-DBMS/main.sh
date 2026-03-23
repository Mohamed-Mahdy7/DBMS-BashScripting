#! /usr/bin/bash

BASE_DIR=$(dirname $0)/databases
mkdir -p $BASE_DIR

CURRENT_DB=""

. ./db_layer/db_menu.sh

while true
do
    menu
    status=$?

    if [[ $status -eq 0 ]]
    then
        break
    else
        echo "Back to menu..."
    fi
done