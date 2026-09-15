# Changelog

本文件记录会影响使用方式、职责边界、兼容性或工作流的语义变化。逐文件修改、精确时间线和历史正文由 Git 提交记录，不在这里重复维护。

## 2026-09-15

### Added

- 建立 `agents/project` 与 `agents/game` 两套中央项目规则，并通过 `agent-rules.yaml` 统一分发。
- 增加 Git、普通项目精简审计和独立游戏精简审计原则。
- 增加 `principles/skill-authoring.md`，统一约束 Skill 的指导性、职责边界、幂等修改和内容审计。
- 增加 `aki-context-sync-skill`，用于将开发会话中长期有效但尚未持久化的上下文审计后合并进项目权威文档。

### Changed

- 仓库从以 Skills 为主扩展为统一维护 Skills、AGENTS.md、Principles 和项目 bootstrap 的 `aki-agent-kit`。
- `aki-project-init-skill` 重构并重命名为 `aki-project-bootstrap-skill`；改为只拥有 `AGENTS.md` 中的 managed region，不再强制重写项目其他内容。
- 所有修改型 Skill 增加幂等要求：相同输入和项目状态下重复执行，第二次应产生零语义差异。
- `aki-github-readme-skill` 改为指导和判断标准优先，减少固定模板与无必要重写。
- `aki-rednote-cover-skill` 去除固定会话依赖，收敛为稳定视觉规则和三比例独立输出契约。
- 中央规则与仓库内部引用统一使用 `gongfpp/aki-agent-kit` 当前 canonical 地址。

### Fixed

- 清理仓库改名后遗留的 `gongfpp/aki-skills` URL 和旧 Skill 名引用。
- 将仓库社交预览资源路径同步为 `aki-agent-kit` 命名。
