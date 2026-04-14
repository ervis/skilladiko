#!/bin/bash

# Link agents from .claude/agents to a target directory
# Usage: ./link-agents.sh [target-path]
# Default target: ~/.claude/agents

TARGET_PATH="${1:-$HOME/.claude/agents}"
SOURCE_DIR=".claude/agents"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: $SOURCE_DIR directory not found"
  exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_PATH"

# Count links created
count=0

# For each .md file in source, create symlink in target
for file in "$SOURCE_DIR"/*.md; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target_file="$TARGET_PATH/$filename"

    # Remove existing file/symlink if it exists
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
      rm "$target_file"
    fi

    # Create symlink
    ln -s "$(cd "$SOURCE_DIR" && pwd)/$filename" "$target_file"
    echo "✓ Linked: $filename -> $target_file"
    ((count++))
  fi
done

echo ""
echo "✅ Created $count symlinks in $TARGET_PATH"
