#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DEST="$HOME/.claude/skills/multi-agent"
SCRIPTS_DEST="$HOME/.claude/scripts/multi-agent"

echo "Installing multi-agent skill..."
echo ""

# 1. Copy SKILL.md
mkdir -p "$SKILL_DEST"
cp "$REPO_DIR/SKILL.md" "$SKILL_DEST/SKILL.md"
echo "[ok] SKILL.md -> $SKILL_DEST/SKILL.md"

# 2. Copy scripts/ and make executable
mkdir -p "$SCRIPTS_DEST"
for file in "$REPO_DIR/scripts/"*; do
    name="$(basename "$file")"
    cp "$file" "$SCRIPTS_DEST/$name"
    chmod +x "$SCRIPTS_DEST/$name"
    echo "[ok] scripts/$name -> $SCRIPTS_DEST/$name (executable)"
done

echo ""
echo "Installation complete."
echo "  Skill:   $SKILL_DEST/SKILL.md"
echo "  Scripts: $SCRIPTS_DEST/"
echo ""
echo "Hooks and permissions are installed automatically the first time you run /multi-agent."
