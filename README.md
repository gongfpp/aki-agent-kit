# aki-agent-kit

个人 AI Agent 工作流的增量层：以 `AGENTS.md` 和 Agent Skills 等上游标准为基础，只维护个人开发原则、差异化 Skills，以及经过筛选的外部 Skill 安装编排。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 上游基础

- `AGENTS.md`：<https://github.com/agentsmd/agents.md>
- Agent Skills：<https://github.com/agentskills/agentskills>
- Skill 参考实现：<https://github.com/anthropics/skills>
- OpenAI Plugin / Skill：<https://github.com/openai/plugins>
- Matt Pocock Skills：<https://github.com/mattpocock/skills>
- Godot Agent / gda：<https://github.com/aigengame/godot-agent>
- 通用开发工作流参考：<https://github.com/obra/superpowers>

本仓库不复制成熟上游工作流；能直接使用的外部 Skill 由安装器从原作者仓库安装，本仓库只保留真正存在个人差异的 `aki-*` Skill。

## Principles

- `principles/project-development.md`：普通软件项目开发基线，同时规定项目目录规范如何在项目本地形成和维护。
- `principles/game-development.md`：独立游戏项目补充原则，包括游戏资源与目录组织边界。
- `principles/git.md`：Git 版本管理原则。
- `principles/simplification.md`：通用项目精简审计。
- `principles/game-simplification.md`：游戏项目精简补充。
- `principles/skill-authoring.md`：Skill 内容质量与维护原则。

具体项目的目录树不放在 aki-agent-kit。简短放置规则进入项目 `AGENTS.md`；详细目录职责进入项目已有架构文档，没有合适事实源且确有长期价值时可使用 `docs/project-structure.md`。稳定后由 `aki-context-sync` 收敛，避免中央模板覆盖真实项目结构。

## 本仓库 Skills

- `aki-project-bootstrap`：幂等接入个人开发原则，只维护项目 `AGENTS.md` 中自己的 managed region。
- `aki-context-sync`：把真正值得长期保存的会话上下文同步进项目权威文档。
- `aki-project-readme`：生成、重写和审查项目 README。
- `aki-project-audit`：证据驱动地全面审计项目正确性、架构、安全、测试、文档和用户体验。
- `aki-open-source-audit`：仓库公开前检查敏感信息、Git 历史、许可证和第三方资产。
- `aki-game-playtest-audit`：从真实玩家路径审计游戏可玩性、反馈、节奏和失败恢复。
- `aki-grill-with-context`：使用上游 `grilling` 深度澄清决策，再由 `aki-context-sync` 把长期结论收敛进现有项目事实源。
- `aki-rednote-cover`：生成“城下秋草”统一视觉的小红书封面；属于个人专用 Skill，不在通用默认集合中。

## 外部 Skills

安装器直接从上游安装，不在本仓库复制维护：

- Matt Pocock：`grill-me`、`grilling`、`handoff`、`retro`、`writing-for-agents`。
- aigengame：`gda`。

`grill-me` 是用户入口，底层调用 `grilling`。`retro` 当前位于 Matt 仓库的 in-progress 区域，并依赖 `writing-for-agents`；安装器会自动补齐依赖。

`gda` Skill 需要同名 CLI 才能真正驱动 Godot。安装器检测到本机 `gda` 时优先通过 `gda skill` 生成与 CLI 版本匹配的 Skill；未检测到时安装当前官方 Skill，并提示通过 `uv tool install gda` 安装 CLI。

## 用户级安装

无参数命令固定安装推荐的 `project` 集合：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

`project` 包含：

- `aki-project-bootstrap`
- `aki-context-sync`
- `aki-project-readme`
- `aki-project-audit`
- `aki-grill-with-context`
- `grill-me` + `grilling`
- `handoff`
- `retro` + `writing-for-agents`

### core

只安装最小项目基础能力：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set core
```

### game

在 `project` 基础上增加 `aki-game-playtest-audit` 和官方 `gda`：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set game
```

### opensource

在 `project` 基础上增加 `aki-open-source-audit`：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set opensource
```

### all

安装全部本仓库与外部 Skill，包括个人专用 `aki-rednote-cover`：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set all
```

### 精确选择

通过 `--skills` 指定需要的 Skill；依赖会自动补齐：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --skills grill-me,handoff,aki-context-sync
```

查看可用集合与 Skill：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --list
```

安装器把最终选择视为受管状态：重复执行会更新已选 Skill，并清理此前由本安装器管理、但本次未选择的 Skill。已有同名但并非本安装器管理的目录不会被覆盖。

默认安装目录是 `~/.agents/skills`。其他平台如果使用不同目录，通过 `AKI_SKILLS_DIR` 指定。

## 使用方式

```text
使用 aki-project-bootstrap 初始化当前项目。
使用 grill-me 深度追问这个计划，直到没有隐含决策。
使用 aki-grill-with-context 深度澄清这个设计，并把长期结论同步进项目文档。
使用 aki-context-sync 收敛当前会话上下文。
使用 handoff 为下一位 Agent 生成交接。
使用 retro 复盘这次编码会话。
使用 aki-project-readme 审查并完善当前项目 README。
使用 aki-project-audit 全面审计当前项目。
使用 aki-open-source-audit 做开源前审计。
使用 aki-game-playtest-audit 从玩家路径审计当前游戏。
使用 gda 操作并验证当前 Godot 项目。
```

## 与 grill-with-docs 的边界

Matt 的 `grill-with-docs` 会组合 `grilling + domain-modeling`，并让 domain-modeling 维护 `CONTEXT.md` 和 ADR。本仓库不直接安装它，因为这会与 `aki-context-sync` 的事实源选择和去重规则形成第二套持久化机制。

`aki-grill-with-context` 保留 `grilling` 的决策树式澄清，但把持久化阶段替换为 `aki-context-sync`：只有用户确认 shared understanding 后，才把真正长期有效且难以重建的结论写入项目现有 `AGENTS.md`、架构文档、GDD、接口文档或其他权威事实源。

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
    ├── aki-grill-with-context/
    └── aki-rednote-cover/
```

外部 Skill 只在用户级安装目录中出现，不复制进本仓库 `skills/`。

## 维护原则

- 通用格式、发现和生态能力优先采用上游标准。
- 能直接依赖成熟上游时不复制实现；只有个人行为差异才创建 `aki-*` adapter。
- 当前文档只表达当前有效状态；版本历史由 Git 保存。
- 修改型 Skill 保持幂等，相同输入和项目状态下第二次执行产生零 diff。
- 新内容只有在能改变 Agent 的判断、执行或验收时才进入仓库。
