#!/usr/bin/env bash

# IMPORTANT: This script cannot be run directly from this directory (/storage/emulated/0/...)
# due to Android permissions. 
# To use it, first copy it to your home directory and make it executable:
#
# cp deploy.sh ~/
# chmod +x ~/deploy.sh
# ~/deploy.sh
#

# --- Configuration ---
# Project source directory (ends with a slash to copy contents)
SOURCE_DIR="/storage/emulated/0/LearnTmx/IUS/DBMS/academic-center/webapp/"

# Tomcat deployment directory (the name of the webapp, e.g., 'academic-center')
DEST_DIR="/data/data/com.termux/files/home/apache-tomcat-10.1.44/webapps/academic-center/"

# --- Deployment ---
echo "Starting deployment to Tomcat..."
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo ""

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Use rsync to synchronize the files
# -a: archive mode (preserves permissions, ownership, etc.)
# -v: verbose (shows what files are being transferred)
# --delete: deletes files in the destination that are not in the source
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR"

echo ""
echo "Deployment finished successfully."