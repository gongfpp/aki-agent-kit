---
name: aki-grill-with-context
description: 先使用上游 grilling 深度澄清计划、设计或决策，在用户确认共同理解后，再通过 aki-context-sync 只把长期有效且值得保留的结论收敛进项目现有权威文档。
---

# aki-grill-with-context

## 目标

把 Matt Pocock 的 `grilling` 决策澄清流程与 `aki-context-sync` 的项目事实持久化规则串起来。

本 Skill 不复制 `grilling` 的访谈逻辑，也不采用 `grill-with-docs` 默认的 `CONTEXT.md + ADR` 写入方式。讨论阶段只负责把隐含决策问清；持久化阶段仍由 `aki-context-sync` 判断哪些结论值得写、应该写到哪里。

## 依赖

需要已安装：

- `grilling`：上游决策树式访谈；
- `aki-context-sync`：本仓库的上下文核验、去重与持久化。

安装器选择本 Skill 时应同时安装这两个依赖。

## 工作流

1. 调用 `grilling`，围绕当前计划、架构、玩法、产品设计或重要决策建立 design tree。
2. 事实问题由 Agent 自己通过代码、文件、工具或其他可靠来源核验；只有真实需要取舍的决策交给用户。
3. 持续推进 frontier，直到关键分支没有未声明假设。
4. 用户明确确认已经达到 shared understanding 之前，不开始实现，也不写项目长期事实。
5. 用户确认后，调用 `aki-context-sync`，把本次已经确认且通过持久化门槛的结论合并进项目现有权威文档。
6. 如果没有任何结论达到长期持久化门槛，项目文件保持不变。

## 持久化边界

- 不因为 grilling 问过一个问题就把回答全部落盘。
- 不自动创建 `CONTEXT.md`、ADR、会议纪要或会话摘要。
- 项目已有产品设计、GDD、架构、接口、目录结构或 `AGENTS.md` 等事实源时优先更新原位置。
- 可从代码、配置或目录树廉价恢复的信息不重复保存。
- 只有真正难以重建、长期有效且会影响未来判断的结论才交给 `aki-context-sync` 持久化。

## 验收

- 讨论阶段遵循上游 `grilling`，没有在 shared understanding 前直接实施；
- 持久化只通过 `aki-context-sync` 完成；
- 没有制造与项目现有事实源竞争的第二套 `CONTEXT.md` 或决策日志；
- 相同结论再次同步时不产生重复文档内容。
