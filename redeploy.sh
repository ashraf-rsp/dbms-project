#!/usr/bin/env bash

# This script automates the process of stopping Tomcat, clearing the work directory,
# deploying the application, and starting Tomcat.

# IMPORTANT: This script is written to your project directory.
# To use it, first copy it to your home directory and make it executable:
#
# cp /storage/emulated/0/LearnTmx/IUS/DBMS/academic-center/redeploy.sh ~/
# chmod +x ~/redeploy.sh
#
# Then you can run it from anywhere using: ~/redeploy.sh

# --- Configuration (ensure these paths are correct) ---
TOMCAT_HOME="/data/data/com.termux/files/home/apache-tomcat-10.1.44"
WEBAPP_NAME="academic-center"
DEPLOY_SCRIPT="/data/data/com.termux/files/home/deploy.sh"

# --- Functions ---
stop_tomcat() {
    echo "Stopping Tomcat..."
    "$TOMCAT_HOME/bin/shutdown.sh"
    sleep 5 # Give Tomcat some time to shut down
    # Check if Tomcat process is still running and kill it if it is
    TOMCAT_PID=$(pgrep -f "$TOMCAT_HOME")
    if [ -n "$TOMCAT_PID" ]; then
        echo "Tomcat process still running (PID: $TOMCAT_PID). Killing it..."
        kill -9 "$TOMCAT_PID"
        sleep 2
    fi
    echo "Tomcat stopped."
}

clear_work_directory() {
    echo "Clearing Tomcat work directory for $WEBAPP_NAME..."
    rm -rf "$TOMCAT_HOME/work/Catalina/localhost/$WEBAPP_NAME/"
    echo "Work directory cleared."
}

deploy_application() {
    echo "Deploying application using $DEPLOY_SCRIPT..."
    "$DEPLOY_SCRIPT"
    echo "Application deployed."
}

start_tomcat() {
    echo "Starting Tomcat..."
    "$TOMCAT_HOME/bin/startup.sh"
    echo "Tomcat started."
}

# --- Main execution ---
echo "Starting redeployment process..."

stop_tomcat
clear_work_directory
deploy_application
start_tomcat

echo "Redeployment process finished."