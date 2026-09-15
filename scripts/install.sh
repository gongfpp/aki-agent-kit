#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AKI_AGENT_KIT_REPO:-https://github.com/gongfpp/aki-agent-kit.git}"
REF="${AKI_AGENT_KIT_REF:-main}"
DEST_DIR="${AKI_SKILLS_DIR:-$HOME/.agents/skills}"
REQUESTED_SET="${AKI_SKILL_SET:-}"
REQUESTED_SKILLS="${AKI_SKILLS:-}"
LIST_ONLY=0

usage() {
  cat <<'TXT'
aki-agent-kit Skill 安装器 / Skill Installer

用法 / Usage:
  install.sh                         安装 project 集合（默认） / Install the project preset (default)
  install.sh --set core              安装 core 集合 / Install the core preset
  install.sh --set project           安装 project 集合 / Install the project preset
  install.sh --set game              安装 game 集合 / Install the game preset
  install.sh --set opensource        安装 opensource 集合 / Install the open-source preset
  install.sh --set all               安装全部 Skill / Install all Skills
  install.sh --skills a,b,c          指定最终受管 Skill 集合 / Set the exact managed Skill set
  install.sh --list                  查看预设与可用 Skill / List presets and available Skills
  install.sh --help                  显示帮助 / Show help

环境变量 / Environment:
  AKI_SKILLS_DIR       安装目录，默认 ~/.agents/skills / Destination directory
  AKI_SKILL_SET        等价于 --set / Same as --set
  AKI_SKILLS           等价于 --skills / Same as --skills
  AKI_AGENT_KIT_REPO   源仓库 / Source repository
  AKI_AGENT_KIT_REF    Git ref，默认 main / Git ref, default main
TXT
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --set)
      [ "$#" -ge 2 ] || { echo "错误 / Error: --set 需要参数 / requires a value." >&2; exit 1; }
      REQUESTED_SET="$2"
      shift 2
      ;;
    --skills)
      [ "$#" -ge 2 ] || { echo "错误 / Error: --skills 需要参数 / requires a value." >&2; exit 1; }
      REQUESTED_SKILLS="$2"
      shift 2
      ;;
    --list)
      LIST_ONLY=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "错误 / Error: 未知参数 / Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -n "$REQUESTED_SET" ] && [ -n "$REQUESTED_SKILLS" ]; then
  echo "错误 / Error: --set 与 --skills 不能同时使用 / cannot be used together." >&2
  exit 1
fi

if [ -z "$REQUESTED_SET" ] && [ -z "$REQUESTED_SKILLS" ]; then
  REQUESTED_SET="project"
fi

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

AVAILABLE_SKILLS=()
for src in "$tmp_dir"/repo/skills/*; do
  [ -d "$src" ] || continue
  [ -f "$src/SKILL.md" ] || continue
  AVAILABLE_SKILLS+=("$(basename "$src")")
done

contains() {
  needle="$1"
  shift
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

skill_summary() {
  case "$1" in
    aki-project-bootstrap) echo "项目接入与 AGENTS.md 初始化 / Project bootstrap and AGENTS.md setup" ;;
    aki-context-sync) echo "会话上下文持久化与文档收敛 / Session context consolidation" ;;
    aki-project-readme) echo "项目 README 生成、审查与维护 / Project README generation and review" ;;
    aki-project-audit) echo "项目全面审计 / Full project audit" ;;
    aki-open-source-audit) echo "开源前安全与合规审计 / Pre-open-source audit" ;;
    aki-game-playtest-audit) echo "游戏玩家路径与试玩审计 / Game playtest audit" ;;
    aki-project-handoff) echo "项目与 Session 接管简报 / Project and session handoff" ;;
    aki-rednote-cover) echo "小红书封面生成（个人专用） / Rednote cover generation (personal)" ;;
    *) echo "Skill" ;;
  esac
}

print_presets() {
  cat <<'TXT'
预设集合 / Presets:
  core        = aki-project-bootstrap + aki-context-sync
  project     = core + aki-project-readme + aki-project-audit + aki-project-handoff（默认 / default）
  game        = project + aki-game-playtest-audit
  opensource  = project + aki-open-source-audit
  all         = 仓库内全部 Skill，包含个人专用项 / all repository Skills, including personal Skills

精确选择 / Exact selection:
  使用 --skills skill-a,skill-b / Use --skills skill-a,skill-b
TXT
}

print_available() {
  echo "可用 Skill / Available Skills:"
  for name in "${AVAILABLE_SKILLS[@]}"; do
    echo "  - $name — $(skill_summary "$name")"
  done
}

if [ "$LIST_ONLY" -eq 1 ]; then
  print_presets
  echo
  print_available
  exit 0
fi

SELECTED_SKILLS=()
add_selected() {
  name="$1"
  if ! contains "$name" "${AVAILABLE_SKILLS[@]}"; then
    echo "错误 / Error: 仓库中不存在 Skill / Skill not found in repository: $name" >&2
    exit 1
  fi
  if ! contains "$name" "${SELECTED_SKILLS[@]}"; then
    SELECTED_SKILLS+=("$name")
  fi
}

add_project_set() {
  add_selected "aki-project-bootstrap"
  add_selected "aki-context-sync"
  add_selected "aki-project-readme"
  add_selected "aki-project-audit"
  add_selected "aki-project-handoff"
}

if [ -n "$REQUESTED_SKILLS" ]; then
  normalized="$(printf '%s' "$REQUESTED_SKILLS" | tr ',' ' ')"
  for name in $normalized; do
    add_selected "$name"
  done
else
  case "$REQUESTED_SET" in
    core)
      add_selected "aki-project-bootstrap"
      add_selected "aki-context-sync"
      ;;
    project)
      add_project_set
      ;;
    game)
      add_project_set
      add_selected "aki-game-playtest-audit"
      ;;
    opensource)
      add_project_set
      add_selected "aki-open-source-audit"
      ;;
    all)
      for name in "${AVAILABLE_SKILLS[@]}"; do add_selected "$name"; done
      ;;
    *)
      echo "错误 / Error: 未知集合 / Unknown preset: $REQUESTED_SET" >&2
      exit 1
      ;;
  esac
fi

[ "${#SELECTED_SKILLS[@]}" -gt 0 ] || { echo "错误 / Error: 最终 Skill 集合为空 / Final Skill set is empty." >&2; exit 1; }

echo "选择的 Skill / Selected Skills: ${SELECTED_SKILLS[*]}"
echo

installed=0
updated=0
removed=0

for name in "${SELECTED_SKILLS[@]}"; do
  src="$tmp_dir/repo/skills/$name"
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
  printf '%s\n' \
    "managed-by=aki-agent-kit" \
    "source=$REPO_URL" \
    "ref=$REF" > "$stage/.aki-agent-kit-managed"

  rm -rf "$dest"
  mv "$stage" "$dest"
done

for dest in "$DEST_DIR"/aki-*; do
  [ -d "$dest" ] || continue
  [ -f "$dest/.aki-agent-kit-managed" ] || continue
  name="$(basename "$dest")"
  if ! contains "$name" "${SELECTED_SKILLS[@]}"; then
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

for name in "${SELECTED_SKILLS[@]}"; do
  echo
  echo "$name"
  case "$name" in
    aki-project-bootstrap)
      echo '  中文：使用 `aki-project-bootstrap` 初始化当前项目。'
      echo '  English: Use `aki-project-bootstrap` to initialize the current project.'
      ;;
    aki-context-sync)
      echo '  中文：使用 `aki-context-sync` 收敛当前会话上下文。'
      echo '  English: Use `aki-context-sync` to consolidate the current session context.'
      ;;
    aki-project-readme)
      echo '  中文：使用 `aki-project-readme` 审查并完善当前项目 README。'
      echo '  English: Use `aki-project-readme` to review and improve the current project README.'
      ;;
    aki-project-audit)
      echo '  中文：使用 `aki-project-audit` 全面审计当前项目。'
      echo '  English: Use `aki-project-audit` to audit the current project.'
      ;;
    aki-open-source-audit)
      echo '  中文：使用 `aki-open-source-audit` 做开源前审计。'
      echo '  English: Use `aki-open-source-audit` before making the repository public.'
      ;;
    aki-game-playtest-audit)
      echo '  中文：使用 `aki-game-playtest-audit` 从玩家路径审计当前游戏。'
      echo '  English: Use `aki-game-playtest-audit` to audit the game from the player path.'
      ;;
    aki-project-handoff)
      echo '  中文：使用 `aki-project-handoff` 接管或交接当前项目。'
      echo '  English: Use `aki-project-handoff` to take over or hand off the current project.'
      ;;
    aki-rednote-cover)
      echo '  中文：使用 `aki-rednote-cover` 为当前内容生成封面。'
      echo '  English: Use `aki-rednote-cover` to generate covers for the current content.'
      ;;
  esac
done

echo
echo "提示 / Tip: 如果当前 Agent 会话没有发现新安装的 Skill，请新建会话或重启 Agent。"
echo "Tip: If the current Agent session does not discover the newly installed Skills, start a new session or restart the Agent."
echo
echo "更新 / Update: 以后重复运行安装器并使用相同参数，即可更新并收敛受管 Skill。"
echo "Update: Rerun the installer with the same parameters to update and converge the managed Skills."
