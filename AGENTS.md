# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 规则、Skills、项目初始化模板和可复用开发原则的中央来源。

## Repository Structure

- `skills/`：可显式调用、具有具体工作流的 Skill。
- `agents/`：项目类型级的长期 Agent 开发原则。
- `principles/`：可被 Agent 或 Skill 引用的单一主题规则。
- `agent-rules.yaml`：远程规则注册表，是分发项目 bootstrap 的稳定入口。
- `CHANGELOG.md`：记录会影响使用方式、职责边界、兼容性或工作流的语义变化。
- `assets/`：README、Skill 等需要的静态资源。

## Canonical Source

中央规则以 `main` 分支内容为最新生效版本。分发到其他项目时，不复制整套中央规则；优先通过 `agent-rules.yaml` 和项目本地小型 bootstrap 动态读取。

修改中央文件路径、规则 ID 或加载条件时，同步检查：

1. `agent-rules.yaml`；
2. `aki-project-bootstrap-skill` 与 bootstrap 模板；
3. README 与仓库自身 `AGENTS.md`；
4. 所有中央 URL 是否可读取；
5. 是否存在仍引用旧名称、旧路径或旧仓库地址的内容。

## Skill Design

新增或修改 Skill 前遵循：

https://github.com/gongfpp/aki-agent-kit/blob/main/principles/skill-authoring.md?raw=1

Skill 以指导性内容为主，描述目标、边界、判断标准、工作流、修改策略和验收条件。不要把会话记录、纠错过程、临时方案或大量案例当作长期规则。

## Idempotent Mutation

会创建或修改项目文件的 Skill 必须幂等：

- 修改前读取已有内容并识别现有权威来源；
- 明确自己拥有的内容范围，保留范围外内容；
- 合并等价信息，不重复追加；
- 更新当前事实，而不是通过新增段落覆盖旧事实；
- 输入和项目状态不变时连续执行两次，第二次应产生零语义差异；能检查 Git diff 时要求零 diff；
- 无法安全判断合并边界时显式报告，不强制整文件覆盖。

稳定的自动维护内容优先使用 managed region；只有拥有该 region 的 Skill 可以重写其中内容。

## Agent Rule Design

- `agents/project/AGENTS.md` 是普通开发项目基线。
- `agents/game/AGENTS.md` 在普通开发基线上增加独立游戏项目约束。
- 通用规则保持稳定；真实项目特有的构建命令、目录职责、业务契约和环境限制留在各项目自己的文档。
- 长篇专项规则按需加载，避免每个新会话无条件占用上下文。

## Repository Evolution

仓库当前文件表达当前有效状态；历史不通过在正文中保留废弃内容来维持。

完整低层演进由 Git 历史保存。影响 Skill 行为、规则职责、路径/名称、兼容方式或初始化流程的变化同步记录到 `CHANGELOG.md`。功能开发和较大修改使用独立分支，以逻辑完整的 commit 形成可审查记录，通过检查后再合并 `main`。

重命名 Skill 或文件时更新所有仓库内引用。没有明确兼容需求时删除旧路径，让 Git 历史承担追溯职责，不保留两套并行 canonical 文件。

## Git

仓库修改遵循：

https://github.com/gongfpp/aki-agent-kit/blob/main/principles/git-version-control.md?raw=1

## Validation

文档、规则和 Skill 修改至少检查：

- Markdown/YAML 基本语法；
- 相对路径和远程 URL；
- `agent-rules.yaml` 中的规则 ID 与实际文件一致；
- README 目录结构与真实仓库一致；
- Skill 引用没有指向已删除或重命名的文件；
- 没有遗留 `gongfpp/aki-skills` 或已废弃 Skill 名等过期 canonical 引用；
- 修改型 Skill 明确幂等策略，并能解释第二次执行为什么不会产生新差异。

不要为纯文本规则机械增加无价值测试；验证重点是引用关系、当前状态一致性、幂等性和规则之间没有明显冲突。
