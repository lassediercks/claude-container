#!/bin/bash

set -e

IMAGE_NAME="claude-container:latest"
SCRIPT_NAME="claude-container"

echo "========================================"
echo "Claude Container Utility Uninstaller"
echo "========================================"
echo ""

# Check for system-wide installation
SYSTEM_PATH="/usr/local/bin/$SCRIPT_NAME"
USER_PATH="$HOME/bin/$SCRIPT_NAME"

FOUND_SYSTEM=false
FOUND_USER=false

if [ -f "$SYSTEM_PATH" ]; then
    FOUND_SYSTEM=true
fi

if [ -f "$USER_PATH" ]; then
    FOUND_USER=true
fi

if [ "$FOUND_SYSTEM" = false ] && [ "$FOUND_USER" = false ]; then
    echo "No installation found."
    echo ""
else
    echo "Found installations:"
    [ "$FOUND_SYSTEM" = true ] && echo "  - System-wide: $SYSTEM_PATH"
    [ "$FOUND_USER" = true ] && echo "  - User-local: $USER_PATH"
    echo ""
    
    read -p "Remove the script(s)? (y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$FOUND_SYSTEM" = true ]; then
            echo "Removing $SYSTEM_PATH (requires sudo)..."
            sudo rm "$SYSTEM_PATH"
            echo "✓ Removed system-wide installation"
        fi
        
        if [ "$FOUND_USER" = true ]; then
            echo "Removing $USER_PATH..."
            rm "$USER_PATH"
            echo "✓ Removed user-local installation"
        fi
        echo ""
    fi
fi

# Ask about Docker image
if docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Docker image '$IMAGE_NAME' is installed."
    read -p "Remove the Docker image? (y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing Docker image..."
        docker rmi "$IMAGE_NAME"
        echo "✓ Removed Docker image"
    fi
fi

echo ""
echo "Uninstallation complete!"
