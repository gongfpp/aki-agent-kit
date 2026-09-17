# aki-agent-kit

个人 AI Agent 工作流的增量层：以 `AGENTS.md` 和 Agent Skills 等上游标准为基础，只维护个人开发原则、差异化 Skills，以及经过筛选的外部 Skill 安装编排。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 上游基础

- `AGENTS.md`：<https://github.com/agentsmd/agents.md>
- Agent Skills：<https://github.com/agentskills/agentskills>
- Skill 参考实现：<https://github.com/anthropics/skills>
- OpenAI Plugin / Skill：<https://github.com/openai/plugins>
- Matt Pocock Skills：<https://github.com/mattpocock/skills>
- Godot Agent / gda：<https://github.com/aigengame/godot-agent>
- 通用开发工作流参考：<https://github.com/obra/superpowers>

本仓库不复制成熟上游工作流；能直接使用的外部 Skill 由安装器从原作者仓库安装，本仓库只保留真正存在个人差异的 `aki-*` Skill。

## Principles

- `principles/project-development.md`：跨项目开发基线、判断边界和项目结构形成原则。
- `principles/game-development.md`：独立游戏项目补充，包括玩家路径、数据驱动、内容/资源职责和游戏文档语义。
- `principles/git.md`：Git 版本管理与仓库卫生原则。
- `principles/simplification.md`：通用项目精简审计。
- `principles/game-simplification.md`：游戏项目精简补充。
- `principles/skill-authoring.md`：Skill 内容质量与维护原则。

中央原则只提供跨项目默认判断，不替项目决定具体技术栈、架构模式、目录树或业务/玩法逻辑。具体项目契约和真实实现优先。

## 本仓库 Skills

- `aki-project-bootstrap`：幂等接入个人开发原则，只维护项目 `AGENTS.md` 中自己的 managed region。
- `aki-context-sync`：把真正值得长期保存的会话上下文同步进项目权威文档。
- `aki-project-readme`：生成、重写和审查项目 README。
- `aki-project-audit`：证据驱动地全面审计项目正确性、架构、安全、测试、文档和用户体验。
- `aki-open-source-audit`：仓库公开前检查敏感信息、Git 历史、许可证和第三方资产。
- `aki-game-playtest-audit`：从真实玩家路径审计游戏可玩性、反馈、节奏和失败恢复。
- `aki-grill-with-context`：使用上游 `grilling` 深度澄清决策，再由 `aki-context-sync` 把长期结论收敛进现有项目事实源。
- `aki-rednote-cover`：个人专用的小红书封面 Skill。

外部 Skill 的来源、依赖和 preset 组成统一定义在 `scripts/skills.catalog.sh`，安装器运行时读取该 catalog，不在 README 和安装逻辑里维护第二份精确清单。

## 用户级安装

无参数命令安装默认 `project` preset：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh | bash
```

### 中国大陆网络 / Clash

如果 `raw.githubusercontent.com` 或后续 GitHub clone 在当前网络下容易卡住，可以只让本次安装使用本地 Clash，不修改终端全局代理或 Git 全局配置。下面以 `7897` 为示例端口，按自己的 Clash mixed-port 修改：

```bash
(
  AKI_PROXY=http://127.0.0.1:7897
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' EXIT
  curl -fsSL --proxy "$AKI_PROXY" \
    https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
    -o "$tmp" && AKI_PROXY="$AKI_PROXY" bash "$tmp"
)
```

`AKI_PROXY` 只传给本次安装器。安装器拉取 `aki-agent-kit`、Matt Skills 和 `gda` 上游时会把代理仅作用于对应 `git clone` 命令，不写入持久化代理配置。

当前提供的 preset 面向不同场景：

- `core`：最小项目基础能力；
- `project`：普通软件项目默认集合；
- `game`：通用游戏开发能力，不绑定具体引擎；
- `godot`：在 `game` 基础上加入 Godot 自动化能力；
- `opensource`：普通项目能力加开源前审计；
- `all`：全部受管 Skill，包括个人专用项。

preset 的**精确组成以安装器当前 catalog 为准**。查看当前集合、Skill 和说明：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --list
```

选择 preset：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --set godot
```

精确选择 Skill；必要依赖会自动补齐：

```bash
curl -fsSL https://raw.githubusercontent.com/gongfpp/aki-agent-kit/main/scripts/install.sh \
  | bash -s -- --skills grill-me,handoff,aki-context-sync
```

安装器把最终选择视为受管状态：重复执行会同步已选 Skill；实际内容有变化时显示 `updated`，内容完全一致时显示 `unchanged`，此前由本安装器管理但本次未选择的 Skill 会被清理。已有同名但并非本安装器管理的目录不会被覆盖。

默认安装目录是 `~/.agents/skills`。其他平台如果使用不同目录，通过 `AKI_SKILLS_DIR` 指定。

## 使用方式

```text
使用 aki-project-bootstrap 初始化当前项目。
使用 grill-me 深度追问这个计划，直到没有隐含决策。
使用 aki-grill-with-context 深度澄清这个设计，并把长期结论同步进项目文档。
使用 aki-context-sync 收敛当前会话上下文。
使用 handoff 为下一位 Agent 生成交接。
使用 retro 复盘这次编码会话。
使用 aki-project-readme 审查并完善当前项目 README。
使用 aki-project-audit 全面审计当前项目。
使用 aki-open-source-audit 做开源前审计。
使用 aki-game-playtest-audit 从玩家路径审计当前游戏。
使用 gda 操作并验证当前 Godot 项目。
```

## 与 grill-with-docs 的边界

Matt 的 `grill-with-docs` 会组合 `grilling + domain-modeling`，并维护独立的领域上下文/决策文档体系。本仓库不直接安装它，因为这会与 `aki-context-sync` 的事实源选择和去重规则形成第二套持久化机制。

`aki-grill-with-context` 保留 `grilling` 的决策树式澄清，但把持久化阶段交给 `aki-context-sync`：只有用户确认 shared understanding 后，才把真正长期有效且难以重建的结论合并到项目已经存在的权威事实源。

## 目录

```text
.
├── AGENTS.md
├── README.md
├── assets/
├── principles/
├── scripts/
│   ├── install.sh
│   └── skills.catalog.sh
└── skills/
    ├── aki-project-bootstrap/
    ├── aki-context-sync/
    ├── aki-project-readme/
    ├── aki-project-audit/
    ├── aki-open-source-audit/
    ├── aki-game-playtest-audit/
    ├── aki-grill-with-context/
    └── aki-rednote-cover/
```

外部 Skill 只在用户级安装目录中出现，不复制进本仓库 `skills/`。

## 维护原则

- 通用格式、发现和生态能力优先采用上游标准。
- 能直接依赖成熟上游时不复制实现；只有个人行为差异才创建 `aki-*` adapter。
- preset、外部来源和 Skill-to-Skill 依赖以 `scripts/skills.catalog.sh` 为机器权威来源；`install.sh` 只负责执行安装和收敛。
- 当前文档只表达当前有效状态；版本历史由 Git 保存。
- 修改型 Skill 保持幂等，相同输入和项目状态下第二次执行产生零 diff。
- 新内容只有在能改变 Agent 的判断、执行或验收时才进入仓库。
