#!/usr/bin/env bash
#
# agent-office bootstrap
#
#   ./init.sh <target-dir> ["Project Name"]   install the agent scheme into a project
#   ./init.sh --update <target-dir>           refresh the shared parts only
#
# Two classes of file:
#
#   SHARED  (.claude/agents/, .claude/skills/, .claude/spec_template.md)
#           owned by this repo. --update overwrites them.
#
#   PROJECT (CLAUDE.md, .claude/phases.md, .claude/decisions.md)
#           owned by the project. Written once at init, never touched by --update.
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO/template"

SHARED=(".claude/agents" ".claude/skills" ".claude/spec_template.md")
PROJECT=("CLAUDE.md" ".claude/phases.md" ".claude/decisions.md")

die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '  %s\n' "$*"; }

usage() {
  sed -n '3,9p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 1
}

# Replace {{PROJECT_NAME}} / {{DATE}} in-place, safe for arbitrary text.
substitute() {
  local file="$1" tmp
  [ -f "$file" ] || return 0
  tmp="$(mktemp)"
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line//\{\{PROJECT_NAME\}\}/$PROJECT_NAME}"
    line="${line//\{\{DATE\}\}/$TODAY}"
    printf '%s\n' "$line"
  done < "$file" > "$tmp"
  mv "$tmp" "$file"
}

copy_shared() {
  local dest="$1"
  for path in "${SHARED[@]}"; do
    mkdir -p "$dest/$(dirname "$path")"
    rm -rf "${dest:?}/$path"
    cp -R "$SRC/$path" "$dest/$path"
    info "$path"
  done
}

[ $# -ge 1 ] || usage
[ -d "$SRC" ] || die "template/ not found — run this script from inside the agent-office repo"

# ---------------------------------------------------------------- update mode
if [ "$1" = "--update" ] || [ "$1" = "-u" ]; then
  [ $# -eq 2 ] || usage
  DEST="$(cd "$2" 2>/dev/null && pwd)" || die "no such directory: $2"
  [ -d "$DEST/.claude/agents" ] || die "$DEST is not an agent-office project (no .claude/agents). Run init first."

  echo "Updating shared agent scheme in $DEST"
  copy_shared "$DEST"
  echo
  echo "Done. Project-owned files were left untouched:"
  for path in "${PROJECT[@]}"; do info "$path"; done
  exit 0
fi

# ------------------------------------------------------------------ init mode
[ $# -le 2 ] || usage
mkdir -p "$1"
DEST="$(cd "$1" && pwd)"
PROJECT_NAME="${2:-$(basename "$DEST")}"
TODAY="$(date +%Y-%m-%d)"

[ -e "$DEST/CLAUDE.md" ] && die "$DEST/CLAUDE.md already exists — use --update to refresh the shared parts"

echo "Installing agent-office into $DEST"
echo "Project name: $PROJECT_NAME"
echo

copy_shared "$DEST"

for path in "${PROJECT[@]}"; do
  mkdir -p "$DEST/$(dirname "$path")"
  cp "$SRC/$path" "$DEST/$path"
  substitute "$DEST/$path"
  info "$path"
done

mkdir -p "$DEST/specs"
info "specs/"

cat <<EOF

Done. Next:

  cd "$DEST"
  claude

  1. Fill in the TODOs in CLAUDE.md (concept, stack, run commands)
  2. Write the roadmap into .claude/phases.md
  3. "Use the ba-agent to write the spec for Phase 1"

To pull newer agent definitions later:  $REPO/init.sh --update "$DEST"
EOF
