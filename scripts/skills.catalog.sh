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
  case "$1:${2:-zh}" in
    aki-project-bootstrap:zh) echo "准备项目的 AI 开发说明" ;;
    aki-project-bootstrap:en) echo "Set up the project's AI development instructions" ;;
    aki-context-sync:zh) echo "把本次讨论的重要约定保存到项目文档" ;;
    aki-context-sync:en) echo "Save important decisions from this conversation in project documents" ;;
    aki-project-readme:zh) echo "写好项目介绍和使用说明" ;;
    aki-project-readme:en) echo "Improve the project introduction and usage guide" ;;
    aki-project-audit:zh) echo "检查软件项目的问题并给出改进建议" ;;
    aki-project-audit:en) echo "Find software project issues and suggest improvements" ;;
    aki-open-source-audit:zh) echo "检查项目公开前需要处理的问题" ;;
    aki-open-source-audit:en) echo "Check what needs attention before making a project public" ;;
    aki-game-audit:zh) echo "检查游戏体验、运行问题和后续制作成本" ;;
    aki-game-audit:en) echo "Review gameplay, runtime issues, and content production effort" ;;
    aki-align-me:zh) echo "先用自己的话复述需求，确认功能理解是否准确" ;;
    aki-align-me:en) echo "Restate the requested feature to check understanding before planning" ;;
    aki-plan:zh) echo "弄清目标并拆成可执行任务，按需要保存计划" ;;
    aki-plan:en) echo "Clarify goals, break them into actionable tasks, and save the plan when needed" ;;
    aki-handoff:zh) echo "交接当前对话，让下一个 AI 接着处理同一件事" ;;
    aki-handoff:en) echo "Hand off this conversation so the next AI continues the same task" ;;
    aki-rednote-cover:zh) echo "制作带三颗草和用户名的个人封面" ;;
    aki-rednote-cover:en) echo "Create a personal cover with three grass marks and the username" ;;
    gda:zh) echo "操作 Godot，运行游戏并获取截图和日志" ;;
    gda:en) echo "Operate Godot, run the game, and capture screenshots and logs" ;;
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
    *) echo "" ;;
  esac
}

catalog_preset_skills() {
  case "$1" in
    core)
      echo "aki-project-bootstrap aki-context-sync"
      ;;
    project)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-project-audit aki-align-me aki-plan"
      ;;
    game)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-game-audit aki-align-me aki-plan"
      ;;
    godot)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-game-audit aki-align-me aki-plan gda"
      ;;
    opensource)
      echo "aki-project-bootstrap aki-context-sync aki-handoff aki-project-readme aki-project-audit aki-align-me aki-plan aki-open-source-audit"
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
  case "$1:${2:-zh}" in
    core:zh) echo "准备开发说明、保存讨论约定" ;;
    core:en) echo "Set up project instructions and save decisions" ;;
    project:zh) echo "日常软件开发（默认）" ;;
    project:en) echo "Everyday software development (default)" ;;
    game:zh) echo "通用游戏开发" ;;
    game:en) echo "General game development" ;;
    godot:zh) echo "游戏开发，加上 Godot 操作工具" ;;
    godot:en) echo "Game development with Godot automation" ;;
    opensource:zh) echo "软件开发，加上公开前检查" ;;
    opensource:en) echo "Software development with pre-publication checks" ;;
    all:zh) echo "全部功能，包含个人封面工具" ;;
    all:en) echo "All Skills, including the personal cover tool" ;;
    *) return 1 ;;
  esac
}

catalog_presets() {
  echo "core project game godot opensource all"
}
