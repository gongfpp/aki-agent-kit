# Changelog

本文件只记录会影响使用方式、职责边界、兼容性或工作流的语义变化。逐文件修改和完整时间线由 Git 历史保存。

## 2026-09-15 — Standards alignment refactor

### Changed

- 将仓库重新定位为上游标准之上的个人增量层，不再维护自己的 Agent/Skill 基础标准。
- 删除自定义 `agent-rules.yaml` 与 `agents/project|game` registry；项目与游戏开发规则迁移到 `principles/`。
- `aki-project-bootstrap` 改为直接引用 canonical principles，不再经过中央 registry 中转。
- Skill 名称统一去掉多余 `-skill` 后缀，保留 `aki-` 个人命名空间。
- bootstrap 模板迁移到标准 Skill 的 `assets/` 目录。
- 通用与游戏精简审计改成“基础规则 + 游戏补充”，删除重复内容。
- `principles/skill-authoring.md` 改为只补充个人内容质量规则，Skill 格式明确以上游 Agent Skills 规范为准。

### Removed

- 删除所有默认 `agents/openai.yaml`；平台专属 metadata 以后只在出现真实需求时添加。
- 删除旧 `aki-*-skill` 路径和旧 registry/agent profile 文件；历史通过 Git 追溯，不保留兼容副本。

## 2026-09-15 — Initial kit consolidation

### Added

- 建立普通项目与独立游戏两套中央开发规则。
- 增加 Git、普通项目精简审计和独立游戏精简审计原则。
- 增加 `principles/skill-authoring.md`，约束 Skill 的指导性、职责边界、幂等修改和内容审计。
- 增加 context sync 工作流，用于将开发会话中长期有效但尚未持久化的上下文审计后合并进项目权威文档。

### Changed

- 仓库从以 Skills 为主扩展为统一维护 Skills、AGENTS.md、Principles 和项目 bootstrap 的 `aki-agent-kit`。
- 项目初始化能力重构为幂等 bootstrap，只拥有 `AGENTS.md` 中的 managed region。
- 修改型 Skill 增加幂等要求：相同输入和项目状态下重复执行，第二次应产生零语义差异。
- README 与小红书封面 Skill 从会话/案例驱动收敛为指导和判断标准优先。
- 仓库内部引用统一为 `gongfpp/aki-agent-kit` canonical 地址。

### Fixed

- 清理仓库改名后遗留的旧 URL 和旧 Skill 名引用。
- 社交预览资源路径同步为 `aki-agent-kit` 命名。
