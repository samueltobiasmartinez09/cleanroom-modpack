@"%INST_JAVA%" -jar "%INST_DIR%\minecraft\packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
@copy /Y "%INST_DIR%\minecraft\mmc-pack.json" "%INST_DIR%\mmc-pack.json"
