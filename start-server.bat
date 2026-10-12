@echo off
title Vehicle Rental Server (Apache Tomcat 10.1)
cls
echo ===================================================================
echo               STARTING VEHICLE RENTAL APPLICATION                  
echo ===================================================================
echo.

set "CATALINA_HOME=C:\apache-tomcat-10.1.59\apache-tomcat-10.1.59"
set "CATALINA_BASE=C:\apache-tomcat-10.1.59\apache-tomcat-10.1.59"
set "JAVA_HOME=C:\Program Files\Java\jdk-25"
set "JRE_HOME=C:\Program Files\Java\jdk-25"

echo [1/3] Checking MySQL service...
sc query MySQL80 | find "RUNNING" >nul
if errorlevel 1 (
    echo [WARNING] MySQL80 service is not running! Starting MySQL80...
    net start MySQL80
) else (
    echo [OK] MySQL80 service is active.
)

echo.
echo [2/3] Syncing latest VehicleRental.war to Tomcat webapps...
copy /Y "target\VehicleRental.war" "%CATALINA_HOME%\webapps\VehicleRental.war" >nul
echo [OK] Deployed VehicleRental.war successfully.

echo.
echo [3/3] Launching Apache Tomcat Server...
start "Tomcat - Vehicle Rental (Port 8081)" "%CATALINA_HOME%\bin\catalina.bat" run

echo.
echo ===================================================================
echo                     TOMCAT HAS STARTED!                            
echo ===================================================================
echo.
echo You can now access your application in any web browser at:
echo.
echo    --^> http://localhost:8081/VehicleRental/
echo.
echo To STOP Tomcat, close the Tomcat console window or run stop-server.bat
echo ===================================================================
echo.
pause
