#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${AKI_AGENT_KIT_REPO:-https://github.com/gongfpp/aki-agent-kit.git}"
REF="${AKI_AGENT_KIT_REF:-main}"
DEST_DIR="${AKI_SKILLS_DIR:-$HOME/.agents/skills}"
REQUESTED_SET="${AKI_SKILL_SET:-}"
REQUESTED_SKILLS="${AKI_SKILLS:-}"
MATT_REPO="${AKI_MATT_SKILLS_REPO:-https://github.com/mattpocock/skills.git}"
MATT_REF="${AKI_MATT_SKILLS_REF:-main}"
GDA_REPO="${AKI_GDA_REPO:-https://github.com/aigengame/godot-agent.git}"
GDA_REF="${AKI_GDA_REF:-main}"
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
  install.sh --skills a,b,c          指定 Skill；依赖自动补齐 / Select Skills; dependencies are added automatically
  install.sh --list                  查看预设与可用 Skill / List presets and available Skills
  install.sh --help                  显示帮助 / Show help

环境变量 / Environment:
  AKI_SKILLS_DIR       安装目录，默认 ~/.agents/skills / Destination directory
  AKI_SKILL_SET        等价于 --set / Same as --set
  AKI_SKILLS           等价于 --skills / Same as --skills
  AKI_AGENT_KIT_REPO   aki-agent-kit 源仓库 / aki-agent-kit source repository
  AKI_AGENT_KIT_REF    aki-agent-kit Git ref，默认 main / Git ref, default main
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
  echo "错误 / Error: 无法读取 aki-agent-kit / Failed to fetch aki-agent-kit." >&2
  exit 1
fi

# Plain whitespace-separated lists keep compatibility with macOS system Bash 3.2 + set -u.
LOCAL_SKILLS=""
for src in "$tmp_dir"/repo/skills/*; do
  [ -d "$src" ] || continue
  [ -f "$src/SKILL.md" ] || continue
  skill_name="$(basename "$src")"
  if [ -n "$LOCAL_SKILLS" ]; then
    LOCAL_SKILLS="$LOCAL_SKILLS $skill_name"
  else
    LOCAL_SKILLS="$skill_name"
  fi
done

EXTERNAL_SKILLS="grill-me grilling handoff retro writing-for-agents gda"
AVAILABLE_SKILLS="$LOCAL_SKILLS $EXTERNAL_SKILLS"
SELECTED_SKILLS=""
MATT_READY=0
GDA_READY=0
MATT_ROOT="$tmp_dir/matt-skills"
GDA_ROOT="$tmp_dir/godot-agent"
RESOLVED_SKILL_DIR=""

contains_skill() {
  local needle="$1"
  local list="$2"
  case " $list " in
    *" $needle "*) return 0 ;;
    *) return 1 ;;
  esac
}

skill_summary() {
  case "$1" in
    aki-project-bootstrap) echo "项目接入与 AGENTS.md 初始化 / Project bootstrap and AGENTS.md setup" ;;
    aki-context-sync) echo "会话上下文持久化与文档收敛 / Session context consolidation" ;;
    aki-project-readme) echo "项目 README 生成、审查与维护 / Project README generation and review" ;;
    aki-project-audit) echo "项目全面审计 / Full project audit" ;;
    aki-open-source-audit) echo "开源前安全与合规审计 / Pre-open-source audit" ;;
    aki-game-playtest-audit) echo "游戏玩家路径与试玩审计 / Game playtest audit" ;;
    aki-grill-with-context) echo "Grilling + aki-context-sync 决策收敛 / Grilling + context sync" ;;
    aki-rednote-cover) echo "小红书封面生成（个人专用） / Rednote cover generation (personal)" ;;
    grill-me) echo "深度追问计划与设计（Matt Pocock） / Relentless plan and design interview" ;;
    grilling) echo "grill-me 的决策树执行核心（Matt Pocock） / Decision-tree grilling primitive" ;;
    handoff) echo "会话交接文档（Matt Pocock） / Conversation handoff" ;;
    retro) echo "编码会话复盘（Matt Pocock, in-progress） / Coding session retrospective" ;;
    writing-for-agents) echo "面向 Agent 的文档写作参考（Matt Pocock） / Writing reference for agents" ;;
    gda) echo "Godot Agent CLI Skill（aigengame） / Godot automation Skill" ;;
    *) echo "Skill" ;;
  esac
}

print_presets() {
  cat <<'TXT'
预设集合 / Presets:
  core        = aki-project-bootstrap + aki-context-sync
  project     = core + README/audit + grill + handoff + retro（默认 / default）
  game        = project + aki-game-playtest-audit + gda
  opensource  = project + aki-open-source-audit
  all         = 全部本仓库与外部 Skill，包含个人专用项 / all local and external Skills

外部 Skill / External Skills:
  Matt Pocock: grill-me, grilling, handoff, retro, writing-for-agents
  aigengame:   gda

精确选择 / Exact selection:
  使用 --skills skill-a,skill-b；必要依赖会自动补齐 / Dependencies are added automatically
TXT
}

print_available() {
  echo "可用 Skill / Available Skills:"
  for name in $AVAILABLE_SKILLS; do
    echo "  - $name — $(skill_summary "$name")"
  done
}

if [ "$LIST_ONLY" -eq 1 ]; then
  print_presets
  echo
  print_available
  exit 0
fi

add_selected() {
  local name="$1"
  if ! contains_skill "$name" "$AVAILABLE_SKILLS"; then
    echo "错误 / Error: 不存在 Skill / Skill not found: $name" >&2
    exit 1
  fi
  if ! contains_skill "$name" "$SELECTED_SKILLS"; then
    if [ -n "$SELECTED_SKILLS" ]; then
      SELECTED_SKILLS="$SELECTED_SKILLS $name"
    else
      SELECTED_SKILLS="$name"
    fi
  fi
}

add_project_set() {
  add_selected "aki-project-bootstrap"
  add_selected "aki-context-sync"
  add_selected "aki-project-readme"
  add_selected "aki-project-audit"
  add_selected "aki-grill-with-context"
  add_selected "grill-me"
  add_selected "handoff"
  add_selected "retro"
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
      add_selected "gda"
      ;;
    opensource)
      add_project_set
      add_selected "aki-open-source-audit"
      ;;
    all)
      for name in $AVAILABLE_SKILLS; do
        add_selected "$name"
      done
      ;;
    *)
      echo "错误 / Error: 未知集合 / Unknown preset: $REQUESTED_SET" >&2
      exit 1
      ;;
  esac
fi

# Resolve Skill-to-Skill dependencies without duplicating upstream implementations.
if contains_skill "grill-me" "$SELECTED_SKILLS"; then add_selected "grilling"; fi
if contains_skill "retro" "$SELECTED_SKILLS"; then add_selected "writing-for-agents"; fi
if contains_skill "aki-grill-with-context" "$SELECTED_SKILLS"; then
  add_selected "grilling"
  add_selected "aki-context-sync"
fi

[ -n "$SELECTED_SKILLS" ] || { echo "错误 / Error: 最终 Skill 集合为空 / Final Skill set is empty." >&2; exit 1; }

echo "选择的 Skill / Selected Skills: $SELECTED_SKILLS"
echo

ensure_matt_repo() {
  if [ "$MATT_READY" -eq 1 ]; then return; fi
  echo "读取外部 Skill / Fetching external Skills: mattpocock/skills"
  if ! git clone --quiet --depth 1 --branch "$MATT_REF" "$MATT_REPO" "$MATT_ROOT"; then
    echo "错误 / Error: 无法读取 mattpocock/skills / Failed to fetch mattpocock/skills." >&2
    exit 1
  fi
  MATT_READY=1
}

resolve_matt_skill_dir() {
  local target="$1"
  local skill_file declared
  ensure_matt_repo
  RESOLVED_SKILL_DIR=""
  for skill_file in "$MATT_ROOT"/skills/*/*/SKILL.md; do
    [ -f "$skill_file" ] || continue
    declared="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1 | tr -d '\"')"
    if [ "$declared" = "$target" ]; then
      RESOLVED_SKILL_DIR="$(dirname "$skill_file")"
      return
    fi
  done
  echo "错误 / Error: mattpocock/skills 中找不到 / Skill not found upstream: $target" >&2
  exit 1
}

ensure_gda_repo() {
  if [ "$GDA_READY" -eq 1 ]; then return; fi
  echo "读取外部 Skill / Fetching external Skill: aigengame/godot-agent"
  if ! git clone --quiet --depth 1 --branch "$GDA_REF" "$GDA_REPO" "$GDA_ROOT"; then
    echo "错误 / Error: 无法读取 aigengame/godot-agent / Failed to fetch aigengame/godot-agent." >&2
    exit 1
  fi
  GDA_READY=1
}

installed=0
updated=0
removed=0

install_from_dir() {
  local name="$1"
  local src="$2"
  local source="$3"
  local source_ref="$4"
  local license_file="${5:-}"
  local dest="$DEST_DIR/$name"
  local marker="$dest/.aki-agent-kit-managed"
  local stage="$DEST_DIR/.${name}.tmp.$$"

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

  rm -rf "$stage"
  mkdir -p "$stage"
  cp -R "$src"/. "$stage"/
  if [ -n "$license_file" ] && [ -f "$license_file" ]; then
    cp "$license_file" "$stage/LICENSE.upstream"
  fi
  printf '%s\n' \
    "managed-by=aki-agent-kit" \
    "source=$source" \
    "ref=$source_ref" > "$stage/.aki-agent-kit-managed"

  rm -rf "$dest"
  mv "$stage" "$dest"
}

install_one() {
  local name="$1"
  local generated
  case "$name" in
    grill-me|grilling|handoff|retro|writing-for-agents)
      resolve_matt_skill_dir "$name"
      install_from_dir "$name" "$RESOLVED_SKILL_DIR" "$MATT_REPO" "$MATT_REF" "$MATT_ROOT/LICENSE"
      ;;
    gda)
      ensure_gda_repo
      if command -v gda >/dev/null 2>&1; then
        generated="$tmp_dir/gda-generated"
        rm -rf "$generated"
        mkdir -p "$generated"
        if gda skill > "$generated/SKILL.md"; then
          install_from_dir "$name" "$generated" "installed-gda-cli" "version-aligned" "$GDA_ROOT/LICENSE"
        else
          install_from_dir "$name" "$GDA_ROOT/src/gda/skill" "$GDA_REPO" "$GDA_REF" "$GDA_ROOT/LICENSE"
        fi
      else
        install_from_dir "$name" "$GDA_ROOT/src/gda/skill" "$GDA_REPO" "$GDA_REF" "$GDA_ROOT/LICENSE"
      fi
      ;;
    *)
      install_from_dir "$name" "$tmp_dir/repo/skills/$name" "$REPO_URL" "$REF" ""
      ;;
  esac
}

for name in $SELECTED_SKILLS; do
  install_one "$name"
done

# Converge every directory previously managed by this installer, including external Skills.
for dest in "$DEST_DIR"/*; do
  [ -d "$dest" ] || continue
  [ -f "$dest/.aki-agent-kit-managed" ] || continue
  name="$(basename "$dest")"
  if ! contains_skill "$name" "$SELECTED_SKILLS"; then
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

for name in $SELECTED_SKILLS; do
  echo
  echo "$name"
  case "$name" in
    aki-project-bootstrap)
      echo '  使用 `aki-project-bootstrap` 初始化当前项目。'
      echo '  Use `aki-project-bootstrap` to initialize the current project.'
      ;;
    aki-context-sync)
      echo '  使用 `aki-context-sync` 收敛当前会话上下文。'
      echo '  Use `aki-context-sync` to consolidate the current session context.'
      ;;
    aki-project-readme)
      echo '  使用 `aki-project-readme` 审查并完善当前项目 README。'
      echo '  Use `aki-project-readme` to review and improve the current project README.'
      ;;
    aki-project-audit)
      echo '  使用 `aki-project-audit` 全面审计当前项目。'
      echo '  Use `aki-project-audit` to audit the current project.'
      ;;
    aki-open-source-audit)
      echo '  使用 `aki-open-source-audit` 做开源前审计。'
      echo '  Use `aki-open-source-audit` before making the repository public.'
      ;;
    aki-game-playtest-audit)
      echo '  使用 `aki-game-playtest-audit` 从玩家路径审计当前游戏。'
      echo '  Use `aki-game-playtest-audit` to audit the game from the player path.'
      ;;
    aki-grill-with-context)
      echo '  使用 `aki-grill-with-context` 深度澄清决策，并把长期结论同步进项目权威文档。'
      echo '  Use `aki-grill-with-context` to grill decisions and sync durable conclusions into project docs.'
      ;;
    grill-me)
      echo '  使用 `grill-me` 深度追问一个计划、设计或想法。'
      echo '  Use `grill-me` to relentlessly sharpen a plan, design, or idea.'
      ;;
    grilling)
      echo '  `grilling` 是 grill-me 与 aki-grill-with-context 使用的底层决策树 Skill。'
      echo '  `grilling` is the decision-tree primitive used by grill-me and aki-grill-with-context.'
      ;;
    handoff)
      echo '  使用 `handoff` 把当前会话压缩成下一位 Agent 可接管的临时交接文档。'
      echo '  Use `handoff` to compact the current conversation for the next agent.'
      ;;
    retro)
      echo '  使用 `retro` 复盘一次编码会话，找出 Agent 环境、规则和工具链的改进点。'
      echo '  Use `retro` to improve the agent environment after a coding session.'
      ;;
    writing-for-agents)
      echo '  `writing-for-agents` 是 retro 等上游 Skill 使用的 Agent 文档写作参考。'
      echo '  `writing-for-agents` is a reference used by upstream Skills such as retro.'
      ;;
    gda)
      echo '  使用 `gda` 驱动 Godot、运行场景、模拟输入、截图、读取日志和性能数据。'
      echo '  Use `gda` to drive Godot, run scenes, simulate input, capture frames, and inspect diagnostics.'
      if ! command -v gda >/dev/null 2>&1; then
        echo '  当前未检测到 gda CLI；Skill 已安装，但真正操作 Godot 前还需：`uv tool install gda`。'
        echo '  gda CLI was not found; install it before driving Godot: `uv tool install gda`.'
      fi
      ;;
    aki-rednote-cover)
      echo '  使用 `aki-rednote-cover` 为当前内容生成封面。'
      echo '  Use `aki-rednote-cover` to generate covers for the current content.'
      ;;
  esac
done

echo
echo "提示 / Tip: 如果当前 Agent 会话没有发现新安装的 Skill，请新建会话或重启 Agent。"
echo "Tip: If the current Agent session does not discover the newly installed Skills, start a new session or restart the Agent."
echo
echo "更新 / Update: 以后重复运行安装器并使用相同参数，即可更新并收敛本仓库与外部受管 Skill。"
echo "Update: Rerun the installer with the same parameters to update local and external managed Skills."
