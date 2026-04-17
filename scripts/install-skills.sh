#!/usr/bin/env bash
# FidgetFlo — install the f* skill family to ~/.claude/skills/
# Usage:
#   ./scripts/install-skills.sh              # install f* alongside any existing r* skills
#   ./scripts/install-skills.sh --purge-r    # install f* AND remove the r* family

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
SKILLS_DST="$HOME/.claude/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "ERROR: expected skills source at $SKILLS_SRC" >&2
  exit 1
fi

mkdir -p "$SKILLS_DST"

echo "Installing FidgetFlo f* skill family to $SKILLS_DST..."
for dir in "$SKILLS_SRC"/*/; do
  name="$(basename "$dir")"
  cp -R "$dir" "$SKILLS_DST/$name"
  echo "  ✓ $name"
done

if [[ "${1:-}" == "--purge-r" ]]; then
  echo ""
  echo "Purging legacy r* skill family..."
  for r in rhive rmini rmini1 rmini2 rmini3 rminimax rswarm rswarm1 rswarm2 rswarm3 rswarmmax; do
    if [[ -d "$SKILLS_DST/$r" ]]; then
      rm -rf "$SKILLS_DST/$r"
      echo "  ✗ $r removed"
    fi
  done
fi

echo ""
echo "Done. Try: /fmini, /fmini1, /fmini2, /fmini3, /fminimax, /fswarm, /fswarm1, /fswarm2, /fswarm3, /fswarmmax, /fhive"
