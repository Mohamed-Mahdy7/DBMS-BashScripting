#! /usr/bin/bash

listDBs() {
    echo `ls "$BASE_DIR"` && return 0 || return 1
}