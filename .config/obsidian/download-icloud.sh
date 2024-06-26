#!/bin/bash

# Execute the command
brctl download '/Users/roger/Library/Mobile Documents/iCloud~md~obsidian/Documents/vault'

# Check the exit status of the command
if [ $? -eq 0 ]; then
    # If the command exits successfully (exit status 0)
    echo "$(date -Iseconds) download started successfully"
else
    # If the command exits with an error (non-zero exit status)
    echo "$(date -Iseconds) download failed" >&2
fi
