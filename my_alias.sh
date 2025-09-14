#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

BASHRC_CON="
alias update='sudo apt update && sudo apt upgrade'
alias c='clear'
alias gs='git status'
alias batdock='sudo docker ps | bat -l conf'
#alias wgup='sudo wg-quick up wg0'
#alias wgdown='sudo wg-quick down wg0'
"

# Check if the .bashrc file exists, create it if it doesn't
if [ ! -f "$BASHRC_FILE" ]; then
    touch "$BASHRC_FILE"
    echo "Created a new file: $BASHRC_FILE"
fi

# Split the multiline string into an array and add each line if it doesn't exist
IFS=$'\n' read -d '' -ra LINES_ARRAY <<< "$BASHRC_LINES"

for line in "${LINES_ARRAY[@]}"; do
    # Remove leading/trailing whitespace from the line for accurate checking
    trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if [ -n "$trimmed_line" ] && ! grep -qF "$trimmed_line" "$BASHRC_FILE"; then
        echo "$trimmed_line" >> "$BASHRC_FILE"
        echo "Added line: $trimmed_line"
    else
        echo "Line already exists or is empty: $trimmed_line"
    fi
done
