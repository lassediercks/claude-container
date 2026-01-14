#!/bin/bash

set -e

IMAGE_NAME="claude-container:latest"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="claude-container"

echo "========================================"
echo "Claude Container Utility Installer"
echo "========================================"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not accessible"
    echo "Please start Docker and try again."
    exit 1
fi

# Check if the docker image exists
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Docker image '$IMAGE_NAME' not found."
    echo ""
    read -p "Would you like to build it now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Building Docker image..."
        docker build -f "$SCRIPT_DIR/Dockerfile.utility" -t "$IMAGE_NAME" "$SCRIPT_DIR"
        echo "Image built successfully!"
        echo ""
    else
        echo "Please build the image manually with:"
        echo "  docker build -f Dockerfile.utility -t $IMAGE_NAME ."
        exit 1
    fi
fi

# Check if script exists
if [ ! -f "$SCRIPT_DIR/$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found in $SCRIPT_DIR"
    exit 1
fi

echo "Choose installation type:"
echo "  1) System-wide (requires sudo) - installs to /usr/local/bin"
echo "  2) User-local (no sudo) - installs to ~/bin"
echo ""
read -p "Enter choice (1 or 2): " -n 1 -r
echo ""

case $REPLY in
    1)
        # System-wide installation
        TARGET_DIR="/usr/local/bin"
        TARGET_PATH="$TARGET_DIR/$SCRIPT_NAME"
        
        echo "Installing to $TARGET_PATH (requires sudo)..."
        sudo cp "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_PATH"
        sudo chmod +x "$TARGET_PATH"
        
        echo "✓ Installed successfully to $TARGET_PATH"
        echo ""
        echo "You can now run 'claude-container' from any directory."
        ;;
    2)
        # User-local installation
        TARGET_DIR="$HOME/bin"
        TARGET_PATH="$TARGET_DIR/$SCRIPT_NAME"
        
        # Create bin directory if it doesn't exist
        if [ ! -d "$TARGET_DIR" ]; then
            echo "Creating $TARGET_DIR..."
            mkdir -p "$TARGET_DIR"
        fi
        
        echo "Installing to $TARGET_PATH..."
        cp "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_PATH"
        chmod +x "$TARGET_PATH"
        
        echo "✓ Installed successfully to $TARGET_PATH"
        echo ""
        
        # Check if ~/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            echo "⚠ Warning: $TARGET_DIR is not in your PATH"
            echo ""
            echo "Add this line to your shell config file (~/.bashrc, ~/.zshrc, or ~/.profile):"
            echo ""
            echo "  export PATH=\"\$HOME/bin:\$PATH\""
            echo ""
            echo "Then reload your shell:"
            echo "  source ~/.bashrc  # or ~/.zshrc or ~/.profile"
        else
            echo "You can now run 'claude-container' from any directory."
        fi
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "Installation complete!"
