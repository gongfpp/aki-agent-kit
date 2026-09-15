#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AKI_AGENT_KIT_REPO:-https://github.com/gongfpp/aki-agent-kit.git}"
REF="${AKI_AGENT_KIT_REF:-main}"
DEST_DIR="${AKI_SKILLS_DIR:-$HOME/.agents/skills}"

if ! command -v git >/dev/null 2>&1; then
  echo "错误 / Error: 需要先安装 Git / Git is required." >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/aki-agent-kit.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

echo "aki-agent-kit Skill 安装器 / Skill Installer"
echo "源 / Source: $REPO_URL"
echo "版本 / Ref: $REF"
echo "目标目录 / Destination: $DEST_DIR"
echo

if ! git clone --quiet --depth 1 --branch "$REF" "$REPO_URL" "$tmp_dir/repo"; then
  echo "错误 / Error: 无法读取仓库 / Failed to fetch the repository." >&2
  exit 1
fi

installed=0
updated=0
removed=0

for src in "$tmp_dir"/repo/skills/*; do
  [ -d "$src" ] || continue
  [ -f "$src/SKILL.md" ] || continue

  name="$(basename "$src")"
  dest="$DEST_DIR/$name"
  marker="$dest/.aki-agent-kit-managed"

  if [ -e "$dest" ] && [ ! -f "$marker" ]; then
    echo "错误 / Error: 拒绝覆盖非本安装器管理的 Skill / Refusing to overwrite unmanaged Skill: $dest" >&2
    exit 1
  fi

  if [ -f "$marker" ]; then
    echo "更新 / Updating: $name"
    updated=$((updated + 1))
  else
    echo "安装 / Installing: $name"
    installed=$((installed + 1))
  fi

  stage="$DEST_DIR/.${name}.tmp.$$"
  rm -rf "$stage"
  mkdir -p "$stage"
  cp -R "$src"/. "$stage"/
  printf '%s\n' "managed-by=aki-agent-kit" "source=$REPO_URL" "ref=$REF" > "$stage/.aki-agent-kit-managed"

  rm -rf "$dest"
  mv "$stage" "$dest"
done

for dest in "$DEST_DIR"/aki-*; do
  [ -d "$dest" ] || continue
  [ -f "$dest/.aki-agent-kit-managed" ] || continue
  name="$(basename "$dest")"
  if [ ! -d "$tmp_dir/repo/skills/$name" ]; then
    echo "清理 / Removing: $name"
    rm -rf "$dest"
    removed=$((removed + 1))
  fi
done

echo
echo "安装完成 / Installation complete"
echo "新安装 / Installed: $installed"
echo "已更新 / Updated: $updated"
echo "已清理 / Removed: $removed"
echo "安装目录 / Directory: $DEST_DIR"
echo
echo "Skill 使用方法 / Skill usage"
echo
echo "1. aki-project-bootstrap"
echo '   中文：使用 `aki-project-bootstrap` 初始化当前项目。'
echo '   English: Use `aki-project-bootstrap` to initialize the current project.'
echo
echo "2. aki-context-sync"
echo '   中文：使用 `aki-context-sync` 收敛当前会话上下文。'
echo '   English: Use `aki-context-sync` to consolidate the current session context.'
echo
echo "3. aki-github-readme"
echo '   中文：使用 `aki-github-readme` 审查并完善当前项目 README。'
echo '   English: Use `aki-github-readme` to review and improve the current project README.'
echo
echo "4. aki-rednote-cover"
echo '   中文：使用 `aki-rednote-cover` 为当前内容生成封面。'
echo '   English: Use `aki-rednote-cover` to generate covers for the current content.'
echo
echo "提示 / Tip: 如果当前 Agent 会话没有发现新安装的 Skill，请新建会话或重启 Agent。"
echo "Tip: If the current Agent session does not discover the newly installed Skills, start a new session or restart the Agent."
echo
echo "更新 / Update: 以后重复运行同一条安装命令即可更新这些 Skill。"
echo "Update: Rerun the same install command later to update these Skills."
