#!/bin/bash

# This script is a simple way to access a website and retrieve the flag text shown on the webpage.

# Usage: ./script.sh MACHINE_IP
# Example: ./script.sh 10.10.63.99

# Retrieve the webpage using curl and store the output in a variable
WEBPAGE=$(curl -s http://$1)

# Use grep to search for the flag text in the webpage
FLAG=$(echo $WEBPAGE | grep -o "flag{.*}")

# Print the flag text
echo "$FLAG"
