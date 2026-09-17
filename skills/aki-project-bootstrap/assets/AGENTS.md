# Project Agent Instructions

<!-- aki-agent-kit:bootstrap:start -->
## Personal Development Baseline

Project profile: `{{PROJECT_PROFILE}}`

在每个新会话进行实质性规划或修改之前：

1. 读取项目开发原则：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/project-development.md?raw=1
2. 如果 profile 为 `game`，额外读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/game-development.md?raw=1
3. 一旦判断当前任务将创建、修改或删除项目文件，即形成 write intent。在 Git 仓库内，如果当前会话尚未加载 Git 原则，必须在做出具体修改承诺、制定实施性文件/分支计划或执行任何写入之前先读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/git.md?raw=1
   不要先答应修改、开始实施规划或动文件后再补读。任务完成并验证后按该原则完成本地版本管理收尾。是否 push、创建 PR 或执行其他远端操作，由当前项目指令、仓库既有流程和当次任务决定。
4. 只有在精简、清理、架构收敛或删除无用复杂度的任务中读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/simplification.md?raw=1
   如果 profile 为 `game`，同时读取：
   https://github.com/gongfpp/aki-agent-kit/blob/main/principles/game-simplification.md?raw=1

同一远程原则在当前会话成功读取后视为已加载，不因后续轮次或重复任务再次读取；只有用户要求刷新、远程入口发生变化或明确需要重新核实时才重新读取。

远程原则只有实际读取成功后才视为当前会话已加载。
读取失败时应明确报告，不得把未验证的旧内容、记忆或推测冒充当前原则。
如果该原则是当前操作的强制前置条件，则在成功读取前不得执行依赖该原则的操作。

这些内容是个人开发偏好，不覆盖项目自身的真实契约或更高优先级指令。
<!-- aki-agent-kit:bootstrap:end -->
