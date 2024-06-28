#!/bin/bash
sns_art=$(figlet SNS scripts)

PRE_SETUP() {
    echo "We have to do some server preconfigurations first"
    sudo dnf update -y
    sudo dnf install figlet -y
    lsblk
    read -p "Choose the partition you want to use for GlusterFS: " partition
    sudo mkfs.xfs -i size=512 /dev/$partition
    sudo mkdir -p /data/brick1
    echo "/dev/$partition /data/brick1 xfs defaults 1 2" | sudo tee -a /etc/fstab
    sudo mount -a && mount
}

INSTALL_GFS() {
    echo "installing glusterfs..."
    yum install glusterfs-server -y
    service glusterd start
    systemctl status glusterd
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
    iptables -I INPUT -p all -s server1 -j ACCEPT
    iptables -I INPUT -p all -s server2 -j ACCEPT
    iptables -I INPUT -p all -s server3 -j ACCEPT
    sleep 3
    echo "Setting up Firewall"
    firewall-cmd --permanent --add-service=glusterfs
    firewall-cmd --reload
    echo "ALL DONE!!!"
}

VOL_CREATE() {
  gluster_peer_state=$(gluster peer status | grep State | awk '{print $5}')
  current_host=$(hostname)

  if [[ "$current_host" == "server1" && "$gluster_peer_state" == "(Connected)" ]]; then
    echo "All servers should be set up. $current_host will create the volume."
    gluster volume create gv0 server1:/data/brick1/gv0 server2:/data/brick1/gv0 server3:/data/brick1/gv0 || {
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
