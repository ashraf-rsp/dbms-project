#!/bin/bash
# Set JAVA_HOME to ensure Tomcat can find Java
export JAVA_HOME=/data/data/com.termux/files/usr/lib/jvm/java-21-openjdk

echo "Starting redeployment process..."

# Stop Tomcat
echo "Stopping Tomcat..."
/data/data/com.termux/files/home/apache-tomcat-10.1.44/bin/shutdown.sh

# Wait a moment for Tomcat to shut down
sleep 2

echo "Tomcat stopped."

# Clear work directory
echo "Clearing Tomcat work directory for academic-center..."
rm -rf /data/data/com.termux/files/home/apache-tomcat-10.1.44/work/Catalina/localhost/academic-center
echo "Work directory cleared."

# Deploy application
echo "Deploying application using /data/data/com.termux/files/home/deploy.sh..."
/data/data/com.termux/files/home/deploy.sh
echo "Application deployed."

# Start Tomcat
echo "Starting Tomcat..."
/data/data/com.termux/files/home/apache-tomcat-10.1.44/bin/startup.sh
echo "Tomcat started."

echo "Redeployment process finished."
