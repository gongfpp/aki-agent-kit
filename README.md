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
- `aki-context-sync`：把真正值得长期保存的会话上下文同步进项目权威文档。
- `aki-project-readme`：生成、重写和审查项目 README。
- `aki-project-audit`：证据驱动地全面审计项目正确性、架构、安全、测试、文档和用户体验。
- `aki-open-source-audit`：仓库公开前检查敏感信息、Git 历史、许可证和第三方资产。
- `aki-game-playtest-audit`：从真实玩家路径审计游戏可玩性、反馈、节奏和失败恢复。
- `aki-project-handoff`：为新 Session、其他 Agent 或开发者生成最小项目接管上下文。
- `aki-rednote-cover`：生成“城下秋草”统一视觉的小红书封面；属于个人专用 Skill，不在通用默认集合中。

## 用户级安装

无参数命令固定安装推荐的 `project` 集合，不会进入交互选择：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

`project` 包含：

- `aki-project-bootstrap`
- `aki-context-sync`
- `aki-project-readme`
- `aki-project-audit`
- `aki-project-handoff`

其他集合通过参数显式选择。

### core

最小项目基础能力：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set core
```

包含 `aki-project-bootstrap` + `aki-context-sync`。

### project

软件项目推荐集合，与无参数命令等价：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set project
```

### game

在 `project` 基础上增加游戏试玩审计：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set game
```

### opensource

在 `project` 基础上增加开源前审计：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set opensource
```

### all

安装仓库内全部 Skill，包括个人专用的 `aki-rednote-cover`：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set all
```

### 精确选择

通过 `--skills` 指定最终受管 Skill 集合：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --skills aki-project-bootstrap,aki-context-sync,aki-open-source-audit
```

查看可用集合与 Skill：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --list
```

安装器把所选集合视为最终受管状态：重复执行会更新已选 Skill，并清理此前由本安装器管理、但本次未选择的 Skill。已有同名但并非本安装器管理的目录不会被覆盖。

默认安装目录是 `~/.agents/skills`，适用于 Codex 当前 USER scope。其他平台如果使用不同目录，通过 `AKI_SKILLS_DIR` 指定。

## 使用方式

安装完成后，在任意项目里可以直接调用已安装的 Skill 名称，无需再次提供 GitHub 地址。

常用调用：

```text
使用 aki-project-bootstrap 初始化当前项目。
使用 aki-context-sync 收敛当前会话上下文。
使用 aki-project-readme 审查并完善当前项目 README。
使用 aki-project-audit 全面审计当前项目。
使用 aki-open-source-audit 做开源前审计。
使用 aki-game-playtest-audit 从玩家路径审计当前游戏。
使用 aki-project-handoff 接管或交接当前项目。
```

项目精简审计底层规则仍由 `principles/simplification.md` 提供；游戏项目同时使用 `principles/game-simplification.md`。

## 与 Superpowers 的边界

本仓库不复制 Superpowers 已经成熟覆盖的 brainstorming、plans、TDD、systematic debugging、code review、worktree、subagent execution、verification 和 branch finishing 等通用流程。

`aki-project-audit` 等 Skill 可以在已安装 Superpowers 时调用相关能力作为补充，但自身仍保持独立可用，避免把本仓库变成只有外部 URL 的跳转层。

## 目录

```text
.
├── AGENTS.md
├── README.md
├── assets/
├── principles/
├── scripts/
│   └── install.sh
└── skills/
    ├── aki-project-bootstrap/
    ├── aki-context-sync/
    ├── aki-project-readme/
    ├── aki-project-audit/
    ├── aki-open-source-audit/
    ├── aki-game-playtest-audit/
    ├── aki-project-handoff/
    └── aki-rednote-cover/
```

## 维护原则

- 通用格式、发现和生态能力优先采用上游标准。
- 当前文档只表达当前有效状态；版本历史由 Git 保存。
- 修改型 Skill 保持幂等，相同输入和项目状态下第二次执行产生零 diff。
- 新内容只有在能改变 Agent 的判断、执行或验收时才进入仓库。
