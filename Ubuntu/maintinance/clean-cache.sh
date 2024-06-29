#!/bin/bash

# Function to check if Figlet is installed
function check_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo "Figlet is not installed. Installing..."
        sudo apt-get update
        sudo apt-get install -y figlet
        if [[ $? -ne 0 ]]; then
            echo "Failed to install Figlet. Exiting."
            exit 1
        fi
    fi
}

# Clean cache for Ubuntu
check_figlet

echo "Cleaning cache for Ubuntu..."
sudo apt-get clean
echo "cache is clean....."

# Signature using Figlet
figlet -f slant "SNS-scripts"
