#!/bin/bash

# Function to check if Figlet is installed
function check_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo "Figlet is not installed. Installing..."
        sudo dnf install -y figlet
        if [[ $? -ne 0 ]]; then
            echo "Failed to install Figlet. Exiting."
            exit 1
        fi
    fi
}

# Clean cache for Fedora
check_figlet

echo "Cleaning cache for Fedora..."
sudo dnf clean all
echo "cache is clean....."

# Signature using Figlet
figlet -f slant "SNS-scripts"
