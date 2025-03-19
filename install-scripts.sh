#!/bin/bash

set -e  # Exit immediately if any command fails

# Check if GitHub token is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <github-token>"
    exit 1
fi

GITHUB_TOKEN="$1"
PRIVATE_REPO_URL="https://${GITHUB_TOKEN}@github.com/MeRezaRezaei/scripts.git"
TEMP_DIR=$(mktemp -d)

# Clean up temporary directory on script exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# Clone the private repository (master branch, depth 1 to minimize data)
echo "Cloning private repository..."
git clone --quiet --branch master --depth 1 "$PRIVATE_REPO_URL" "$TEMP_DIR"

# Path to the target script in the private repository
TARGET_SCRIPT="$TEMP_DIR/linux/script-service/install-script-service.sh"

# Verify the script exists
if [ ! -f "$TARGET_SCRIPT" ]; then
    echo "Error: Install script not found in the private repository."
    exit 1
fi

# Make the script executable and run it
chmod +x "$TARGET_SCRIPT"
echo "Starting installation script from private repository..."
"$TARGET_SCRIPT"