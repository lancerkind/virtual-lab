#!/bin/bash

set -o errexit
readonly LOG_FILE="/Users/lancer/debug_script.log"
touch $LOG_FILE
exec 1>$LOG_FILE
exec 2>&1

cat file_doesnt_exist
echo 'hi'

