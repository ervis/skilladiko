#!/bin/bash

# Link commands from .claude/commands to a target directory
# Usage: ./link-commands.sh [target-path]
# Default target: ~/.claude/commands

TARGET_PATH="${1:-$HOME/.claude/commands}"
SOURCE_DIR="skills"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: $SOURCE_DIR directory not found"
  exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_PATH"

# Count links created
count=0

# For each .md file in source (including subdirectories), create symlink in target
find "$SOURCE_DIR" -maxdepth 1 -name "*.md" -type f | while read -r file; do
  filename=$(basename "$file")
  target_file="$TARGET_PATH/$filename"

  # Remove existing file/symlink if it exists
  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    rm "$target_file"
  fi

  # Create symlink with absolute path
  ln -s "$(cd "$SOURCE_DIR" && pwd)/$filename" "$target_file"
  echo "✓ Linked: $filename -> $target_file"
  ((count++))
done

echo ""
echo "✅ Created symlinks in $TARGET_PATH"
