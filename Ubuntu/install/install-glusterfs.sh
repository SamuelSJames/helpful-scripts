#!/bin/bash

countdown_message() {
  message="BEFORE RUNNING THIS SCRIPT RUN THE install-chrony.sh script. You have 20 seconds to cancel and restart..."  # Customize the message
  duration=20  # Set the countdown duration in seconds

  # Function to handle Ctrl+C interruption
  handle_interrupt() {
    echo -e "\nCountdown canceled."
    exit 1  # Indicate cancellation with a non-zero exit code
  }

  # Set the trap to catch Ctrl+C
  trap handle_interrupt SIGINT

  # Print the message
  echo "$message"

  # Loop for the countdown duration
  for (( i=duration; i>=0; i-- )); do
    # Print remaining time with leading zeros
    printf "\rRemaining: %02d seconds (Press Ctrl+C to cancel)..." "$i"
    sleep 1
  done

  echo -e "\n"  # Add a newline after the countdown
}

countdown_message
sns_art=$(figlet SNS scripts)
# Your script execution continues here if not canceled...
echo "Continuing with the script execution..."

PRE_SETUP() {
    echo "We have to do some server preconfigurations first"
    sudo apt-get update -y
    sudo apt-get install figlet xfsprogs -y
    lsblk
    read -p "Choose the partition you want to use for GlusterFS: " partition
    sudo mkfs.xfs -i size=512 /dev/$partition
    sudo mkdir -p /data/brick1
    echo "/dev/$partition /data/brick1 xfs defaults 1 2" | sudo tee -a /etc/fstab
    sudo mount -a && mount
}

INSTALL_GFS() {
    echo "installing glusterfs..."
    sudo apt-get install glusterfs-server -y
    sudo systemctl start glusterd
    sudo systemctl status glusterd
}

ADD_IP(){
    echo "Let's add the cluster IP addresses to the /etc/hosts file..."
    read -p "Whats server1 ip?.." server1
    echo "$server1 server1" | sudo tee -a /etc/hosts
    read -p "Whats server2 ip?.." server2
    echo "$server2 server2" | sudo tee -a /etc/hosts
    read -p "Whats server3 ip?..." server3
    echo "$server3 server3" | sudo tee -a /etc/hosts
    cat /etc/hosts
}

FIREWALL(){
    echo "Adding iptable rules"
    sudo ufw allow from $server1 to any port 24007 proto tcp
    sudo ufw allow from $server2 to any port 24007 proto tcp
    sudo ufw allow from $server3 to any port 24007 proto tcp
    sudo ufw allow from $server1 to any port 24008 proto tcp
    sudo ufw allow from $server2 to any port 24008 proto tcp
    sudo ufw allow from $server3 to any port 24008 proto tcp
    sudo ufw reload
    echo "ALL DONE!!!"
}

VOL_CREATE() {
  gluster_peer_state=$(gluster peer status | grep State | awk '{print $5}')
  current_host=$(hostname)

  if [[ "$current_host" == "server1" && "$gluster_peer_state" == "(Connected)" ]]; then
    echo "All servers should be set up. $current_host will create the volume."
    sudo gluster volume create gv0 server1:/data/brick1/gv0 server2:/data/brick1/gv0 server3:/data/brick1/gv0 || {
      echo "Error creating volume. Check Gluster logs for details."
      exit 1
    }
  else
    echo "Skipping volume creation. This script should only run on server1 and when peers are connected."
  fi
}

PRE_SETUP
INSTALL_GFS
ADD_IP
FIREWALL
VOL_CREATE

echo "GlusterFS installation and configuration completed successfully."
echo "The following actions were performed:"
echo "1. Pre-configuration of server with partition setup and mounting."
echo "2. Installation and starting of GlusterFS server."
echo "3. Addition of server IP addresses to /etc/hosts."
echo "4. Configuration of firewall rules for GlusterFS."
echo "5. Creation of GlusterFS volume (if on server1 and peers are connected)."

echo "$sns_art"

exit 0
