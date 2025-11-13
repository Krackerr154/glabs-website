@echo off
REM G-Labs Website Deployment for Windows
REM This batch file runs the PowerShell deployment script

echo ========================================
echo G-Labs Website Deployment
echo ========================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo Please install PowerShell to use this script.
    pause
    exit /b 1
)

REM Check if environment variables are set
if "%DEPLOY_HOST%"=="" (
    echo ERROR: DEPLOY_HOST environment variable not set!
    echo.
    echo Please set it first:
    echo   set DEPLOY_HOST=your.vps.ip
    echo   set DEPLOY_USER=your-username
    echo   deploy.bat
    echo.
    pause
    exit /b 1
)

REM Run PowerShell script
echo Running deployment...
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0deploy.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Deployment completed successfully!
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Deployment failed!
    echo ========================================
)

pause
