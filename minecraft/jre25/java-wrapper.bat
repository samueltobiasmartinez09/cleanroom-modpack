@echo off
set "SCRIPT_DIR=%~dp0"
set "JRE_DIR=%SCRIPT_DIR%"
if not exist "%JRE_DIR%\bin\java.exe" (
    call "%~dp0..\install-java.bat" || exit /b 1
)
"%JRE_DIR%\bin\java.exe" %*