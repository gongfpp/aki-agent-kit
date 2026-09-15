# Project Agent Instructions

<!-- aki-agent-kit:bootstrap:start -->
## Aki Agent Kit Bootstrap

Project profile: `{{PROJECT_PROFILE}}`

每个新会话在进行实质性规划或修改之前：

1. 读取中央规则清单：
   https://github.com/gongfpp/aki-agent-kit/blob/main/agent-rules.yaml?raw=1
2. `project` profile 加载清单中的 `project`；`game` profile 加载 `project` + `game`。
3. 需要产生 Git 修改时加载 `git`。
4. 只有在用户要求审计、精简、清理、架构收敛或删除无用复杂度时，才加载对应 simplification audit 规则。

必须实际读取成功后再声称使用了最新版规则。远程读取失败时明确指出失败项，并继续遵循本项目已有事实、契约和当前用户指令。

中央规则是通用基线，不覆盖本项目已经确认的真实契约或更高优先级指令。
<!-- aki-agent-kit:bootstrap:end -->
