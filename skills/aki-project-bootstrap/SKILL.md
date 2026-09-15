---
name: aki-project-bootstrap
description: 幂等地为新项目或已有项目建立最小 AGENTS.md 接入层，让项目按类型读取 aki-agent-kit 的个人开发原则，同时保留项目原有指令。
---

# aki-project-bootstrap

## 目标

为项目建立一个小而稳定的本地 `AGENTS.md` managed region。它只负责接入本仓库的个人开发原则，不定义 `AGENTS.md` 标准，也不维护项目长期事实。

`AGENTS.md` 的发现和优先级由所用 Agent 平台及 AGENTS.md 生态决定；本 Skill 只生成项目内的个人增量指令。

开发过程中需要把会话中的隐性上下文沉淀到项目文档时，使用 `aki-context-sync`。

## 项目类型

根据真实仓库选择 profile：

- `project`：普通软件、App、服务、前端、后端、CLI 和工具项目；
- `game`：具有真实游戏引擎工程结构或玩家运行路径的项目。

不要仅根据仓库名、说明文字或未来计划判断。

## Canonical Principles

注入项目的 canonical principle URL 以 `assets/AGENTS.md` 为唯一模板来源。

- `project` 每个新会话读取项目开发原则；
- `game` 在此基础上读取游戏开发补充；
- 产生 Git 修改时读取 Git 原则；
- 只有精简、清理、架构收敛或删除无用复杂度的任务读取精简审计；游戏项目同时读取游戏精简补充。

修改原则路径时只更新模板，并验证模板中的全部 URL。

## 所有权

本 Skill 只拥有根 `AGENTS.md` 中：

`<!-- aki-agent-kit:bootstrap:start -->`

到

`<!-- aki-agent-kit:bootstrap:end -->`

之间的内容。

region 外已有内容属于项目本身，不重写、重新排序或格式化。项目构建命令、架构事实、业务契约和环境限制保留在本地项目文档中。

模板位于 `assets/AGENTS.md`。项目没有 `AGENTS.md` 时使用模板创建最小文件；已有文件时只插入或更新 managed region。

## 工作流

1. 读取现有 `AGENTS.md`、仓库结构和与项目指令直接相关的文档。
2. 判断 `project` 或 `game` profile。
3. 读取模板并验证当前 profile 需要的 principle URL。
4. 检查 managed region：不存在则插入一份；存在且配对正确则只更新 region 内部。
5. 对能够明确识别为本 Skill 管理的旧 bootstrap 内容进行收敛，项目特有内容全部保留。
6. 检查没有重复 region、重复原则正文或失效 URL。
7. 用相同输入再次计算目标结果，第二次必须与第一次完全一致。

## 冲突与失败

- 出现多个 region、标记缺失配对或嵌套时，不猜测所有权范围，停止自动重写并报告冲突。
- 本地项目契约与个人通用原则冲突时，以真实项目契约和更高优先级指令为准。
- 远程原则读取失败时明确指出失败项，不把缓存或猜测内容冒充最新版。
- 原则更新只影响 managed region，不改动 region 外项目内容。

## 验收

完成后必须满足：只有一个合法 managed region；原有项目内容完整保留；region 由 profile 和模板唯一决定；相同状态再次执行 Git diff 为空。
