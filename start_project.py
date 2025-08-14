#!/usr/bin/env python3
"""
Startup script for the OACA Agents Management System
"""
import os
import sys
import subprocess
import time

def run_command(command, cwd=None):
    """Run a command and return success status"""
    try:
        result = subprocess.run(command, shell=True, cwd=cwd, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {command}")
        print(f"Error: {e}")
        return False

def check_requirements():
    """Check if required software is installed"""
    print("Checking requirements...")
    
    # Check Python
    try:
        import sys
        python_version = sys.version_info
        if python_version.major >= 3 and python_version.minor >= 8:
            print(f"✓ Python {python_version.major}.{python_version.minor} found")
        else:
            print("✗ Python 3.8+ required")
            return False
    except:
        print("✗ Python not found")
        return False
    
    # Check Django
    try:
        import django
        print(f"✓ Django {django.get_version()} found")
    except ImportError:
        print("✗ Django not found. Installing...")
        if not run_command("pip install django"):
            return False
    
    # Check other requirements
    required_packages = [
        'djangorestframework',
        'django-cors-headers',
        'psycopg2-binary',
        'openpyxl',
        'pandas'
    ]
    
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
            print(f"✓ {package} found")
        except ImportError:
            print(f"✗ {package} not found. Installing...")
            if not run_command(f"pip install {package}"):
                print(f"Failed to install {package}")
    
    return True

def setup_django():
    """Setup Django backend"""
    print("\nSetting up Django backend...")
    
    django_dir = "backend/django_api"
    if not os.path.exists(django_dir):
        print(f"✗ Django directory not found: {django_dir}")
        return False
    
    # Install requirements
    requirements_file = os.path.join(django_dir, "requirements.txt")
    if os.path.exists(requirements_file):
        print("Installing Python requirements...")
        if not run_command(f"pip install -r {requirements_file}"):
            print("Failed to install requirements")
            return False
    
    # Run migrations
    print("Running Django migrations...")
    if not run_command("python manage.py migrate", cwd=django_dir):
        print("Failed to run migrations")
        return False
    
    print("✓ Django setup complete")
    return True

def start_django():
    """Start Django development server"""
    print("\nStarting Django development server...")
    django_dir = "backend/django_api"
    
    try:
        # Start Django server in background
        process = subprocess.Popen(
            ["python", "manage.py", "runserver"],
            cwd=django_dir,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        # Wait a moment for server to start
        time.sleep(3)
        
        # Check if server is running
        if process.poll() is None:
            print("✓ Django server started at http://localhost:8000")
            return process
        else:
            print("✗ Failed to start Django server")
            return None
    except Exception as e:
        print(f"✗ Error starting Django server: {e}")
        return None

def setup_flutter():
    """Setup Flutter mobile app"""
    print("\nSetting up Flutter mobile app...")
    
    flutter_dir = "agents_mobile_app"
    if not os.path.exists(flutter_dir):
        print(f"✗ Flutter directory not found: {flutter_dir}")
        return False
    
    # Check if Flutter is installed
    try:
        result = subprocess.run(["flutter", "--version"], capture_output=True, text=True)
        if result.returncode == 0:
            print("✓ Flutter found")
        else:
            print("✗ Flutter not found. Please install Flutter first.")
            return False
    except FileNotFoundError:
        print("✗ Flutter not found. Please install Flutter first.")
        return False
    
    # Get Flutter dependencies
    print("Getting Flutter dependencies...")
    if not run_command("flutter pub get", cwd=flutter_dir):
        print("Failed to get Flutter dependencies")
        return False
    
    print("✓ Flutter setup complete")
    return True

def main():
    """Main startup function"""
    print("OACA Agents Management System - Startup Script")
    print("=" * 50)
    
    # Check requirements
    if not check_requirements():
        print("\n✗ Requirements check failed")
        sys.exit(1)
    
    # Setup Django
    if not setup_django():
        print("\n✗ Django setup failed")
        sys.exit(1)
    
    # Start Django server
    django_process = start_django()
    if not django_process:
        print("\n✗ Failed to start Django server")
        sys.exit(1)
    
    # Setup Flutter
    if not setup_flutter():
        print("\n✗ Flutter setup failed")
        django_process.terminate()
        sys.exit(1)
    
    print("\n" + "=" * 50)
    print("✓ Setup complete!")
    print("\nServices running:")
    print("- Django API: http://localhost:8000")
    print("- Admin panel: http://localhost:8000/admin")
    print("\nTo start the Flutter app:")
    print("cd agents_mobile_app && flutter run")
    print("\nPress Ctrl+C to stop the Django server")
    
    try:
        # Keep the script running
        django_process.wait()
    except KeyboardInterrupt:
        print("\nShutting down...")
        django_process.terminate()
        django_process.wait()
        print("✓ Django server stopped")

if __name__ == "__main__":
    main()
