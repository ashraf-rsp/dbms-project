@echo off
set CATALINA_HOME=D:\Java\tomcat

echo Starting redeployment process...
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

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"
echo Tomcat started.

echo.
echo Waiting for Tomcat to fully start and application to deploy...
timeout /t 15 /nobreak > nul

echo.
echo Displaying the latest catalina.log entries for RealtimeManager errors:
rem Find the most recent catalina log file
for /f "delims=" %%i in ('dir /b /od "%CATALINA_HOME%\logs\catalina.*.log"') do set "latestLogFile=%%i"

if exist "%CATALINA_HOME%\logs\%latestLogFile%" (
    echo --- Content of %latestLogFile% ---
    type "%CATALINA_HOME%\logs\%latestLogFile%" | findstr /i /c:"RealtimeManager" /c:"SEVERE" /c:"WARNING" /c:"Exception"
    echo --- End of %latestLogFile% ---
) else (
    echo Latest catalina log file not found.
)

echo.
echo Redeployment and log check finished.
