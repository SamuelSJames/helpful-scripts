#!/bin/bash

Signature="
  _____ _  _______                     _      __     
 / ___// | / / ___/     _______________(_)___ / /______
 \__ \/ |/ /\__ \______/ ___/ ___/ ___/ / __ \/ __/ ___/
 ___/ / /| /___/ /_____(__ ) /__/ / / / /_/ / /_(__ ) 
/____/_/ |_//____/    /____/\___/_/ /_/ .___/\__/____/ 
                                      /_/               
"

# Function to prompt user for backup directory
function choose_backup_directory() {
  read -p "Enter backup directory path or press Enter for default ($HOME/backups): " BACKUP_DIR_INPUT
  BACKUP_DIR=${BACKUP_DIR_INPUT:-"$HOME/backups"}

  if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Created backup directory: $BACKUP_DIR"
  fi
}

# Function to prompt user for directories to backup
function choose_directories_to_backup() {
  read -p "Enter directories to backup (comma-separated list, press Enter for default): " DIRS_INPUT
  DIRS=${DIRS_INPUT:-"$HOME"}

  # If no specific directories are chosen, use default directories
  if [ -z "$DIRS_INPUT" ]; then
    DEFAULT_DIRS=("$HOME/Documents" "$HOME/Pictures" "$HOME/.config")  # Include user configuration for Ubuntu
    DIRS=$(IFS=,; echo "${DEFAULT_DIRS[*]}")
  fi
}

# Function to perform the backup
function backup_directories() {
  TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
  BACKUP_FILE="$BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz"

  echo "Creating backup file: $BACKUP_FILE"
  tar -czvf "$BACKUP_FILE" $DIRS &> /dev/null

  if [[ $? -eq 0 ]]; then
    echo "Backup completed successfully."
  else
    echo "Backup failed."
  fi
}

# Main script execution
choose_backup_directory
choose_directories_to_backup
backup_directories

# Display completion message and signature
echo "Backup process completed."
echo "$Signature"
exit 0
