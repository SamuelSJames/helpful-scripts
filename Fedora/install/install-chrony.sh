#!/bin/bash

echo "
    ***************************************************************************
    This script will perform the following tasks:

    Update the system and install the chrony package.
    Enable and start the chrony service.
    Back up the existing chrony configuration file.
    Add the specified NTP servers to the chrony configuration.
    Restart the chrony service to apply the changes.
    Display the status of the chrony service and the NTP synchronization details.
    *****************************************************************************"
sleep 5

# Function to display a status bar
status_bar() {
    local duration=$1
    local interval=0.2
    local count=$(($duration / $interval))
    local i=0

    while [ $i -le $count ]; do
        printf "\r["
        for ((j=0; j<$i; j++)); do
            printf "="
        done
        for ((j=$i; j<$count; j++)); do
            printf " "
        done
        printf "]"
        sleep $interval
        i=$((i+1))
    done
    printf "\n"
}

# Define NTP servers
NTP_SERVERS=("2.fedora.pool.ntp.org" "pool.ntp.org" "time.google.com")

echo "Updating system and installing chrony..."
status_bar 10
# Update system and install chrony
sudo dnf update -y
sudo dnf install -y chrony

echo "Enabling and starting chrony service..."
status_bar 5
# Enable and start chrony service
sudo systemctl enable chronyd
sudo systemctl start chronyd

echo "Backing up existing chrony configuration file..."
status_bar 3
# Configure chrony
CHRONY_CONF="/etc/chrony.conf"
sudo cp ${CHRONY_CONF} ${CHRONY_CONF}.bak

echo "Adding NTP servers to chrony configuration..."
status_bar 5
echo "# NTP configuration for chrony" | sudo tee ${CHRONY_CONF} > /dev/null

# Add NTP servers to configuration
for SERVER in "${NTP_SERVERS[@]}"; do
    echo "server ${SERVER} iburst" | sudo tee -a ${CHRONY_CONF} > /dev/null
done

echo "Restarting chrony service to apply changes..."
status_bar 5
# Restart chrony service to apply changes
sudo systemctl restart chronyd

echo "Displaying chrony status and NTP synchronization details..."
status_bar 5
# Verify chrony status and configuration
sudo systemctl status chronyd
chronyc tracking
chronyc sources -v
