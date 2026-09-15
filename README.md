# aki-agent-kit

面向个人 AI 开发工作流的中央规则仓库：统一维护 **Skills、AGENTS.md、开发原则、审计规则与项目 bootstrap**。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 核心思路

中央仓库维护长期通用规则，业务项目只保留自己的真实事实和一个很小的本地 bootstrap。

```text
业务项目 AGENTS.md
        ↓
agent-rules.yaml
        ↓
project / game AGENTS.md
        +
Git principles
        +
按需 audit principles
```

这样中央原则和 Skill 可以持续演进，而不需要把同一份规则复制到每个项目中。

项目开发过程中产生、但尚未写入项目文档的重要会话上下文，由 `aki-context-sync-skill` 负责审计和沉淀；它不会把聊天记录直接变成项目记忆。

## Agent Profiles

### `agents/project/AGENTS.md`

普通软件、App、前端、后端、CLI 和工具项目的通用开发原则，覆盖事实确认、最小完整改动、状态所有权、生命周期、依赖、测试和文档。

### `agents/game/AGENTS.md`

独立游戏项目补充原则，在通用基线上增加玩家路径、垂直切片、游戏状态、场景资源、内容成本、存档、性能和试玩要求。

## Principles

### `principles/git-version-control.md`

统一 Git 分支、commit、合并、清理和破坏性操作原则。

### `principles/project-simplification-audit.md`

普通软件项目精简审计，寻找有真实证据、能够减少 API、状态、生命周期、依赖和行为表面积的候选。

### `principles/indie-game-simplification-audit.md`

独立游戏项目精简审计，同时从玩家路径、代码复杂度和长期内容生产成本判断功能是否值得保留。

### `principles/skill-authoring.md`

约束本仓库所有 Skill 的编写方式：指导优先、职责单一、修改幂等、避免案例堆积和会话级残留。

## Skills

### `aki-project-bootstrap-skill`

为新项目或已有项目幂等建立 `AGENTS.md` bootstrap。它只维护自己的 managed region，保留项目原有内容，并接入中央最新规则。

### `aki-context-sync-skill`

审计当前开发会话与项目事实，把尚未持久化、未来仍有价值且不易从代码直接重建的上下文，去重、清理后合并进已有权威文档。相同输入重复执行应产生零 diff。

### `aki-github-readme-skill`

生成、重写和审查 GitHub README，重点处理项目定位、最小使用路径、视觉素材、可访问性和长期维护。

### `aki-rednote-cover-skill`

生成和迭代“城下秋草”知识/工具类封面，保持固定视觉识别，并分别生成 3:4、2.35:1 和 1:1 三个独立比例。

## 中央规则入口

分发项目只需要固定一个入口：

```text
https://github.com/gongfpp/aki-agent-kit/blob/main/agent-rules.yaml?raw=1
```

`agent-rules.yaml` 记录当前规则 URL、加载条件和 profile 继承关系。专项审计规则按需加载，不无条件占用普通开发上下文。

## 项目接入与后续沉淀

新项目或已有项目首次接入时使用 `aki-project-bootstrap-skill`。它负责建立稳定的远程规则入口，不拥有项目其他文档。

后续经过多轮开发后，需要把会话中的隐性决策和非显然约束持久化时使用 `aki-context-sync-skill`。它优先更新已有权威文档，只有确实没有合适位置时才创建 `docs/project-context.md`。

两者都遵循幂等原则：在输入和项目状态不变时再次执行，不应继续追加、改写或重新排序稳定内容。

## 演进记录

当前文件始终表达当前有效状态。低层修改历史由 Git 保存；影响使用方式、职责边界、兼容性和工作流的语义变化记录在 `CHANGELOG.md`。

仓库自身的 Skill 编写与修改遵循 `principles/skill-authoring.md`，避免随着迭代不断积累只对旧会话有意义的说明。

## 目录

```text
.
├── AGENTS.md
├── CHANGELOG.md
├── README.md
├── agent-rules.yaml
├── agents/
│   ├── project/AGENTS.md
│   └── game/AGENTS.md
├── principles/
│   ├── git-version-control.md
│   ├── project-simplification-audit.md
│   ├── indie-game-simplification-audit.md
│   └── skill-authoring.md
├── skills/
│   ├── aki-project-bootstrap-skill/
│   │   ├── SKILL.md
│   │   ├── templates/AGENTS.bootstrap.md
│   │   └── agents/openai.yaml
│   ├── aki-context-sync-skill/
│   │   ├── SKILL.md
│   │   └── agents/openai.yaml
│   ├── aki-github-readme-skill/
│   │   ├── SKILL.md
│   │   └── agents/openai.yaml
│   └── aki-rednote-cover-skill/
│       ├── SKILL.md
│       └── agents/openai.yaml
└── assets/
    └── aki-agent-kit-social-preview.jpg
```

## 使用原则

- 中央通用规则维护在 `main`；项目事实仍以各项目自己的代码、配置、契约和本地文档为准。
- `AGENTS.md` 保存长期 Agent 工作约束，`principles/` 保存单主题规则，Skill 负责需要主动执行的工作流。
- 修改型 Skill 必须先读取、再合并，不能强制覆盖已有内容。
- 当前文档不保存已经失效的历史状态；需要追溯时使用 Git 与 `CHANGELOG.md`。
- 远程规则读取失败时必须显式说明，不把缓存或猜测内容冒充最新版。
