#!/bin/bash

# Terminal colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Icons
CHECK_MARK="\xE2\x9C\x94"
CROSS_MARK="\xE2\x9D\x8C"
INFO="\xE2\x84\xB9"

# Function to display a status bar
function show_progress() {
    local -r msg=$1
    local -r percent=$2
    local -r completed=$(($percent / 2))
    local -r pending=$((50 - $completed))
    printf "\r[%-50s] %d%% %s" "$(printf "%0.s=" $(seq 1 $completed))>" $percent "$msg"
}

# Update the package list
echo -e "${BLUE}${INFO} Updating the package list...${NC}"
sudo apt-get update
if [[ $? -ne 0 ]]; then
    echo -e "${RED}${CROSS_MARK} Package list update failed!${NC}"
    exit 1
fi
show_progress "Updating package list" 25
sleep 1

# Upgrade the packages
echo -e "${BLUE}${INFO} Upgrading the packages...${NC}"
sudo apt-get upgrade -y
if [[ $? -ne 0 ]]; then
    echo -e "${RED}${CROSS_MARK} Package upgrade failed!${NC}"
    exit 1
fi
show_progress "Upgrading packages" 50
sleep 1

# Full upgrade the system
echo -e "${BLUE}${INFO} Performing a full upgrade...${NC}"
sudo apt-get full-upgrade -y
if [[ $? -ne 0 ]]; then
    echo -e "${RED}${CROSS_MARK} Full upgrade failed!${NC}"
    exit 1
fi
show_progress "Full upgrade" 75
sleep 1

# Clean up the system
echo -e "${BLUE}${INFO} Cleaning up the system...${NC}"
sudo apt-get autoremove -y
sudo apt-get clean
sudo apt install figlet -y
if [[ $? -ne 0 ]]; then
    echo -e "${RED}${CROSS_MARK} System cleanup failed!${NC}"
    exit 1
fi
show_progress "Cleaning up system" 100
sleep 1

echo -e "\n${GREEN}${CHECK_MARK} System update and maintenance completed successfully!${NC}"
figlet SNS-scripts