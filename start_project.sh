#!/bin/bash

echo "OACA Agents Management System - Linux/Mac Startup"
echo "=================================================="

# Check Python installation
echo ""
echo "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3.8+ from https://python.org"
    exit 1
fi
echo "Python found!"

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "ERROR: pip3 is not installed"
    echo "Please install pip3"
    exit 1
fi

# Navigate to Django project
cd backend/django_api || {
    echo "ERROR: Could not find backend/django_api directory"
    exit 1
}

# Install Python dependencies
echo ""
echo "Installing/Updating Python dependencies..."
pip3 install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install Python dependencies"
    exit 1
fi

# Run migrations
echo ""
echo "Running Django migrations..."
python3 manage.py migrate
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to run migrations"
    exit 1
fi

# Start Django server
echo ""
echo "Starting Django development server..."
echo ""
echo "Django API will be available at: http://localhost:8000"
echo "Admin panel will be available at: http://localhost:8000/admin"
echo ""
echo "To start the Flutter mobile app:"
echo "1. Open a new terminal"
echo "2. cd agents_mobile_app"
echo "3. flutter pub get"
echo "4. flutter run"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

python3 manage.py runserver
