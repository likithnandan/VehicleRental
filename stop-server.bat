@echo off
set "CATALINA_HOME=C:\apache-tomcat-10.1.59\apache-tomcat-10.1.59"
set "CATALINA_BASE=C:\apache-tomcat-10.1.59\apache-tomcat-10.1.59"
set "JAVA_HOME=C:\Program Files\Java\jdk-25"
set "JRE_HOME=C:\Program Files\Java\jdk-25"

echo Stopping Tomcat server...
call "%CATALINA_HOME%\bin\shutdown.bat"
echo Tomcat stopped.
pause
