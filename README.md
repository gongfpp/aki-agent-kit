# aki-agent-kit

个人 AI Agent 工作流的增量层：以 `AGENTS.md` 和 Agent Skills 等上游标准为基础，只维护个人开发原则和差异化 Skills。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 上游基础

- `AGENTS.md`：<https://github.com/agentsmd/agents.md>
- Agent Skills：<https://github.com/agentskills/agentskills>
- Skill 参考实现：<https://github.com/anthropics/skills>
- OpenAI Plugin / Skill：<https://github.com/openai/plugins>
- 通用开发工作流参考：<https://github.com/obra/superpowers>

本仓库只保存个人偏好、专用工作流和需要跨项目复用的判断原则。

## Principles

- `principles/project-development.md`：普通软件项目开发基线。
- `principles/game-development.md`：独立游戏项目补充原则。
- `principles/git.md`：Git 版本管理原则。
- `principles/simplification.md`：通用项目精简审计。
- `principles/game-simplification.md`：游戏项目精简补充。
- `principles/skill-authoring.md`：Skill 内容质量与维护原则。

## Skills

- `aki-project-bootstrap`：幂等接入个人开发原则，只维护项目 `AGENTS.md` 中自己的 managed region。
- `aki-context-sync`：审计开发会话与项目事实，把真正值得长期保存的隐性上下文同步进权威文档。
- `aki-github-readme`：生成、重写和审查 GitHub README。
- `aki-rednote-cover`：生成“城下秋草”统一视觉的小红书封面。

## 用户级安装

将全部 Skill 安装到通用用户级目录 `~/.agents/skills`：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

安装器会复制真实目录而不是创建符号链接；重复执行同一条命令即可从 `main` 更新，并清理已经从本仓库删除的受管 Skill。已有同名但并非本安装器管理的目录不会被覆盖。

如果某个平台使用其他用户级 Skill 目录，通过 `AKI_SKILLS_DIR` 指定。例如 Codex 可安装到 `$CODEX_HOME/skills`（默认 `~/.codex/skills`）：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | AKI_SKILLS_DIR="${CODEX_HOME:-$HOME/.codex}/skills" bash
```

## 使用方式

安装完成后，在任意项目里可以直接调用 Skill 名称，无需再次提供 GitHub 地址。

项目首次接入个人开发原则时使用 `aki-project-bootstrap`。多轮开发后需要沉淀隐性决策和非显然约束时使用 `aki-context-sync`。

项目精简审计直接使用 `principles/simplification.md`；游戏项目同时使用 `principles/game-simplification.md`。

## 目录

```text
.
├── AGENTS.md
├── README.md
├── assets/
│   └── aki-agent-kit-social-preview.jpg
├── principles/
│   ├── project-development.md
│   ├── game-development.md
│   ├── git.md
│   ├── simplification.md
│   ├── game-simplification.md
│   └── skill-authoring.md
├── scripts/
│   └── install.sh
└── skills/
    ├── aki-project-bootstrap/
    │   ├── SKILL.md
    │   └── assets/AGENTS.md
    ├── aki-context-sync/
    │   └── SKILL.md
    ├── aki-github-readme/
    │   └── SKILL.md
    └── aki-rednote-cover/
        └── SKILL.md
```

## 维护原则

- 通用格式、发现和生态能力优先采用上游标准。
- 当前文档只表达当前有效状态；版本历史由 Git 保存。
- 修改型 Skill 保持幂等，相同输入和项目状态下第二次执行产生零 diff。
- 新内容只有在能改变 Agent 的判断、执行或验收时才进入仓库。
