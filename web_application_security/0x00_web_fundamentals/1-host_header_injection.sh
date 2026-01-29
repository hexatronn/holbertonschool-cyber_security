#!/bin/bash

# Check if all 3 arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <NEW_HOST> <TARGET_URL> <FORM_DATA>"
    exit 1
fi

NEW_HOST=$1
TARGET_URL=$2
FORM_DATA=$3

curl -s -X POST -H "Host: $NEW_HOST" -d "$FORM_DATA" "$TARGET_URL"
