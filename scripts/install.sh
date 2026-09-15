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
  install.sh                         交互选择预设；无 TTY 时默认 project
                                     Choose a preset interactively; defaults to project without a TTY
  install.sh --set core              安装 core 集合 / Install the core preset
  install.sh --set project           安装 project 集合 / Install the project preset
  install.sh --set all               安装全部 Skill / Install all Skills
  install.sh --set custom            交互逐项选择 / Choose Skills interactively
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
    aki-rednote-cover) echo "小红书封面生成（个人专用） / Rednote cover generation (personal)" ;;
    *) echo "Skill" ;;
  esac
}

print_presets() {
  cat <<'TXT'
预设集合 / Presets:
  core     = aki-project-bootstrap + aki-context-sync
  project  = core + aki-project-readme（推荐 / recommended）
  all      = 仓库内全部 Skill，包含个人专用项 / all repository Skills, including personal Skills
  custom   = 逐个选择 / choose individual Skills
TXT
}

print_available() {
  echo "可用 Skill / Available Skills:"
  i=1
  for name in "${AVAILABLE_SKILLS[@]}"; do
    echo "  $i) $name — $(skill_summary "$name")"
    i=$((i + 1))
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

choose_custom() {
  if [ ! -t 1 ] || [ ! -r /dev/tty ]; then
    echo "错误 / Error: custom 需要交互终端；非交互环境请使用 --skills / custom requires a TTY; use --skills in non-interactive environments." >&2
    exit 1
  fi

  {
    echo
    print_available
    echo
    echo "输入编号，逗号分隔，例如 1,2,3 / Enter numbers separated by commas, e.g. 1,2,3:"
  } >/dev/tty

  read -r answer </dev/tty
  answer="$(printf '%s' "$answer" | tr -d ' ')"
  [ -n "$answer" ] || { echo "错误 / Error: 未选择任何 Skill / No Skill selected." >&2; exit 1; }

  old_ifs="$IFS"
  IFS=','
  for index in $answer; do
    case "$index" in
      ''|*[!0-9]*) echo "错误 / Error: 无效编号 / Invalid selection: $index" >&2; exit 1 ;;
    esac
    if [ "$index" -lt 1 ] || [ "$index" -gt "${#AVAILABLE_SKILLS[@]}" ]; then
      echo "错误 / Error: 编号超出范围 / Selection out of range: $index" >&2
      exit 1
    fi
    add_selected "${AVAILABLE_SKILLS[$((index - 1))]}"
  done
  IFS="$old_ifs"
}

if [ -n "$REQUESTED_SKILLS" ]; then
  normalized="$(printf '%s' "$REQUESTED_SKILLS" | tr ',' ' ')"
  for name in $normalized; do
    add_selected "$name"
  done
else
  if [ -z "$REQUESTED_SET" ]; then
    if [ -t 1 ] && [ -r /dev/tty ]; then
      {
        print_presets
        echo
        echo "选择集合 / Choose preset [project]:"
        echo "  1) core"
        echo "  2) project"
        echo "  3) all"
        echo "  4) custom"
      } >/dev/tty
      read -r choice </dev/tty
      case "${choice:-2}" in
        1|core) REQUESTED_SET="core" ;;
        2|project|'') REQUESTED_SET="project" ;;
        3|all) REQUESTED_SET="all" ;;
        4|custom) REQUESTED_SET="custom" ;;
        *) echo "错误 / Error: 无效选择 / Invalid choice: $choice" >&2; exit 1 ;;
      esac
    else
      REQUESTED_SET="project"
      echo "未检测到交互终端，使用默认集合 project / No interactive TTY detected; using the project preset."
      echo
    fi
  fi

  case "$REQUESTED_SET" in
    core)
      add_selected "aki-project-bootstrap"
      add_selected "aki-context-sync"
      ;;
    project)
      add_selected "aki-project-bootstrap"
      add_selected "aki-context-sync"
      add_selected "aki-project-readme"
      ;;
    all)
      for name in "${AVAILABLE_SKILLS[@]}"; do add_selected "$name"; done
      ;;
    custom)
      choose_custom
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
echo "更新 / Update: 以后重复运行安装器并选择目标集合，即可更新并收敛受管 Skill。"
echo "Update: Rerun the installer and choose the desired set to update and converge the managed Skills."
