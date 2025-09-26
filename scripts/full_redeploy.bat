@echo off
set CATALINA_HOME=D:\Java\tomcat

echo Performing full redeployment...

echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 5 /nobreak > nul

echo Tomcat stopped.

echo Deleting Tomcat work directory...
if exist "%CATALINA_HOME%\work" (
    rmdir /s /q "%CATALINA_HOME%\work"
    echo Work directory deleted.
) else (
    echo Work directory not found, skipping deletion.
)

echo Running main redeploy script...
call redeploy.bat

echo Full redeployment finished.

