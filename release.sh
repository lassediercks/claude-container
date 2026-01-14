#!/bin/bash

# Release script for claude-container
# Creates a new version tag and updates version in files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if version argument is provided
if [ -z "$1" ]; then
    print_error "Version number required"
    echo "Usage: ./release.sh <version>"
    echo "Example: ./release.sh 1.0.0"
    exit 1
fi

VERSION="$1"

# Validate version format (semantic versioning)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Use semantic versioning (e.g., 1.0.0)"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a git repository"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_error "You have uncommitted changes. Please commit or stash them first."
    git status --short
    exit 1
fi

# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    print_error "Tag v$VERSION already exists"
    exit 1
fi

print_info "Creating release v$VERSION"

# Update version in claude-container script
print_info "Updating version in claude-container..."
# Use .bak extension for cross-platform compatibility (macOS requires it)
sed -i.bak "s/^VERSION=\".*\"/VERSION=\"$VERSION\"/" claude-container
rm claude-container.bak

# Show the change
print_info "Version updated:"
grep "^VERSION=" claude-container

# Stage the changes
git add claude-container

# Commit the version bump
print_info "Committing version bump..."
git commit -m "Release v$VERSION"

# Create the git tag
print_info "Creating git tag v$VERSION..."
git tag -a "v$VERSION" -m "Release version $VERSION"

print_success "✓ Release v$VERSION created successfully!"
echo ""
print_info "Next steps:"
echo "  1. Review the changes: git show"
echo "  2. Push the commit: git push origin main"
echo "  3. Push the tag: git push origin v$VERSION"
echo ""
echo "Or push both at once:"
echo "  git push origin main --tags"
