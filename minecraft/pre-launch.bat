@echo off
setlocal enabledelayedexpansion
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:\=/%"
set "INST_DIR=%SCRIPT_DIR%.."

REM Copy java-bootstrap wrapper to Prism root so JavaPath resolves correctly
for %%I in ("%SCRIPT_DIR%..\..\..") do set "PRISM_ROOT=%%~fI"
if not exist "%PRISM_ROOT%\java-bootstrap.bat" (
    if exist "%INST_DIR%\java-bootstrap.bat" (
        copy "%INST_DIR%\java-bootstrap.bat" "%PRISM_ROOT%\java-bootstrap.bat" >nul 2>&1
    )
)

if not exist "%SCRIPT_DIR%jre25\bin\java.exe" (
    "%SCRIPT_DIR%install-java.bat" || exit /b 1
)
"%SCRIPT_DIR%jre25\bin\java" -jar "%SCRIPT_DIR%packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
if exist "%SCRIPT_DIR%patches" (
    if not exist "%INST_DIR%\patches" mkdir "%INST_DIR%\patches"
    xcopy /E /Y "%SCRIPT_DIR%patches" "%INST_DIR%\patches\"
)

REM Copy updated instance.cfg from packwiz download to instance root
if exist "%SCRIPT_DIR%instance.cfg" (
    copy "%SCRIPT_DIR%instance.cfg" "%INST_DIR%\instance.cfg" /Y >nul 2>&1
    REM Fix paths for Windows
    powershell -Command "(Get-Content '%INST_DIR%\instance.cfg') -replace 'PreLaunchCommand=.*', 'PreLaunchCommand=cmd.exe /c $INST_DIR\minecraft\pre-launch.bat' | Set-Content '%INST_DIR%\instance.cfg'"
    powershell -Command "(Get-Content '%INST_DIR%\instance.cfg') -replace 'JavaPath=\./java-bootstrap', 'JavaPath=.\\java-bootstrap.bat' | Set-Content '%INST_DIR%\instance.cfg'"
)

REM Enable Java override for next launch
findstr "^OverrideJavaLocation=false" "%INST_DIR%\instance.cfg" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    powershell -Command "(Get-Content '%INST_DIR%\instance.cfg') -replace 'OverrideJavaLocation=false', 'OverrideJavaLocation=true' | Set-Content '%INST_DIR%\instance.cfg'"
    powershell -Command "(Get-Content '%INST_DIR%\instance.cfg') -replace 'JavaPath=.*', 'JavaPath=java-bootstrap.bat' | Set-Content '%INST_DIR%\instance.cfg'"
)

REM Set resource packs based on active renderer
set "OPTIONS_FILE=%SCRIPT_DIR%options.txt"
if exist "%SCRIPT_DIR%mods\preview_OptiFine_1.12.2_HD_U_G6_pre1.jar" (
    set RPACKS=["vanilla","file/Fix_Textures_OptiFine.zip","file/Fix_Vintage_Vainilla.zip"]
) else (
    set RPACKS=["vanilla","file/Fix_Vintage_Vainilla.zip"]
)

if not exist "%OPTIONS_FILE%" (
    echo resourcePacks:!RPACKS! > "%OPTIONS_FILE%"
) else (
    findstr /b "resourcePacks:" "%OPTIONS_FILE%" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        powershell -Command "(Get-Content '%OPTIONS_FILE%') -replace '^resourcePacks:.*$', 'resourcePacks:!RPACKS!' | Set-Content '%OPTIONS_FILE%'"
    ) else (
        echo resourcePacks:!RPACKS! >> "%OPTIONS_FILE%"
    )
)
