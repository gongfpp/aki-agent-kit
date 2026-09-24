#!/usr/bin/env bash

# 安装器管理的 Skill 与 preset 声明式目录。
# 元数据统一维护在这里；scripts/install.sh 只负责安装机制。
# 使用普通字符串和函数，保持兼容 macOS 系统 Bash 3.2。

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
    aki-project-audit) echo "普通工程项目全面审计" ;;
    aki-open-source-audit) echo "开源前安全与合规审计" ;;
    aki-game-audit) echo "游戏项目全面审计" ;;
    aki-grill-with-context) echo "自包含的决策树式深度澄清 + context sync" ;;
    aki-handoff) echo "短暂、可核验的 Agent 会话交接与接管核验" ;;
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
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-project-audit aki-grill-with-context"
      ;;
    game)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-game-audit aki-grill-with-context"
      ;;
    godot)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-game-audit aki-grill-with-context gda"
      ;;
    opensource)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-project-audit aki-grill-with-context aki-open-source-audit"
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
    core) echo "最小项目基础能力" ;;
    project) echo "普通软件项目默认集合" ;;
    game) echo "通用游戏开发集合" ;;
    godot) echo "游戏集合 + Godot 自动化" ;;
    opensource) echo "项目集合 + 开源前审计" ;;
    all) echo "全部受管 Skill" ;;
    *) return 1 ;;
  esac
}

catalog_presets() {
  echo "core project game godot opensource all"
}
