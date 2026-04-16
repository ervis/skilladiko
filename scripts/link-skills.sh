#!/bin/bash

# Link skills to a target directory
# Usage: ./link-skills.sh [target-system] [target-path]
# target-system: "claude" (default) or "agents"
# Examples:
#   ./link-skills.sh              # Links to ~/.claude/skills
#   ./link-skills.sh agents       # Links to ~/.agents/skills
#   ./link-skills.sh claude /opt/claude-skills  # Custom path

SYSTEM="${1:-claude}"
SOURCE_DIR=".agents/skills"

if [ "$SYSTEM" = "agents" ]; then
  TARGET_PATH="${2:-$HOME/.agents/skills}"
else
  TARGET_PATH="${2:-$HOME/.claude/skills}"
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: $SOURCE_DIR directory not found"
  exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_PATH"

# Count links created
count=0

# For each subdirectory in source, create symlink in target
for dir in "$SOURCE_DIR"/*/; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")
    target_dir="$TARGET_PATH/$dirname"

    # Remove existing symlink/directory if it exists
    if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
      rm -rf "$target_dir"
    fi

    # Create symlink with absolute path
    ln -s "$(cd "$SOURCE_DIR" && pwd)/$dirname" "$target_dir"
    echo "✓ Linked: $dirname -> $target_dir"
    ((count++))
  fi
done

echo ""
echo "✅ Created symlinks in $TARGET_PATH"
