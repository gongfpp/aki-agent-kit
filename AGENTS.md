# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 开发原则、差异化 Skills 与精选外部 Skill 安装编排的增量层，以 `AGENTS.md` 和 Agent Skills 等上游规范为基础。

## Upstream First

- `AGENTS.md` 的格式、发现与优先级以 <https://github.com/agentsmd/agents.md> 及各 Agent 平台实际实现为准。
- Skill 的格式与目录约定以 <https://github.com/agentskills/agentskills> 为准。
- 成熟上游 Skill 能直接满足需求时由安装器直接从原作者仓库安装，不复制到本仓库 `skills/`。
- 本仓库只维护有个人差异和跨项目复用价值的原则、adapter 与工作流。

## Repository Structure

- `principles/`：个人长期开发原则和专项判断规则。
- `skills/`：需要本仓库自行维护的 `aki-*` 差异化工作流。
- `scripts/install.sh`：用户级 Skill 安装与收敛执行器。
- `scripts/skills.catalog.sh`：preset、外部 Skill 来源、provider、依赖和显示信息的 canonical catalog。
- `assets/`：仓库级静态资源。

具体项目的目录树、文档名和实现架构属于项目事实，不在本仓库维护固定模板。中央原则只规定跨项目判断标准和信息状态；项目自己的稳定约束由项目 `AGENTS.md`、设计/架构文档或其他现有事实源承载。

## Skill Installation

当用户要求安装本仓库管理的 Skills，且没有明确指定其他安装方式时，使用 `scripts/install.sh` 作为 canonical 安装入口。安装器同时把根 `AGENTS.md` 和 `principles/` 同步到 `~/.agents/aki-agent-kit/rules/`，作为跨会话复用的本地规则缓存。

如果当前已经位于本仓库 checkout 中，执行：

```bash
bash scripts/install.sh
```

如果用户只提供了本仓库地址、当前没有本地 checkout，可执行：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

用户没有指定集合时使用默认 `project`，不要额外询问。用户指定 preset 时使用 `--set`；明确指定 Skill 时使用 `--skills`，不要自动扩大到其他 preset。

preset 的精确组成、外部 Skill 列表、依赖和 provider 不在本文件重复维护；需要当前事实时在 checkout 中运行：

```bash
bash scripts/install.sh --list
```

机器权威来源是 `scripts/skills.catalog.sh`。

外部 Skill 保持原始名称和上游实现，不改名成 `aki-*`；安装时保留来源与许可证。安装执行细节由 `install.sh` 负责，catalog 不实现文件复制或网络流程。

项目和本仓库 Skills 需要中央原则时，优先读取 `~/.agents/aki-agent-kit/rules/principles/` 中的同名文件。本地缓存存在时不为确认最新版本额外访问 GitHub；只有缓存缺失或用户明确要求刷新时才使用远程回退，成功后尽量写回本地缓存。安装器重新运行时会同步刷新缓存。

默认安装到用户级 `~/.agents/skills`。用户或目标平台明确要求其他 Skill 目录时，通过 `AKI_SKILLS_DIR` 指定。安装、更新和受管 Skill 收敛都复用同一脚本；所选最终集合代表受管状态，未被选择的受管 Skill 会被清理。

## Skill Authoring

新增或修改本仓库 Skill 时先遵循 Agent Skills 上游规范，再遵循 `principles/skill-authoring.md`。

- 本仓库自有 Skill 名使用 `aki-<short-name>` 格式；外部 Skill 保留上游名称。
- 一个 Skill 解决一个可复用工作流。
- Skill 以判断标准、执行方法和验收条件为主。
- 长期通用偏好进入 `principles/`，真实项目事实留在项目自己的文档。
- 只有本仓库确实改变了上游行为时才创建薄 adapter；单纯 URL 跳转不构成新的 `aki-*` Skill。

## Principles

- 普通项目开发基线：`principles/project-development.md`
- 游戏开发补充：`principles/game-development.md`
- Git：`principles/git.md`
- 通用精简审计：`principles/simplification.md`
- 游戏精简补充：`principles/game-simplification.md`
- Skill 编写：`principles/skill-authoring.md`

游戏规则只补充游戏项目独有内容，避免和通用规则维护两份相同事实。除安全、数据完整性和不可逆操作等硬边界外，中央原则是默认判断规则，不要求已有合理项目为了符合中央风格而重构。

## Idempotent Mutation

会创建或修改文件的 Skill 必须：

- 修改前读取已有内容和相关权威来源；
- 明确自己的所有权范围，范围外内容默认保留；
- 复用或更新等价内容，不重复追加；
- 当前事实变化时直接收敛到最新状态；
- 输入和项目状态不变时连续执行两次，第二次产生零语义差异；能使用 Git 时要求零 diff。

稳定自动维护内容可以使用 managed region，只有拥有该 region 的 Skill 可以修改其中内容。

## Current State

当前文件只表达当前有效规则和结构。版本演进由 Git 提交历史承担。

## Git

仓库修改遵循 `principles/git.md`。较大修改使用独立分支；逻辑完整的改动形成可理解的 commit。是否 push、创建 PR、合并或执行其他远端操作同时服从本仓库当前工作流和 Git 原则，不由任一 Skill 自行重定义。

## Validation

修改后至少检查：

- 本仓库 Skill 目录名与 `SKILL.md` frontmatter `name` 一致；
- YAML frontmatter、Markdown、相对路径和远程 URL 有效；
- README 目录结构与真实仓库一致；
- 所有引用指向当前存在的 canonical 文件；
- bootstrap 模板和引用中央原则的 Skills 均遵循“本地缓存优先、缺失才远程回退”，且安装器能同步生成 `~/.agents/aki-agent-kit/rules/`；
- `scripts/skills.catalog.sh` 是 preset、外部来源和 Skill 依赖的唯一机器权威，`install.sh` 不重复维护这些清单；
- `install.sh --list` 与 catalog 一致，安装说明不硬编码已经能从 catalog 得到的精确组成；
- 外部 Skill 的上游来源、依赖和许可证仍有效；
- 默认安装集合不包含个人专用 Skill；
- 平台专属 metadata 具有真实用途；
- 修改型 Skill 的所有权和幂等边界明确；
- 下层 Skill 不重新定义中央 Git、项目结构或文档职责原则；
- 当前目录只保留仍有行为价值的内容。

纯文本规则不机械增加无价值测试，验证重点是结构、引用、职责边界、依赖、幂等性和内容去重。
