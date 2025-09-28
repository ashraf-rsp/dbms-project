@echo off
set CATALINA_HOME=D:\Java\tomcat

echo Starting redeployment process...

echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 5 /nobreak > nul

echo Tomcat stopped.

echo Performing aggressive Tomcat cleanup...

if exist "%CATALINA_HOME%\webapps\dbms-project" (
    echo Deleting deployed application directory...
    rmdir /s /q "%CATALINA_HOME%\webapps\dbms-project"
)

if exist "%CATALINA_HOME%\work\Catalina\localhost\dbms-project" (
    echo Deleting application's work directory...
    rmdir /s /q "%CATALINA_HOME%\work\Catalina\localhost\dbms-project"
)

if exist "%CATALINA_HOME%\work\Catalina\localhost" (
    echo Clearing contents of general work directory...
    del /s /q "%CATALINA_HOME%\work\Catalina\localhost\*"
)

if exist "%CATALINA_HOME%\temp" (
    echo Clearing contents of temp directory...
    del /s /q "%CATALINA_HOME%\temp\*"
)

echo Aggressive cleanup finished.

echo Deploying application...
robocopy webapp "%CATALINA_HOME%\webapps\dbms-project" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np > nul
echo Application deployed.

echo Listing deployed files...
dir "%CATALINA_HOME%\webapps\dbms-project" /s /b > deployed_files.txt

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"
echo Tomcat started.

echo Redeployment process finished.