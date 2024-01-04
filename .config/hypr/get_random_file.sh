#!/bin/bash

directory=$1

# Get a random file from the directory
random_file=$(ls "$directory" | shuf -n 1)

echo "$directory/$random_file"
