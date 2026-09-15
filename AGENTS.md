# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 开发原则与专用 Skills 的增量层，以 `AGENTS.md` 和 Agent Skills 等上游规范为基础。

## Upstream First

- `AGENTS.md` 的格式、发现与优先级以 <https://github.com/agentsmd/agents.md> 及各 Agent 平台实际实现为准。
- Skill 的格式与目录约定以 <https://github.com/agentskills/agentskills> 为准。
- 本仓库只维护有个人差异和跨项目复用价值的规则与工作流。

## Repository Structure

- `principles/`：个人长期开发原则和专项判断规则。
- `skills/`：符合 Agent Skills 结构、需要主动执行的个人工作流。
- `assets/`：仓库级静态资源。

## Skill Authoring

新增或修改 Skill 时先遵循 Agent Skills 上游规范，再遵循 `principles/skill-authoring.md`。

- Skill 名使用 `aki-<short-name>` 格式。
- 一个 Skill 解决一个可复用工作流。
- Skill 以判断标准、执行方法和验收条件为主。
- 长期通用偏好进入 `principles/`，真实项目事实留在项目自己的文档。

## Principles

- 普通项目开发基线：`principles/project-development.md`
- 游戏开发补充：`principles/game-development.md`
- Git：`principles/git.md`
- 通用精简审计：`principles/simplification.md`
- 游戏精简补充：`principles/game-simplification.md`

游戏规则只补充游戏项目独有内容，避免和通用规则维护两份相同事实。

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

仓库修改遵循 `principles/git.md`。较大修改使用独立分支；逻辑完整的改动形成可理解的 commit；验证后合并 `main`。

## Validation

修改后至少检查：

- Skill 目录名与 `SKILL.md` frontmatter `name` 一致；
- YAML frontmatter、Markdown、相对路径和远程 URL 有效；
- README 目录结构与真实仓库一致；
- 所有引用指向当前存在的 canonical 文件；
- 平台专属 metadata 具有真实用途；
- 修改型 Skill 的所有权和幂等边界明确；
- 当前目录只保留仍有行为价值的内容。

纯文本规则不机械增加无价值测试，验证重点是结构、引用、职责边界、幂等性和内容去重。
