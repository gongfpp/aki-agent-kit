#!/usr/bin/env bash

# Declarative catalog for installer-managed Skills and presets.
# Keep metadata here; scripts/install.sh owns installation mechanics only.
# Use plain strings/functions for compatibility with macOS system Bash 3.2.

EXTERNAL_SKILLS="gda"

catalog_provider_repo() {
  case "$1" in
    gda) echo "https://github.com/aigengame/godot-agent.git" ;;
    *) return 1 ;;
  esac
}

catalog_provider_ref() {
  case "$1" in
    gda) echo "main" ;;
    *) return 1 ;;
  esac
}

catalog_skill_summary() {
  case "$1" in
    aki-project-bootstrap) echo "项目接入与 AGENTS.md 初始化" ;;
    aki-context-sync) echo "会话上下文持久化与文档收敛" ;;
    aki-project-readme) echo "项目 README 生成、审查与维护" ;;
    aki-project-audit) echo "项目全面审计" ;;
    aki-open-source-audit) echo "开源前安全与合规审计" ;;
    aki-game-playtest-audit) echo "游戏玩家路径与试玩审计" ;;
    aki-grill-with-context) echo "自包含的决策树式深度澄清 + context sync" ;;
    aki-handoff) echo "短暂、可核验的 Agent 任务交接" ;;
    aki-rednote-cover) echo "小红书封面生成（个人专用）" ;;
    gda) echo "Godot 自动化 · aigengame" ;;
    *) echo "Skill" ;;
  esac
}

catalog_skill_provider() {
  case "$1" in
    gda) echo "gda" ;;
    *) echo "local" ;;
  esac
}

catalog_skill_dependencies() {
  case "$1" in
    aki-grill-with-context) echo "aki-context-sync" ;;
    *) echo "" ;;
  esac
}

catalog_preset_skills() {
  case "$1" in
    core)
      echo "aki-project-bootstrap aki-context-sync"
      ;;
    project)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context aki-handoff"
      ;;
    game)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context aki-handoff aki-game-playtest-audit"
      ;;
    godot)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context aki-handoff aki-game-playtest-audit gda"
      ;;
    opensource)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context aki-handoff aki-open-source-audit"
      ;;
    all)
      echo "__ALL__"
      ;;
    *)
      return 1
      ;;
  esac
}

catalog_preset_summary() {
  case "$1" in
    core) echo "minimal project baseline" ;;
    project) echo "default software project set" ;;
    game) echo "generic game development set" ;;
    godot) echo "game set + Godot automation" ;;
    opensource) echo "project set + open-source audit" ;;
    all) echo "all managed Skills" ;;
    *) return 1 ;;
  esac
}

catalog_presets() {
  echo "core project game godot opensource all"
}
