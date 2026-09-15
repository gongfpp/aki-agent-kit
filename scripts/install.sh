#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AKI_AGENT_KIT_REPO:-https://github.com/gongfpp/aki-agent-kit.git}"
REF="${AKI_AGENT_KIT_REF:-main}"
DEST_DIR="${AKI_SKILLS_DIR:-$HOME/.agents/skills}"

if ! command -v git >/dev/null 2>&1; then
  echo "error: git is required" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/aki-agent-kit.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

git clone --quiet --depth 1 --branch "$REF" "$REPO_URL" "$tmp_dir/repo"

installed=0
for src in "$tmp_dir"/repo/skills/*; do
  [ -d "$src" ] || continue
  [ -f "$src/SKILL.md" ] || continue

  name="$(basename "$src")"
  dest="$DEST_DIR/$name"
  marker="$dest/.aki-agent-kit-managed"

  if [ -e "$dest" ] && [ ! -f "$marker" ]; then
    echo "error: refusing to overwrite unmanaged skill: $dest" >&2
    exit 1
  fi

  stage="$DEST_DIR/.${name}.tmp.$$"
  rm -rf "$stage"
  mkdir -p "$stage"
  cp -R "$src"/. "$stage"/
  printf '%s\n' "managed-by=aki-agent-kit" "source=$REPO_URL" "ref=$REF" > "$stage/.aki-agent-kit-managed"

  rm -rf "$dest"
  mv "$stage" "$dest"
  installed=$((installed + 1))
done

for dest in "$DEST_DIR"/aki-*; do
  [ -d "$dest" ] || continue
  [ -f "$dest/.aki-agent-kit-managed" ] || continue
  name="$(basename "$dest")"
  if [ ! -d "$tmp_dir/repo/skills/$name" ]; then
    rm -rf "$dest"
  fi
done

echo "installed $installed skill(s) into $DEST_DIR"
echo "rerun this command later to update them from $REF"
