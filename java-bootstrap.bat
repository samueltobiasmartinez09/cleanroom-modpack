@echo off
setlocal enabledelayedexpansion
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%minecraft\jre25\java-bootstrap.exe" (
    "%SCRIPT_DIR%minecraft\jre25\java-bootstrap.exe" %*
    exit /b !ERRORLEVEL!
)
if exist "%SCRIPT_DIR%jre25\java-bootstrap.exe" (
    "%SCRIPT_DIR%jre25\java-bootstrap.exe" %*
    exit /b !ERRORLEVEL!
)
echo java-bootstrap: binary not found
exit /b 1
