@echo off
echo OACA Agents Management System - Windows Startup
echo ================================================

echo.
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
)
echo Python found!

echo.
echo Installing/Updating Python dependencies...
cd backend\django_api
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)

echo.
echo Running Django migrations...
python manage.py migrate
if errorlevel 1 (
    echo ERROR: Failed to run migrations
    pause
    exit /b 1
)

echo.
echo Starting Django development server...
echo.
echo Django API will be available at: http://localhost:8000
echo Admin panel will be available at: http://localhost:8000/admin
echo.
echo To start the Flutter mobile app:
echo 1. Open a new terminal
echo 2. cd agents_mobile_app
echo 3. flutter pub get
echo 4. flutter run
echo.
echo Press Ctrl+C to stop the server
echo.

python manage.py runserver
