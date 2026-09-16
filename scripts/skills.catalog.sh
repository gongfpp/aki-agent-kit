#!/usr/bin/env bash

# Declarative catalog for installer-managed Skills and presets.
# Keep metadata here; scripts/install.sh owns installation mechanics only.
# Use plain strings/functions for compatibility with macOS system Bash 3.2.

EXTERNAL_SKILLS="grill-me grilling handoff retro writing-for-agents gda"

catalog_skill_summary() {
  case "$1" in
    aki-project-bootstrap) echo "项目接入与 AGENTS.md 初始化" ;;
    aki-context-sync) echo "会话上下文持久化与文档收敛" ;;
    aki-project-readme) echo "项目 README 生成、审查与维护" ;;
    aki-project-audit) echo "项目全面审计" ;;
    aki-open-source-audit) echo "开源前安全与合规审计" ;;
    aki-game-playtest-audit) echo "游戏玩家路径与试玩审计" ;;
    aki-grill-with-context) echo "Grilling + context sync 决策收敛" ;;
    aki-rednote-cover) echo "小红书封面生成（个人专用）" ;;
    grill-me) echo "深度追问计划与设计 · Matt Pocock" ;;
    grilling) echo "grill-me 决策树执行核心 · Matt Pocock" ;;
    handoff) echo "会话交接文档 · Matt Pocock" ;;
    retro) echo "编码会话复盘 · Matt Pocock" ;;
    writing-for-agents) echo "Agent 文档写作参考 · Matt Pocock" ;;
    gda) echo "Godot 自动化 · aigengame" ;;
    *) echo "Skill" ;;
  esac
}

catalog_skill_provider() {
  case "$1" in
    grill-me|grilling|handoff|retro|writing-for-agents) echo "matt" ;;
    gda) echo "gda" ;;
    *) echo "local" ;;
  esac
}

catalog_skill_dependencies() {
  case "$1" in
    grill-me) echo "grilling" ;;
    retro) echo "writing-for-agents" ;;
    aki-grill-with-context) echo "grilling aki-context-sync" ;;
    *) echo "" ;;
  esac
}

catalog_preset_skills() {
  case "$1" in
    core)
      echo "aki-project-bootstrap aki-context-sync"
      ;;
    project)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context grill-me handoff retro"
      ;;
    game)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context grill-me handoff retro aki-game-playtest-audit"
      ;;
    godot)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context grill-me handoff retro aki-game-playtest-audit gda"
      ;;
    opensource)
      echo "aki-project-bootstrap aki-context-sync aki-project-readme aki-project-audit aki-grill-with-context grill-me handoff retro aki-open-source-audit"
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
