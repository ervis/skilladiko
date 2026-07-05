#!/bin/bash

# Link skills and agents to a target directory
# Usage: ./link-skills.sh [target-system] [target-path]
# target-system: "claude" (default) or "agents"
# Examples:
#   ./link-skills.sh              # Links to ~/.claude/skills and ~/.claude/agents
#   ./link-skills.sh agents       # Links to ~/.agents/skills and ~/.agents/agents
#   ./link-skills.sh claude /opt/claude-skills  # Custom path

SYSTEM="${1:-claude}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SOURCE_DIR="$REPO_ROOT/skills"
AGENTS_SOURCE_DIR="$REPO_ROOT/agents"

if [ "$SYSTEM" = "agents" ]; then
  SKILLS_TARGET_PATH="${2:-$HOME/.agents/skills}"
  AGENTS_TARGET_PATH="${2:-$HOME/.agents/agents}"
else
  SKILLS_TARGET_PATH="${2:-$HOME/.claude/skills}"
  AGENTS_TARGET_PATH="${2:-./.claude/agents}"  # Use custom path or ~/.claude/agents
  if [ -z "$2" ]; then
    AGENTS_TARGET_PATH="$HOME/.claude/agents"
  else
    AGENTS_TARGET_PATH="${2%/skills}/agents"  # Replace /skills with /agents if custom path
  fi
fi

# Function to link directories
link_directories() {
  local source_dir=$1
  local target_path=$2
  local type_name=$3

  # Check if source directory exists
  if [ ! -d "$source_dir" ]; then
    echo "Error: $source_dir directory not found"
    return 1
  fi

  # Create target directory if it doesn't exist
  mkdir -p "$target_path"

  # Count links created
  local count=0

  # For each subdirectory in source, create symlink in target
  for dir in "$source_dir"/*/; do
    if [ -d "$dir" ]; then
      dirname=$(basename "$dir")
      target_dir="$target_path/$dirname"

      # Remove existing symlink/directory if it exists
      if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
        rm -rf "$target_dir"
      fi

      # Create symlink with absolute path
      ln -s "$(cd "$source_dir" && pwd)/$dirname" "$target_dir"
      echo "✓ Linked $type_name: $dirname -> $target_dir"
      ((count++))
    fi
  done

  echo "✅ Created $count $type_name symlinks in $target_path"
  return 0
}

# Link skills
echo "Linking skills..."
link_directories "$SKILLS_SOURCE_DIR" "$SKILLS_TARGET_PATH" "skill"
skills_result=$?

# Link agents
echo ""
echo "Linking agents..."
link_directories "$AGENTS_SOURCE_DIR" "$AGENTS_TARGET_PATH" "agent"
agents_result=$?

echo ""
if [ $skills_result -eq 0 ] && [ $agents_result -eq 0 ]; then
  echo "✅ All skills and agents linked successfully!"
  exit 0
else
  echo "⚠️ Some links failed"
  exit 1
fi
