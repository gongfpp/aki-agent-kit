---
name: aki-project-handoff
description: 为新 Session、其他 Agent 或开发者快速重建当前项目的最小工作上下文，基于仓库事实生成可执行的接管简报，不默认创建新的持久化记忆文件。
---

# aki-project-handoff

## 目标

让新的 Session、Agent 或开发者在不过度读取整个历史会话的情况下，快速理解“这个项目是什么、当前做到哪里、本任务应从哪里继续”。

本 Skill 生成的是**临时接管上下文**，不是长期事实库。默认只在当前回复中输出 handoff brief，不创建 `handoff.md`、日志或记忆文件。

## 与 aki-context-sync 的边界

- `aki-context-sync`：把未来仍需长期保留、且项目尚未表达的事实写回权威文档；
- `aki-project-handoff`：从当前项目事实中提取本次接管需要的最小上下文。

结束长会话时，如果存在尚未持久化的重要决策，应先使用 `aki-context-sync`；handoff 不负责替代长期文档。

## 信息来源

按当前任务相关性读取：

- 根 `AGENTS.md` 和适用的项目指令；
- README、架构/设计/GDD、接口和部署文档；
- 当前分支、工作区状态、最近相关 commits；
- 构建、运行、测试入口；
- 当前任务直接相关的模块、调用路径、配置和测试；
- 当前会话中已经确认但尚未结束的任务状态。

不为了“完整”读取无关历史或整仓所有文件。

## 工作流

1. 判断当前是“新 Session 接管”还是“当前 Session 向下一位交接”。
2. 确认当前目标、Git 状态和最相关的项目事实源。
3. 读取足够代码和文档，区分已验证事实、未验证假设和待办。
4. 删除可忽略的会话过程、失败尝试和已经解决的纠错历史。
5. 输出能够直接开始下一步工作的最小 brief。

## 输出结构

只保留对接管有行为价值的内容：

- **Project**：一句话项目定位与当前阶段；
- **Current objective**：当前真正要完成什么；
- **Current state**：已经完成和仍未完成的边界；
- **Relevant files/modules**：本任务最相关的文件、模块和职责；
- **Constraints**：不能违反的契约、环境和项目规则；
- **Git state**：当前分支、未提交改动和最近相关提交；
- **Verification**：已确认可用的构建/测试/运行入口；
- **Blockers / unknowns**：真正阻碍继续工作的未知项；
- **Next actions**：最多几个最合理的下一步。

没有内容的部分不硬填。

## 质量要求

- 项目事实优先于会话记忆；
- 不把“可能”“应该是”写成已确认事实；
- 不重复 README 或 AGENTS 中与当前任务无关的大段内容；
- 不把已解决的错误过程带进下一 Session；
- brief 应足够短，使新 Agent 能先工作，再按需深入读取。

## 持久化

默认不修改项目文件。

如果用户要求把 handoff 中的长期事实写回项目，应改用或联动 `aki-context-sync`，把内容合并到真实权威文档，而不是创建永久交接日志。

## 与 Superpowers 协作

本 Skill 独立可用。

Superpowers 的 `writing-plans`、`executing-plans` 和 `subagent-driven-development` 解决的是计划与执行阶段的任务交接；本 Skill 负责的是项目级 / Session 级上下文接管，两者可以串联使用但职责不同。
