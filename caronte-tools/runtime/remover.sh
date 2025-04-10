#!/bin/bash

I=0
# Define the directory to check
DIRECTORY="./log/"
while [[ 1 == 1 ]]; do
    sleep 60
    I=$((I + 1))
    # Count the number of files in the directory
    FILE_COUNT=$(ls -1q "$DIRECTORY" | wc -l)

    # Check if there are more than 3 files
    if [ "$FILE_COUNT" -gt 3 ]; then
        # Find the oldest file and remove it
        OLDEST_FILE=$(ls -t "$DIRECTORY" | tail -n 1)
        rm "$DIRECTORY/$OLDEST_FILE"
        echo "Removed the oldest file: $OLDEST_FILE"
        I=0
    else
        echo "There are 3 or fewer files, nothing to remove."

    fi
    if [ "$I" -gt 5 ]; then
        echo "===================================================================================="
        echo "===================================================================================="
        echo "=============   PROCESS STOPPED, NO FILES WERE CREATED FOR 5 MINUTES   ============="
        echo "=============              MAYBE TRY CHECKING THE SNIFFER              ============="
        echo "===================================================================================="
        echo "===================================================================================="

        exit 1
    fi
done
