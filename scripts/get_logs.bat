@echo off
echo Creating temporary log directory...
if not exist temp_logs mkdir temp_logs

echo Copying Tomcat logs...
copy "D:\Java\tomcat\logs\*.log" temp_logs
copy "D:\Java\tomcat\logs\*.txt" temp_logs

echo Log files copied to temp_logs directory.
