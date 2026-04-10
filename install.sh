#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DEST="$HOME/.claude/skills/multi-agent"
SCRIPTS_DEST="$HOME/.claude/scripts/multi-agent"
SETTINGS="$HOME/.claude/settings.json"
ALLOW_ENTRY="Bash(~/.claude/scripts/multi-agent/*)"

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

# 3. Add allow entry to ~/.claude/settings.json if not already present
if [ ! -f "$SETTINGS" ]; then
    echo '{"permissions":{"allow":[]}}' > "$SETTINGS"
fi

already_present=$(jq --arg entry "$ALLOW_ENTRY" \
    '(.permissions.allow // []) | map(select(. == $entry)) | length' \
    "$SETTINGS")

if [ "$already_present" -gt 0 ]; then
    echo "[skip] '$ALLOW_ENTRY' already in $SETTINGS"
else
    tmp=$(mktemp)
    jq --arg entry "$ALLOW_ENTRY" \
        '.permissions.allow = ((.permissions.allow // []) + [$entry])' \
        "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    echo "[ok] Added '$ALLOW_ENTRY' to $SETTINGS"
fi

echo ""
echo "Installation complete."
echo "  Skill:   $SKILL_DEST/SKILL.md"
echo "  Scripts: $SCRIPTS_DEST/"
echo "  Allowed: $ALLOW_ENTRY"
