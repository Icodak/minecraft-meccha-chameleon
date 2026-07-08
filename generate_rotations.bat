@echo off
REM generate_rotations.bat
REM
REM Runs rotate_poses.py on every .mcfunction file directly inside
REM   datapacks\meccha-cameleon\data\meccha\function\rig\poses\
REM and writes the north/east/south/west variants into
REM   datapacks\meccha-cameleon\data\meccha\function\rig\poses\generated_rotations\
REM
REM Run this from the repo root (the folder that contains "datapacks"),
REM or pass the repo root as the first argument:
REM     generate_rotations.bat "C:\path\to\repo"
REM
REM Expects rotate_poses.py to sit next to this .bat file. Requires
REM "python" to be on PATH (adjust PYTHON below if you use "py" instead).

setlocal enabledelayedexpansion

set "PYTHON=python"
set "SCRIPT=%~dp0\tools\rotate_poses.py"

if not "%~1"=="" (
    set "ROOT=%~1"
) else (
    set "ROOT=."
)

set "SRC_DIR=%ROOT%\datapacks\meccha-cameleon\data\meccha\function\rig\poses"
set "OUT_DIR=%SRC_DIR%\generated_rotations"

if not exist "%SCRIPT%" (
    echo ERROR: could not find rotate_poses.py next to this .bat file ^(%SCRIPT%^)
    exit /b 1
)

if not exist "%SRC_DIR%" (
    echo ERROR: source folder not found: %SRC_DIR%
    exit /b 1
)

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

set "COUNT=0"
for %%F in ("%SRC_DIR%\*.mcfunction") do (
    echo Processing %%~nxF ...
    %PYTHON% "%SCRIPT%" "%%F" -o "%OUT_DIR%"
    if errorlevel 1 (
        echo ERROR processing %%~nxF
        exit /b 1
    )
    set /a COUNT+=1
)

if "%COUNT%"=="0" (
    echo No .mcfunction files found in %SRC_DIR%
) else (
    echo Done. Processed %COUNT% file^(s^). Output in %OUT_DIR%
)

endlocal