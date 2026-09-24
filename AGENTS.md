# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 开发原则、差异化 Skills 与少量外部 Skill 安装编排的增量层。通用标准优先采用上游，本仓库只维护真正存在个人差异和跨项目复用价值的内容。

## Upstream First

- `AGENTS.md` 的格式、发现与优先级以 <https://github.com/agentsmd/agents.md> 及各 Agent 平台实际实现为准。
- Skill 的格式与目录约定以 <https://github.com/agentskills/agentskills> 为准。
- 成熟上游 Skill 能直接满足需求时直接依赖上游；只有需要改变行为时才维护 `aki-*` Skill。

## Repository Structure

- `principles/`：跨项目长期原则和专项判断规则。
- `skills/`：本仓库维护的 `aki-*` 工作流。
- `scripts/install.sh`：用户级安装、更新和受管状态收敛。
- `scripts/skills.catalog.sh`：preset、外部来源、provider、依赖和显示信息的机器权威来源。
- `assets/`：仓库级静态资源。

具体项目的技术栈、目录树、文档名、业务或玩法设计属于项目事实，不在中央仓库维护固定模板。

## Installation

安装本仓库管理的 Skills 时使用 `scripts/install.sh`：

```bash
bash scripts/install.sh
```

没有本地 checkout 时：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

未指定集合时使用默认 `project`；preset 使用 `--set`，精确 Skill 使用 `--skills`。精确组成以 `scripts/skills.catalog.sh` 为准，可通过 `bash scripts/install.sh --list` 查看。

默认安装到 `~/.agents/skills`。安装器同时同步中央规则到 `~/.agents/aki-agent-kit/rules/`；项目优先读取本地规则缓存，缺失或用户明确刷新时才访问远端。

## Principles

- 普通项目：`principles/project-development.md`
- 游戏补充：`principles/game-development.md`
- Git：`principles/git.md`
- 通用精简：`principles/simplification.md`
- 游戏精简补充：`principles/game-simplification.md`
- Skill 编写：`principles/skill-authoring.md`

中央原则只定义跨项目默认判断，不替具体项目决定架构、目录、技术栈或业务/玩法实现。游戏原则只补充游戏独有内容，不重复通用原则。

新增或修改 Skill 时必须读取并遵循 `principles/skill-authoring.md`；幂等、managed region、内容去重和当前状态规则以该文件为准，不在本文件重复定义。

## Git

仓库修改遵循 `principles/git.md`。较大修改使用独立分支；是否 push、创建 PR、合并或执行其他远端操作由项目流程、用户指令和当前任务边界共同决定。

## Validation

修改后至少确认：

- Skill 目录名与 `SKILL.md` frontmatter `name` 一致；
- Markdown、YAML、相对路径和远程 URL 有效；
- `scripts/skills.catalog.sh` 仍是 preset、外部来源和 Skill 依赖的唯一机器权威；
- `install.sh --list` 与 catalog 一致；
- 外部 Skill 来源和许可证有效，默认 preset 不包含个人专用 Skill；
- bootstrap 模板与引用中央原则的 Skills 遵循本地缓存优先；
- 下层 Skill 没有重新定义中央 Git、项目结构或文档职责原则；
- 当前目录只保留仍会改变 Agent 行为的内容。
