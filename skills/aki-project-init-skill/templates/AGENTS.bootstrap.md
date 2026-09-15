# Project Agent Bootstrap

> 本文件只保存稳定的 bootstrap 与项目特有事实。通用开发规则由中央仓库维护，不复制到本项目。

## Session Bootstrap

每个**新会话**开始、在进行实质性规划或修改代码之前：

1. 先读取中央规则清单：
   - https://github.com/gongfpp/aki-skills/blob/main/agent-rules.yaml?raw=1
2. 根据 `Project Profile` 从清单中读取对应的最新规则：
   - `project`：加载 `project`；
   - `game`：加载 `project` + `game`；
   - 需要产生 Git 改动时加载 `git`。
3. 只有在用户要求审计、精简、清理、架构收敛、删除无用复杂度等任务时，才加载对应的 simplification audit 规则。

不要因为 URL 出现在本文就假定内容已经加载。必须实际读取成功后再应用。

如果当前环境无法访问网络或规则读取失败，明确指出失败项，不要声称已加载最新版；随后继续遵循本文件中的项目事实和当前用户指令。

## Project Profile

`{{PROJECT_PROFILE}}`

可选值：`project` / `game`。

## Project Facts

<!-- 由初始化 Skill 根据真实仓库填写。这里只放项目特有、长期稳定且未来会影响 Agent 行为的事实。 -->

{{PROJECT_FACTS}}

## Project-Specific Rules

<!-- 只写不能放进中央通用规则的项目约束，例如特定构建顺序、目录职责、部署限制、协议兼容要求。 -->

{{PROJECT_RULES}}

## Verification

{{VERIFICATION_COMMANDS}}

## Instruction Priority

发生冲突时按以下顺序处理：

1. 平台 system / developer 等更高优先级约束；
2. 用户当前明确指令；
3. 本项目已确认的事实、契约和本文件中的项目特有规则；
4. 中央 GitHub 通用规则；
5. Agent 默认偏好。

中央规则用于提供通用开发基线，不覆盖项目真实契约。
