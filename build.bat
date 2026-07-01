@echo off
setlocal

REM Regenerate all precomputed datapack data from source assets + rig spec.

if "%PYTHON%"=="" (
    set PY=python
) else (
    set PY=%PYTHON%
)

if "%~1"=="" (
    set ASSETS=tools\sample_assets\assets
) else (
    set ASSETS=%~1
)

echo ==> Asset pipeline (Pillar 2)
%PY% tools\parse_assets.py --assets "%ASSETS%" --datapack ".\datapacks\meccha-cameleon"
if errorlevel 1 exit /b %errorlevel%

echo ==> Rig generator (Pillar 5)
%PY% tools\build_rig.py --datapack ".\datapacks\meccha-cameleon" --scale 0.3333333
if errorlevel 1 exit /b %errorlevel%

echo ==> Colour-picker dialog
%PY% tools\build_dialog.py --datapack ".\datapacks\meccha-cameleon"
if errorlevel 1 exit /b %errorlevel%

echo ==> Validate
%PY% tools\validate_pack.py
if errorlevel 1 exit /b %errorlevel%

echo.
echo Done!