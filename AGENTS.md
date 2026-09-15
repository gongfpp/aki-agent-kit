# aki-agent-kit Repository Instructions

本仓库是个人 AI Agent 规则、Skills、项目初始化模板和可复用开发原则的中央来源。

## Repository Structure

- `skills/`：可显式调用、具有具体工作流的 Skill。
- `agents/`：项目类型级的长期 Agent 开发原则。
- `principles/`：可以被 Agent 或 Skill 引用的单一主题规则；较长、较专项的规则优先放这里。
- `agent-rules.yaml`：远程规则注册表，是分发项目 bootstrap 的稳定入口。
- `assets/`：README、Skill 等需要的静态资源。

## Canonical Source

中央规则以 `main` 分支内容为最新生效版本。分发到其他项目时，不复制整套中央规则；优先通过 `agent-rules.yaml` 和项目本地小型 bootstrap 动态读取。

修改中央文件路径、规则 ID 或加载条件时：

1. 同步更新 `agent-rules.yaml`；
2. 检查 `aki-project-init-skill` 与 bootstrap 模板；
3. 检查 README；
4. 验证所有中央 URL 可读取。

## Skill Design

- 一个 Skill 解决一个可复用工作流，不把所有个人偏好堆进同一个 Skill。
- `SKILL.md` 描述触发范围、输入事实、执行流程、修改边界和输出要求。
- 项目级长期约束优先进入 `AGENTS.md`；专项审计、Git 规则等进入 `principles/`；需要主动执行的初始化、生成、审查流程才做成 Skill。
- Skill 不应假装平台具备不存在的能力。涉及远程 instructions、文件发现、工具权限时，采用可验证的能力，并保留平台无该能力时的降级路径。

## Agent Rule Design

- `agents/project/AGENTS.md` 是普通开发项目基线。
- `agents/game/AGENTS.md` 在普通开发基线上增加独立游戏项目约束。
- 通用规则保持稳定；真实项目特有的构建命令、目录职责、业务契约和环境限制留在各项目自己的 `AGENTS.md`。
- 长篇专项规则按需加载，避免每个新会话无条件占用上下文。

## Git

仓库修改遵循：

https://github.com/gongfpp/aki-skills/raw/refs/heads/main/principles/git-version-control.md

较大修改使用独立分支；完成验证后合并到 `main`，再删除完成分支。

## Validation

文档/规则修改至少检查：

- Markdown/YAML 基本语法；
- 相对路径和远程 URL；
- `agent-rules.yaml` 中的规则 ID 与实际文件一致；
- README 目录结构与真实仓库一致；
- Skill 的引用没有指向已删除或重命名的文件。

不要为纯文本规则机械增加无价值测试；验证重点是引用关系、可访问性和规则之间没有明显冲突。
