@echo off
setlocal

:: --- [CONFIGURATION] ---
set "BC_SCRIPT=D:\99.PATH\gen_report.txt"
set "BC_EXE=C:\Program Files\Beyond Compare 4\BComp.com"

:: --- [PRE-CHECK: Validate Environment] ---
echo [DEBUG] Checking environment...

:: 1. Check if Target SHA is provided
if "%~1"=="" (
    echo [ERROR] Parameter 1 [Target SHA] is missing.
    echo Please check SourceTree Custom Action settings.
    pause
    exit /b 1
)

:: 2. Check if BC4 Script exists
if not exist "%BC_SCRIPT%" (
    echo [ERROR] Script file not found at:
    echo %BC_SCRIPT%
    pause
    exit /b 1
)

:: 3. Check if Beyond Compare is installed
if not exist "%BC_EXE%" (
    echo [ERROR] Beyond Compare 4 executable not found at:
    echo %BC_EXE%
    pause
    exit /b 1
)

:: --- [SETUP VARIABLES] ---
set "TARGET_SHA=%~1"
set "BASE_BRANCH=%~2"

set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
set TIMESTAMP=%TIMESTAMP: =0%
set "REPORT_DIR=%USERPROFILE%\Desktop\DiffReport_%TIMESTAMP%"
set "REPORT_INDEX=%REPORT_DIR%\index.html"
set "REPORT_LOG=%REPORT_DIR%\bc_log.txt"

set "TEMP_A=%cd%\.bc_temp_target"
set "TEMP_B=%cd%\.bc_temp_base"

echo.
echo ========================================================
echo  Generating HTML Diff Report
echo  Script: %BC_SCRIPT%
echo ========================================================
echo.

echo [STEP 1] Creating output directory...
mkdir "%REPORT_DIR%"
echo Output: %REPORT_DIR%

echo [STEP 2] Cleaning up worktrees...
git worktree prune
if exist "%TEMP_A%" git worktree remove --force "%TEMP_A%" >nul 2>&1
if exist "%TEMP_B%" git worktree remove --force "%TEMP_B%" >nul 2>&1

echo [STEP 3] Checking out source code...
:: A = Target (Right), B = Base (Left)
echo Checking out Target [%TARGET_SHA%]...
git worktree add --detach "%TEMP_A%" %TARGET_SHA% || goto :ERROR
echo Checking out Base [%BASE_BRANCH%]...
git worktree add --detach "%TEMP_B%" %BASE_BRANCH% || goto :ERROR

echo [STEP 4] Running Beyond Compare...
echo [WAIT] Processing diff report...

"%BC_EXE%" @"%BC_SCRIPT%" "%TEMP_B%" "%TEMP_A%" "%REPORT_INDEX%" /log="%REPORT_LOG%"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Beyond Compare failed. Check log: %REPORT_LOG%
    type "%REPORT_LOG%"
    goto :ERROR
)

echo [STEP 5] Cleanup...
git worktree remove --force "%TEMP_A%" >nul 2>&1
git worktree remove --force "%TEMP_B%" >nul 2>&1
git worktree prune

echo.
echo ========================================================
echo  SUCCESS!
echo  Open folder: %REPORT_DIR%
echo ========================================================
echo.
pause
exit /b 0

:ERROR
echo.
echo [FATAL ERROR] Process failed. See messages above.
pause
exit /b 1