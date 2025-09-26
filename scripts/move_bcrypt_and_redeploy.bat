@echo off
set CATALINA_HOME=D:\Java\tomcat

echo Moving bcrypt JAR to Tomcat lib directory...
move "webapp\WEB-INF\lib\bcrypt-0.10.2.jar" "%CATALINA_HOME%\lib\"

echo Running full redeploy script...
call redeploy.bat

echo Finished moving bcrypt and redeploying.

