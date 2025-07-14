#!/bin/bash

PROJECT="<project>"
INSTANCE="<instance>"
ZONE="asia-northeast3-c"
PORT=1
START=0

while true; do
    OUTPUT=$(gcloud compute --project="$PROJECT" instances get-serial-port-output "$INSTANCE" --zone="$ZONE" --port="$PORT" --start="$START" 2>&1)

    if [[ -z "$OUTPUT" ]]; then
        echo "No new output available."
        sleep 2
        continue
    fi

    NEW_START=$(echo "$OUTPUT" | grep "Specify --start=" | sed -E 's/.*--start=([0-9]+).*/\1/')

    #OUTPUT_TO_PRINT=$(echo "$OUTPUT" | grep -v "Specify --start=" | sed '/^$/d')
    OUTPUT_TO_PRINT=$(echo "$OUTPUT" | awk '/Specify --start=/{skip=3} skip>0{skip--; next} 1' | sed '/^$/d')

    if [[ -n "$OUTPUT_TO_PRINT" ]]; then
        echo "$OUTPUT_TO_PRINT"
    fi

    if [[ -n "$NEW_START" ]]; then
        START=$NEW_START
    else
        echo "Could not update START value. Keeping the previous START value."
    fi

    sleep 2
done
