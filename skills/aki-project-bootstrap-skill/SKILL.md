---
name: aki-project-bootstrap-skill
description: 幂等地为新项目或已有项目建立/升级 AGENTS.md bootstrap，接入 aki-agent-kit 中央规则，同时保留项目原有的本地指令和事实。
---

# aki-project-bootstrap-skill

## 目标

为开发项目建立一个小而稳定的本地 `AGENTS.md` bootstrap，使每个新会话能够从 `aki-agent-kit` 的 `main` 分支读取最新中央规则。

本 Skill 只负责规则体系接入和 bootstrap 生命周期，不负责持续维护项目事实。开发过程中需要把会话上下文沉淀到项目文档时，使用 `aki-context-sync-skill`。

## 中央入口

唯一稳定入口：

https://github.com/gongfpp/aki-agent-kit/blob/main/agent-rules.yaml?raw=1

项目只固定这个入口。规则文件的具体路径、加载条件和继承关系由中央清单维护。

## 项目类型

初始化前根据真实仓库判断 profile：

- 具有明确游戏引擎工程结构或真实游戏运行路径时使用 `game`；
- 其他软件、App、服务、前端、后端、CLI、工具项目使用 `project`。

不要仅根据仓库名、说明文字或未来计划判断 profile。

## 所有权

本 Skill 只拥有根 `AGENTS.md` 中以下 managed region：

`<!-- aki-agent-kit:bootstrap:start -->`

到

`<!-- aki-agent-kit:bootstrap:end -->`

之间的内容。

region 外的已有内容属于项目本身，默认不得重写、重新排序或格式化。项目自己的构建命令、架构事实、业务契约、环境限制和其他长期约束继续保留在本地文档中。

如果 `AGENTS.md` 不存在，可以创建最小文件；除 bootstrap 外只写从仓库已经确认、且确实需要 Agent 每次工作都知道的本地指令。不要为了填满模板生成项目事实。

## 工作流

1. 读取现有 `AGENTS.md`、仓库结构、构建与测试入口，以及与项目指令直接相关的文档。
2. 判断 `project` 或 `game` profile。
3. 读取中央 `agent-rules.yaml`，确认当前 profile 所需规则以及 Git 规则可以访问。
4. 检查根 `AGENTS.md` 中 managed region 的状态。
5. 不存在 region 时，在不破坏已有内容的前提下插入一个 region；已存在且配对正确时，只更新 region 内部。
6. 对旧版 bootstrap 进行迁移时，只移除能够明确识别为中央通用 boilerplate 的部分；任何项目特有内容都保留。
7. 验证生成后的文件没有重复中央规则、重复 region 或失效 URL。
8. 用同一输入再次计算目标结果；第二次结果必须与第一次完全一致。

## Managed Region 内容

region 保持确定性和最小化，只承担：

- 声明当前项目 profile；
- 要求每个新会话实际读取中央规则清单；
- 声明 profile 对应的中央规则加载方式；
- 在产生 Git 修改时加载中央 Git 原则；
- 在专项审计任务中按需加载对应审计规则；
- 远程读取失败时要求明确报告，而不是把缓存或猜测冒充最新规则。

不要把中央规则正文复制到 region 中。

## 冲突与异常

- 同一文件存在多个 managed region、标记缺失配对或发生嵌套时，不猜测所有权范围；报告冲突并停止自动重写相关区域。
- 本地项目事实与中央通用规则冲突时，以真实项目契约和更高优先级指令为准，不通过删除项目事实解决冲突。
- 已有等价 bootstrap 时复用并规范化，不再追加第二份。
- 不因为中央规则更新而重写 region 外项目内容。

## 幂等验收

本 Skill 的硬性验收条件：

- 第一次执行后只有一个合法 managed region；
- 原有项目内容完整保留，除非用户明确要求修改；
- region 内容由当前 profile 和中央入口唯一决定；
- 在项目状态、profile 和中央入口不变时再次执行，Git diff 必须为空；
- 已有项目升级与新项目初始化最终使用同一套 canonical bootstrap 格式。

## 输出

完成后只需说明识别出的 profile、创建或更新的 `AGENTS.md`、是否发生旧版迁移、中央 URL 连通性和幂等检查结果。不要额外生成一次性的初始化报告文件。
