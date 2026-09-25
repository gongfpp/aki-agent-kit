# aki-agent-kit

个人 AI Agent 开发工作流的增量层：维护跨项目开发原则、个人差异化 Skills，以及精选外部 Skills 的安装编排。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

默认安装 `project` preset 到 `~/.agents/skills`。安装时会把中央规则同步到 `~/.agents/aki-agent-kit/rules/`；后续新会话优先读取本地缓存，只有对应文件不存在时才访问 GitHub。

## 包含内容

### 原则

- `project-development.md`：跨项目开发基线与判断边界。
- `game-development.md`：独立游戏项目补充原则。
- `git.md`：Git 版本管理与仓库卫生。
- `simplification.md` / `game-simplification.md`：项目精简审计。
- `skill-authoring.md`：Skill 编写原则。

### Skill 列表

- `aki-project-bootstrap`：为项目接入开发原则。
- `aki-context-sync`：把长期有效的会话结论收敛进项目事实源。
- `aki-handoff`：生成和接管短暂、可核验的 Agent 交接上下文。
- `aki-project-readme`：生成、重写和审查项目 README。
- `aki-project-audit`：全面审计普通工程项目的正确性、架构、安全、测试、文档和用户体验。
- `aki-open-source-audit`：开源前审计敏感信息、历史、许可证和第三方资产。
- `aki-game-audit`：结合真实玩家路径和游戏工程结构全面审计游戏项目。
- `aki-grill-with-context`：用自包含的决策树式追问澄清计划，并在确认后同步长期结论。
- `aki-rednote-cover`：个人专用的小红书封面 Skill。

安装器还会在 `godot` preset 中安装 Godot 自动化 Skill `gda`。

## 预设

- `core`：最小项目基础能力。
- `project`：普通软件项目默认集合。
- `game`：通用游戏开发能力。
- `godot`：`game` + Godot 自动化能力。
- `opensource`：项目能力 + 开源前审计。
- `all`：全部受管 Skills。

## 使用

```text
使用 aki-project-bootstrap 初始化当前项目。
使用 aki-grill-with-context 深度澄清这个设计，并在确认后同步长期结论。
使用 aki-context-sync 收敛当前会话上下文。
使用 aki-handoff 为下一位 Agent 生成交接，或核验已有 handoff 后继续任务。
使用 aki-project-readme 审查并完善当前项目 README。
使用 aki-project-audit 全面审计当前普通工程项目。
使用 aki-open-source-audit 做开源前审计。
使用 aki-game-audit 全面审计当前游戏项目。
使用 gda 操作并验证当前 Godot 项目。
```
