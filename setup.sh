#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code settings..."

# Ensure ~/.claude directory exists
mkdir -p "$CLAUDE_DIR"

# Link skills
if [ -d "$SCRIPT_DIR/skills" ]; then
  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$CLAUDE_DIR/skills/$skill_name"

    if [ -L "$target" ]; then
      echo "  Updating symlink: skills/$skill_name"
      rm "$target"
    elif [ -d "$target" ]; then
      echo "  Skipping skills/$skill_name (directory already exists, not a symlink)"
      continue
    else
      echo "  Linking: skills/$skill_name"
    fi

    mkdir -p "$CLAUDE_DIR/skills"
    ln -s "$skill_dir" "$target"
  done
fi

echo "Done."
