# aki-agent-kit

面向个人 AI 开发工作流的中央规则仓库：统一维护 **Skills、AGENTS.md、开发原则、审计规则与项目初始化模板**。

![aki-agent-kit 仓库封面：AI 工作流 Skill 集，右侧为终端符号与小草视觉锚点](assets/aki-skills-social-preview.jpg)

## 核心思路

不要把同一套 Agent 规则复制到每个项目。

每个业务项目只保留一个很小的本地 `AGENTS.md` bootstrap；新会话开始时先读取中央 `agent-rules.yaml`，再按项目类型从 `main` 分支加载最新规则。

```text
业务项目 AGENTS.md
        ↓
agent-rules.yaml
        ↓
┌──────────────────────┐
│ project AGENTS.md    │
│ game AGENTS.md       │
│ Git principles       │
│ audit principles     │
└──────────────────────┘
```

这样以后更新开发原则、适配更强的模型或调整 Skill，只需要维护本仓库。

## Agent Profiles

### `agents/project/AGENTS.md`

普通软件、App、前端、后端、CLI、工具项目的通用开发原则。覆盖真实调用、最小完整改动、状态所有权、生命周期、依赖、测试与文档等基础要求。

### `agents/game/AGENTS.md`

独立游戏项目补充原则。在通用开发原则上增加玩家路径、垂直切片、游戏状态、场景资源、内容成本、存档、性能和试玩要求。

## Principles

### `principles/git-version-control.md`

统一 Git 分支、commit、合并、清理和破坏性操作原则。

### `principles/project-simplification-audit.md`

普通软件项目精简审计：寻找有真实消费者证据、能够真正删除 API、状态、生命周期、依赖和行为表面积的候选。

### `principles/indie-game-simplification-audit.md`

独立游戏精简审计：除了代码复杂度，同时从玩家路径和长期内容生产成本判断功能是否值得保留。

## Skills

### `aki-project-init-skill`

初始化或升级任意开发项目的 `AGENTS.md`。自动判断普通项目 / 游戏项目 profile，保留项目特有事实，并把通用规则接入中央 `main` 分支。

### `aki-github-readme-skill`

生成、重写和审查 GitHub 仓库 README，覆盖项目定位、首屏结构、最小运行路径、图片与社交预览、可访问性和长期维护。

### `aki-rednote-cover-skill`

生成和迭代小红书知识/工具类笔记封面，维护“城下秋草”视觉识别系统。

## 中央规则入口

分发项目优先只依赖一个稳定入口：

```text
https://github.com/gongfpp/aki-skills/blob/main/agent-rules.yaml?raw=1
```

`agent-rules.yaml` 记录当前规则 URL、加载条件和 profile 继承关系。专项审计规则默认按需加载，不占用普通开发会话上下文。

## 目录

```text
.
├── AGENTS.md
├── README.md
├── agent-rules.yaml
├── agents/
│   ├── project/
│   │   └── AGENTS.md
│   └── game/
│       └── AGENTS.md
├── principles/
│   ├── git-version-control.md
│   ├── project-simplification-audit.md
│   └── indie-game-simplification-audit.md
├── skills/
│   ├── aki-project-init-skill/
│   │   ├── SKILL.md
│   │   ├── templates/AGENTS.bootstrap.md
│   │   └── agents/openai.yaml
│   ├── aki-github-readme-skill/
│   │   ├── SKILL.md
│   │   └── agents/openai.yaml
│   └── aki-rednote-cover-skill/
│       ├── SKILL.md
│       └── agents/openai.yaml
└── assets/
```

## 使用原则

- 中央通用规则维护在本仓库 `main`；项目事实仍以各项目自己的代码、配置、契约和本地 `AGENTS.md` 为准。
- `AGENTS.md` 保存长期开发约束；`principles/` 保存单主题原则；Skill 负责需要主动执行的工作流。
- 规则按需要加载，避免为了“完整”把所有资料塞进每次对话。
- 远程规则读取失败时必须显式说明，不把缓存或猜测内容冒充最新版。
- 所有规则都应能被真实项目验证，而不是只追求形式上的架构完整。

## 说明

本仓库由“城下秋草”维护。目标是让不同 Agent、不同项目共享一套可持续更新的开发基线，同时保留项目自身的真实约束。
