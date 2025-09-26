@echo off
set CATALINA_HOME=D:\Java\tomcat

echo Starting redeployment process...

echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 5 /nobreak > nul

echo Tomcat stopped.

echo Clearing Tomcat work directory completely...
if exist "%CATALINA_HOME%\work" (
    rmdir /s /q "%CATALINA_HOME%\work"
    mkdir "%CATALINA_HOME%\work"
    echo Work directory cleared and recreated.
) else (
    echo Work directory not found, skipping.
)

echo Clearing Tomcat temp directory...
if exist "%CATALINA_HOME%\temp" (
    rmdir /s /q "%CATALINA_HOME%\temp"
    mkdir "%CATALINA_HOME%\temp"
    echo Temp directory cleared and recreated.
) else (
    echo Temp directory not found, skipping.
)

echo Deploying application...
robocopy webapp "%CATALINA_HOME%\webapps\dbms-project" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np > nul
echo Application deployed.

echo Listing deployed files...
dir "%CATALINA_HOME%\webapps\dbms-project" /s /b > deployed_files.txt

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"
echo Tomcat started.

echo Redeployment process finished.