@echo off
set "DIR=%~dp0"
set "JRE_DIR=%DIR%jre25"
if exist "%JRE_DIR%\bin\java.exe" exit /b 0

echo Downloading Zulu JRE 25...
powershell -ExecutionPolicy Bypass -Command "try { $ErrorActionPreference='Stop'; $api='https://api.azul.com/metadata/v1/zulu/packages/?java_version=25&os=windows&arch=x64&java_package_type=jre&javafx_bundled=false&release_status=ga&availability_types=CA&latest=true'; $url=(Invoke-RestMethod $api | Where-Object { $_.download_url -like '*.zip' } | Select-Object -First 1).download_url; if (!$url) { throw 'No download URL found from Azul API' }; $zip=\"$env:TEMP\jre25.zip\"; Invoke-WebRequest $url -OutFile $zip; $extract=\"$env:TEMP\jre25_extract\"; Remove-Item $extract -Recurse -Force -ErrorAction 0; Expand-Archive $zip -DestinationPath $extract; $sub=Get-ChildItem $extract -Directory | Select-Object -First 1; New-Item '%DIR%jre25' -ItemType Directory -Force -ErrorAction 0; if ($sub) { Get-ChildItem $sub.FullName | Move-Item -Destination '%DIR%jre25' -Force }; Remove-Item $zip -Force -ErrorAction 0; Remove-Item $extract -Recurse -Force -ErrorAction 0; if (!(Test-Path '%DIR%jre25\bin\java.exe')) { throw 'JRE not found after extraction' }; Write-Host 'JRE installed' } catch { Write-Host \"Error: $_\"; exit 1 }"
if %errorlevel% neq 0 exit /b %errorlevel%
