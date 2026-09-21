---
name: aki-project-bootstrap
description: 幂等地为新项目或已有项目建立最小 AGENTS.md 接入层，让项目按类型读取 aki-agent-kit 的个人开发原则，同时保留项目原有指令。
---

# aki-project-bootstrap

## 目标

为项目建立一个小而稳定的根 `AGENTS.md` managed region，只负责接入中央开发原则，不维护项目业务、架构或长期事实。

项目中的规则读取、缓存与远程回退策略以 `assets/AGENTS.md` 模板为唯一来源；本 Skill 不重复定义其正文。

## 项目类型

根据真实仓库选择 profile：

- `project`：普通软件、App、服务、前端、后端、CLI 和工具项目；
- `game`：具有真实游戏引擎工程结构或玩家运行路径的项目。

不要仅根据仓库名、说明文字或未来计划判断。

## 所有权

本 Skill 只拥有根 `AGENTS.md` 中：

`<!-- aki-agent-kit:bootstrap:start -->`

到

`<!-- aki-agent-kit:bootstrap:end -->`

之间的内容。

region 外内容属于项目本身，不重写、重新排序或格式化。模板位于 `assets/AGENTS.md`。

## 工作流

1. 读取现有 `AGENTS.md`、仓库结构和与项目指令直接相关的文档。
2. 本 Skill 会写项目文件；在 Git 仓库中先按中央 write-intent 与 Git 原则完成前置检查，再继续规划或写入。
3. 根据真实项目判断 `project` 或 `game` profile。
4. 读取模板并生成目标 managed region；项目没有 `AGENTS.md` 时创建最小文件，已有文件时只插入或更新 region。
5. region 外若存在与 managed region 语义等价的中央 boilerplate，只移除能够安全确认的重复；项目特有内容全部保留。
6. 检查 region 唯一、标记配对、模板引用有效，并用相同输入再次计算结果，第二次应零 diff。
7. 按中央 Git 原则完成本地版本管理收尾；远端操作服从项目流程和当次任务边界。

## 冲突与失败

- 多个 region、标记缺失配对或嵌套时，不猜测所有权范围，停止自动重写并报告冲突。
- 项目契约与中央通用原则冲突时，以真实项目契约和更高优先级指令为准。
- 模板要求的中央原则在本地缓存和远程回退都无法读取时，按模板定义的失败规则处理，不把记忆或推测冒充当前原则。

## 验收

只有一个合法 managed region；region 外项目内容完整保留；profile 与模板决定唯一目标结果；重复执行零 diff；Git 仓库中的写入已按中央 Git 原则收尾。
