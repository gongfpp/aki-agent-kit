# Project Agent Instructions

<!-- aki-agent-kit:bootstrap:start -->
## Personal Development Baseline

Project profile: `{{PROJECT_PROFILE}}`

在每个新会话进行实质性规划或修改之前：

1. 读取项目开发原则：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/project-development.md?raw=1
2. 如果 profile 为 `game`，额外读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/game-development.md?raw=1
3. 在 Git 仓库内，当前会话第一次执行会写入项目文件的任务前读取 Git 原则：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/git.md?raw=1
   任务完成并验证后按该原则完成本地版本管理收尾。是否 push、创建 PR 或执行其他远端操作，由当前项目指令、仓库既有流程和当次任务决定。
4. 只有在精简、清理、架构收敛或删除无用复杂度的任务中读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/simplification.md?raw=1
   如果 profile 为 `game`，同时读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/game-simplification.md?raw=1

同一远程原则在当前会话成功读取后视为已加载，不因后续轮次或重复任务再次读取；只有用户要求刷新、远程入口发生变化或明确需要重新核实时才重新读取。

必须实际读取成功后再声称使用了最新版原则。远程读取失败时明确指出失败项，并继续遵循当前项目已有事实、契约和用户指令。

这些内容是个人开发偏好，不覆盖项目自身的真实契约或更高优先级指令。
<!-- aki-agent-kit:bootstrap:end -->
