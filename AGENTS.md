# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 开发原则和专用 Skills 的增量层，不负责重新定义通用 Agent 标准。

## Upstream First

- `AGENTS.md` 的格式、发现和优先级以 <https://github.com/agentsmd/agents.md> 及各 Agent 平台实际实现为准。
- Skill 的格式和目录约定以 <https://github.com/agentskills/agentskills> 为准。
- 不为已有标准重新创建 schema、registry、安装器或平台兼容层；确实存在个人差异时才在本仓库补充。

## Repository Structure

- `principles/`：个人长期开发原则和专项判断规则。
- `skills/`：符合 Agent Skills 结构、需要主动执行的个人工作流。
- `assets/`：仓库级静态资源。
- `CHANGELOG.md`：记录影响使用方式、职责边界、兼容性或工作流的语义变化。

不要重新引入 `agent-rules.yaml`、项目类型 `agents/` registry 或默认的 `agents/openai.yaml`。平台专属元数据只有在出现真实平台功能需求时才增加。

## Skill Authoring

新增或修改 Skill 时先遵循 Agent Skills 上游规范，再遵循本仓库 `principles/skill-authoring.md`。

- Skill 名称保持短而明确；本仓库使用 `aki-` 前缀作为个人命名空间，不追加多余 `-skill` 后缀。
- 一个 Skill 解决一个可复用工作流，不把长期通用偏好、项目事实和一次性会话内容混在一起。
- Skill 以判断标准和执行方法为主，不堆案例、纠错历史和固定会话叙述。

## Principles

- 普通项目开发基线：`principles/project-development.md`
- 游戏开发补充：`principles/game-development.md`
- Git：`principles/git.md`
- 通用精简审计：`principles/simplification.md`
- 游戏精简补充：`principles/game-simplification.md`

游戏规则是普通项目规则的补充；游戏精简审计是通用精简审计的补充。不要复制相同内容形成两套长期维护规则。

## Idempotent Mutation

会创建或修改文件的 Skill 必须：

- 修改前读取已有内容和相关权威来源；
- 明确自己的所有权范围，范围外内容默认保留；
- 复用或更新等价内容，不重复追加；
- 当前事实变化时替换旧状态，不靠追加说明覆盖旧状态；
- 输入和项目状态不变时连续执行两次，第二次产生零语义差异；能使用 Git 时要求零 diff。

稳定自动维护内容可以使用 managed region，但只有拥有该 region 的 Skill 可以修改其中内容。

## Repository Evolution

当前文件只表达当前有效状态。旧路径、旧规则和被删除的自定义基础设施由 Git 历史承担追溯职责，不为了保留历史在当前目录留兼容副本。

影响 Skill 行为、规则职责、名称/路径、兼容方式或使用流程的变化记录到 `CHANGELOG.md`。

## Git

仓库修改遵循 `principles/git.md`。功能开发和较大修改使用独立分支；一个逻辑完整的改动形成可理解的 commit；验证后合并 `main`。

## Validation

修改后至少检查：

- Skill 目录名与 `SKILL.md` frontmatter `name` 一致；
- YAML frontmatter、Markdown、相对路径和远程 URL 有效；
- README 目录结构与真实仓库一致；
- 没有重新出现已删除的 custom registry、旧 Skill 名或过期路径；
- 没有无真实用途的平台专属 metadata；
- 修改型 Skill 的幂等边界明确；
- 删除或迁移内容后，Git 历史足以追溯旧状态，不保留无意义兼容尸体。

纯文本规则不机械增加无价值测试，验证重点是结构、引用、职责边界、幂等性和内容去重。
