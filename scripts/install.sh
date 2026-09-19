#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="https://github.com/gongfpp/aki-agent-kit.git"
REPO_URL="${AKI_AGENT_KIT_REPO:-$DEFAULT_REPO_URL}"
REF="${AKI_AGENT_KIT_REF:-main}"
DEST_DIR="${AKI_SKILLS_DIR:-$HOME/.agents/skills}"
REQUESTED_SET="${AKI_SKILL_SET:-}"
REQUESTED_SKILLS="${AKI_SKILLS:-}"
RULES_DIR="$HOME/.agents/aki-agent-kit/rules"
LIST_ONLY=0
VERBOSE="${AKI_INSTALL_VERBOSE:-0}"

# Keep the installer readable in interactive terminals without polluting logs or NO_COLOR environments.
if [ -t 1 ] && [ "${TERM:-}" != "dumb" ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD='\033[1m'
  DIM='\033[2m'
  CYAN='\033[36m'
  GREEN='\033[32m'
  YELLOW='\033[33m'
  RED='\033[31m'
  RESET='\033[0m'
else
  BOLD=''
  DIM=''
  CYAN=''
  GREEN=''
  YELLOW=''
  RED=''
  RESET=''
fi

ui_title() {
  printf '\n%baki-agent-kit%b\n' "$BOLD" "$RESET"
  printf '%bSkill Installer%b\n' "$DIM" "$RESET"
}

ui_section() {
  printf '\n%b==>%b %s\n' "$CYAN$BOLD" "$RESET" "$1"
}

ui_kv() {
  printf '    %-12s %s\n' "$1" "$2"
}

ui_ok() {
  printf '  %b✓%b %-30s %b%s%b\n' "$GREEN" "$RESET" "$1" "$DIM" "$2" "$RESET"
}

ui_info() {
  printf '  %b·%b %s\n' "$CYAN" "$RESET" "$1"
}

ui_warn() {
  printf '  %b!%b %s\n' "$YELLOW" "$RESET" "$1"
}

ui_error() {
  printf '%b✗%b %s\n' "$RED" "$RESET" "$1" >&2
}

display_path() {
  case "$1" in
    "$HOME") printf '~' ;;
    "$HOME"/*) printf '~/%s' "${1#"$HOME"/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

count_skills() {
  local list="$1"
  local count=0
  local item
  for item in $list; do
    count=$((count + 1))
  done
  printf '%s' "$count"
}

curl_download() {
  local url="$1"
  local output="$2"

  command -v curl >/dev/null 2>&1 || return 1
  rm -f "$output"
  curl -fsSL --connect-timeout 4 --max-time 15 "$url" -o "$output"
}

git_clone_repo() {
  local ref="$1"
  local repo="$2"
  local dest="$3"

  git clone --quiet --depth 1 --branch "$ref" "$repo" "$dest"
}

load_aki_repo() {
  local dest="$1"
  local archive="$tmp_dir/aki-agent-kit.tar.gz"
  local archive_url="https://api.github.com/repos/gongfpp/aki-agent-kit/tarball/$REF"

  if [ "$REPO_URL" = "$DEFAULT_REPO_URL" ]; then
    if ! command -v curl >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
      ui_error "默认安装需要 curl 和 tar / Default install requires curl and tar"
      return 1
    fi

    if ! curl_download "$archive_url" "$archive"; then
      return 1
    fi

    mkdir -p "$dest"
    if ! tar -xzf "$archive" -C "$dest" --strip-components=1; then
      rm -rf "$dest"
      ui_error "仓库归档解压失败 / Failed to extract aki-agent-kit archive"
      return 1
    fi
    return 0
  fi

  git_clone_repo "$REF" "$REPO_URL" "$dest"
}

sync_rules_cache() {
  local stage="$tmp_dir/rules-cache"

  rm -rf "$stage"
  mkdir -p "$stage/principles"
  cp "$tmp_dir/repo/AGENTS.md" "$stage/AGENTS.md"
  cp "$tmp_dir/repo/principles/"*.md "$stage/principles/"

  mkdir -p "$(dirname "$RULES_DIR")"
  if [ -d "$RULES_DIR" ] && diff -qr "$RULES_DIR" "$stage" >/dev/null 2>&1; then
    rm -rf "$stage"
    return
  fi

  rm -rf "$RULES_DIR"
  mv "$stage" "$RULES_DIR"
}

git_remote_revision() {
  local ref="$1"
  local repo="$2"
  local output revision

  output="$(git ls-remote "$repo" "$ref" 2>/dev/null)" || return 1
  revision="$(printf '%s\n' "$output" | awk 'NF >= 2 { value=$1 } END { print value }')"
  [ -n "$revision" ] || return 1
  printf '%s' "$revision"
}

provider_state_matches() {
  local state_file="$1"
  local source="$2"
  local ref="$3"
  local revision="$4"

  [ -f "$state_file" ] || return 1
  grep -Fqx "source=$source" "$state_file" || return 1
  grep -Fqx "ref=$ref" "$state_file" || return 1
  grep -Fqx "revision=$revision" "$state_file" || return 1
}

write_provider_state() {
  local state_file="$1"
  local source="$2"
  local ref="$3"
  local revision="$4"

  printf '%s\n' \
    "source=$source" \
    "ref=$ref" \
    "revision=$revision" > "$state_file"
}

usage() {
  cat <<'TXT'
aki-agent-kit Skill Installer

Usage:
  install.sh                       install the default project preset
  install.sh --set NAME            install a named preset; use --list to inspect current presets
  install.sh --skills a,b,c        install exact Skills; dependencies auto-added
  install.sh --list                list current presets and Skills
  install.sh -v, --verbose         show source and selected Skill details
  install.sh -h, --help            show help

Environment:
  AKI_SKILLS_DIR       destination, default ~/.agents/skills
  AKI_SKILL_SET        same as --set
  AKI_SKILLS           same as --skills
  AKI_AGENT_KIT_REPO   source repository
  AKI_AGENT_KIT_REF    source Git ref, default main
  AKI_INSTALL_VERBOSE  set to 1 for verbose output
  NO_COLOR             disable ANSI colors
TXT
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --set)
      [ "$#" -ge 2 ] || { ui_error "--set 需要参数 / requires a value"; exit 1; }
      REQUESTED_SET="$2"
      shift 2
      ;;
    --skills)
      [ "$#" -ge 2 ] || { ui_error "--skills 需要参数 / requires a value"; exit 1; }
      REQUESTED_SKILLS="$2"
      shift 2
      ;;
    --list)
      LIST_ONLY=1
      shift
      ;;
    --verbose|-v)
      VERBOSE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      ui_error "未知参数 / Unknown option: $1"
      usage >&2
      exit 1
      ;;
  esac
done

if [ -n "$REQUESTED_SET" ] && [ -n "$REQUESTED_SKILLS" ]; then
  ui_error "--set 与 --skills 不能同时使用 / cannot be used together"
  exit 1
fi

if [ -z "$REQUESTED_SET" ] && [ -z "$REQUESTED_SKILLS" ]; then
  REQUESTED_SET="project"
fi

if ! command -v git >/dev/null 2>&1; then
  ui_error "需要先安装 Git / Git is required"
  exit 1
fi

mkdir -p "$DEST_DIR"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/aki-agent-kit.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

ui_title
ui_info "读取 Skill catalog / Loading catalog"
if ! load_aki_repo "$tmp_dir/repo"; then
  ui_error "无法读取 aki-agent-kit / Failed to fetch aki-agent-kit"
  exit 1
fi

CATALOG_FILE="$tmp_dir/repo/scripts/skills.catalog.sh"
if [ ! -f "$CATALOG_FILE" ]; then
  ui_error "缺少 Skill catalog / Missing scripts/skills.catalog.sh"
  exit 1
fi

sync_rules_cache

# shellcheck disable=SC1090
. "$CATALOG_FILE"

MATT_REPO="${AKI_MATT_SKILLS_REPO:-$(catalog_provider_repo matt)}"
MATT_REF="${AKI_MATT_SKILLS_REF:-$(catalog_provider_ref matt)}"
GDA_REPO="${AKI_GDA_REPO:-$(catalog_provider_repo gda)}"
GDA_REF="${AKI_GDA_REF:-$(catalog_provider_ref gda)}"

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

AVAILABLE_SKILLS="$LOCAL_SKILLS $EXTERNAL_SKILLS"
SELECTED_SKILLS=""
MATT_READY=0
MATT_SELECTED=0
MATT_SKIP_FETCH=0
MATT_REVISION=""
MATT_STATE_FILE="$DEST_DIR/.aki-agent-kit-provider-matt"
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

print_presets() {
  local preset
  ui_section "预设 / Presets"
  for preset in $(catalog_presets); do
    printf '  %-12s %s%s\n' "$preset" "$(catalog_preset_summary "$preset")" "$( [ "$preset" = "project" ] && printf '  (default)' || true )"
  done
}

print_available() {
  local name
  ui_section "Skills"
  for name in $AVAILABLE_SKILLS; do
    printf '  %-30s %s\n' "$name" "$(catalog_skill_summary "$name")"
  done
}

if [ "$LIST_ONLY" -eq 1 ]; then
  print_presets
  print_available
  exit 0
fi

add_selected() {
  local name="$1"
  if ! contains_skill "$name" "$AVAILABLE_SKILLS"; then
    ui_error "Skill 不存在 / Skill not found: $name"
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

if [ -n "$REQUESTED_SKILLS" ]; then
  normalized="$(printf '%s' "$REQUESTED_SKILLS" | tr ',' ' ')"
  for name in $normalized; do
    add_selected "$name"
  done
else
  if ! preset_skills="$(catalog_preset_skills "$REQUESTED_SET")"; then
    ui_error "未知集合 / Unknown preset: $REQUESTED_SET"
    exit 1
  fi
  if [ "$preset_skills" = "__ALL__" ]; then
    for name in $AVAILABLE_SKILLS; do
      add_selected "$name"
    done
  else
    for name in $preset_skills; do
      add_selected "$name"
    done
  fi
fi

# Resolve dependencies to a fixed point so catalog entries can depend on other managed Skills.
while :; do
  before="$SELECTED_SKILLS"
  for name in $SELECTED_SKILLS; do
    for dependency in $(catalog_skill_dependencies "$name"); do
      add_selected "$dependency"
    done
  done
  [ "$before" = "$SELECTED_SKILLS" ] && break
done

[ -n "$SELECTED_SKILLS" ] || { ui_error "最终 Skill 集合为空 / Final Skill set is empty"; exit 1; }

if [ -n "$REQUESTED_SKILLS" ]; then
  preset_label="custom"
else
  preset_label="$REQUESTED_SET"
fi

ui_section "安装计划 / Plan"
ui_kv "preset" "$preset_label"
ui_kv "destination" "$(display_path "$DEST_DIR")"
ui_kv "skills" "$(count_skills "$SELECTED_SKILLS")"
if [ "$VERBOSE" = "1" ]; then
  ui_kv "source" "$REPO_URL@$REF"
  printf '    %-12s %s\n' "selected" "$SELECTED_SKILLS"
fi

selected_matt_skills_are_managed() {
  local name marker

  for name in $SELECTED_SKILLS; do
    [ "$(catalog_skill_provider "$name")" = "matt" ] || continue
    marker="$DEST_DIR/$name/.aki-agent-kit-managed"
    [ -f "$marker" ] || return 1
    grep -Fqx "source=$MATT_REPO" "$marker" || return 1
    grep -Fqx "ref=$MATT_REF" "$marker" || return 1
  done
}

prepare_matt_provider() {
  local name

  for name in $SELECTED_SKILLS; do
    if [ "$(catalog_skill_provider "$name")" = "matt" ]; then
      MATT_SELECTED=1
      break
    fi
  done

  [ "$MATT_SELECTED" -eq 1 ] || return

  ui_info "mattpocock/skills · checking"
  if MATT_REVISION="$(git_remote_revision "$MATT_REF" "$MATT_REPO")"; then
    if provider_state_matches "$MATT_STATE_FILE" "$MATT_REPO" "$MATT_REF" "$MATT_REVISION" \
      && selected_matt_skills_are_managed; then
      MATT_SKIP_FETCH=1
    fi
  else
    ui_warn "mattpocock/skills · revision check failed; falling back to fetch"
  fi
}

ensure_matt_repo() {
  if [ "$MATT_READY" -eq 1 ]; then return; fi
  ui_info "mattpocock/skills · fetching"
  if ! git_clone_repo "$MATT_REF" "$MATT_REPO" "$MATT_ROOT"; then
    ui_error "无法读取 mattpocock/skills / Failed to fetch mattpocock/skills"
    exit 1
  fi
  MATT_READY=1
  if [ -z "$MATT_REVISION" ]; then
    MATT_REVISION="$(git -C "$MATT_ROOT" rev-parse HEAD 2>/dev/null || true)"
  fi
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
  ui_error "mattpocock/skills 中找不到 / Skill not found upstream: $target"
  exit 1
}

ensure_gda_repo() {
  if [ "$GDA_READY" -eq 1 ]; then return; fi
  ui_info "aigengame/godot-agent · fetching"
  if ! git_clone_repo "$GDA_REF" "$GDA_REPO" "$GDA_ROOT"; then
    ui_error "无法读取 aigengame/godot-agent / Failed to fetch aigengame/godot-agent"
    exit 1
  fi
  GDA_READY=1
}

installed=0
updated=0
unchanged=0
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
  local status

  if [ ! -d "$src" ] || [ ! -f "$src/SKILL.md" ]; then
    ui_error "Skill 源无效 / Invalid Skill source: $name"
    exit 1
  fi

  if [ -e "$dest" ] && [ ! -f "$marker" ]; then
    ui_error "拒绝覆盖非本安装器管理的 Skill / Refusing to overwrite unmanaged Skill: $dest"
    exit 1
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

  if [ -f "$marker" ] && diff -qr "$dest" "$stage" >/dev/null 2>&1; then
    unchanged=$((unchanged + 1))
    rm -rf "$stage"
    ui_ok "$name" "unchanged"
    return
  fi

  if [ -f "$marker" ]; then
    status="updated"
    updated=$((updated + 1))
  else
    status="installed"
    installed=$((installed + 1))
  fi

  rm -rf "$dest"
  mv "$stage" "$dest"
  ui_ok "$name" "$status"
}

install_one() {
  local name="$1"
  local provider generated
  provider="$(catalog_skill_provider "$name")"

  case "$provider" in
    matt)
      if [ "$MATT_SKIP_FETCH" -eq 1 ]; then
        unchanged=$((unchanged + 1))
        ui_ok "$name" "unchanged"
      else
        resolve_matt_skill_dir "$name"
        install_from_dir "$name" "$RESOLVED_SKILL_DIR" "$MATT_REPO" "$MATT_REF" "$MATT_ROOT/LICENSE"
      fi
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
    local)
      install_from_dir "$name" "$tmp_dir/repo/skills/$name" "$REPO_URL" "$REF" ""
      ;;
    *)
      ui_error "未知 Skill provider / Unknown provider for $name: $provider"
      exit 1
      ;;
  esac
}

prepare_matt_provider

ui_section "同步 Skills / Sync"
for name in $SELECTED_SKILLS; do
  install_one "$name"
done

if [ "$MATT_SELECTED" -eq 1 ] && [ -n "$MATT_REVISION" ]; then
  write_provider_state "$MATT_STATE_FILE" "$MATT_REPO" "$MATT_REF" "$MATT_REVISION"
fi

# Converge every directory previously managed by this installer, including external Skills.
for dest in "$DEST_DIR"/*; do
  [ -d "$dest" ] || continue
  [ -f "$dest/.aki-agent-kit-managed" ] || continue
  name="$(basename "$dest")"
  if ! contains_skill "$name" "$SELECTED_SKILLS"; then
    rm -rf "$dest"
    removed=$((removed + 1))
    ui_ok "$name" "removed"
  fi
done

printf '\n%b✓%b %b完成 / Done%b\n' "$GREEN" "$RESET" "$BOLD" "$RESET"
printf '  %s installed  ·  %s updated  ·  %s unchanged  ·  %s removed\n' "$installed" "$updated" "$unchanged" "$removed"
printf '  %s\n' "$(display_path "$DEST_DIR")"

if contains_skill "gda" "$SELECTED_SKILLS" && ! command -v gda >/dev/null 2>&1; then
  ui_section "需要处理 / Action required"
  ui_warn 'gda Skill 已安装，但未检测到 gda CLI：`uv tool install gda`'
fi

ui_section "下一步 / Next"
printf '  新会话即可使用这些 Skills；未发现时重启 Agent。\n'
printf '  %b再次运行同一命令即可更新并收敛受管 Skills。%b\n' "$DIM" "$RESET"
