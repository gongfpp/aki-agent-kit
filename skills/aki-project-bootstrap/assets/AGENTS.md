# 项目 Agent 指令

<!-- aki-agent-kit:bootstrap:start -->
## 个人开发基线

项目 profile： `{{PROJECT_PROFILE}}`

中央规则本地缓存目录：`~/.agents/aki-agent-kit/rules/principles/`  
远程回退目录：`https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/principles/`

读取中央原则时统一遵循以下顺序：

- 先读取本地缓存中的同名文件；本地文件存在时直接使用，不为了“确认是否最新”额外访问远端。
- 只有本地文件不存在，或用户明确要求刷新中央原则时，才读取远程同名文件。
- 远程读取成功后，若本机可写，立即创建缓存目录并保存为对应本地文件；用户要求刷新时覆盖旧缓存。若缓存写入失败，可以继续使用本次已读取内容，但应说明缓存未能保存。
- 安装或更新 `aki-agent-kit` 时会同步刷新这份本地缓存，因此日常新会话不需要主动检查远端版本。

在每个新会话进行实质性规划或修改之前：

1. 读取 `project-development.md`。
2. 如果 profile 为 `game`，额外读取 `game-development.md`。
3. 一旦判断当前任务将创建、修改或删除项目文件，即形成 write intent。在 Git 仓库内，如果当前会话尚未加载 Git 原则，必须在做出具体修改承诺、制定实施性文件/分支计划或执行任何写入之前先读取 `git.md`。不要先答应修改、开始实施规划或动文件后再补读。任务完成并验证后按该原则完成本地版本管理收尾。是否 push、创建 PR 或执行其他远端操作，由当前项目指令、仓库既有流程和当次任务决定。
4. 只有在精简、清理、架构收敛或删除无用复杂度的任务中读取 `simplification.md`；如果 profile 为 `game`，同时读取 `game-simplification.md`。

同一原则在当前会话已经成功读取后视为已加载，不因后续轮次或重复任务再次读取；只有用户要求刷新、缓存文件被删除或明确需要重新核实时才重新加载。

这些内容是个人开发偏好，不覆盖项目自身的真实契约或更高优先级指令。
<!-- aki-agent-kit:bootstrap:end -->
