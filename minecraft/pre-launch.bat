@if not exist "%~dp0jre25\bin\java.exe" (
    @"%~dp0install-java.bat" || exit /b 1
)
@"%~dp0jre25\bin\java" -jar "%~dp0packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
@if exist "%~dp0patches" xcopy /E /Y "%~dp0patches" "%~dp0..\patches\"
