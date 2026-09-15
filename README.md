# aki-agent-kit

个人 AI Agent 工作流的**增量层**：不重新发明 `AGENTS.md` 或 Agent Skills 标准，只维护我自己的开发原则和真正有差异化价值的 Skills。

![aki-agent-kit 仓库封面](assets/aki-agent-kit-social-preview.jpg)

## 定位

本仓库遵循“通用能力上游化，个人差异自己维护”的原则。

上游负责格式、发现和生态：

- `AGENTS.md` 约定：<https://github.com/agentsmd/agents.md>
- Agent Skills 规范：<https://github.com/agentskills/agentskills>
- Skill 参考实现：<https://github.com/anthropics/skills>
- OpenAI Plugin / Skill 生态：<https://github.com/openai/plugins>
- 通用软件开发工作流参考：<https://github.com/obra/superpowers>

`aki-agent-kit` 不复制这些项目已经解决的 schema、安装机制和通用开发框架，只保存个人偏好、专用工作流和需要跨项目复用的判断原则。

## 本仓库真正维护什么

### Principles

- `principles/project-development.md`：普通软件项目的个人开发基线。
- `principles/game-development.md`：独立游戏项目补充原则。
- `principles/git.md`：Git 分支、commit、合并和破坏性操作原则。
- `principles/simplification.md`：基于真实消费者证据的项目精简审计。
- `principles/game-simplification.md`：游戏项目额外从玩家路径、引擎引用和内容成本做精简审计。
- `principles/skill-authoring.md`：在 Agent Skills 标准之上的个人 Skill 内容质量规范。

### Skills

- `aki-project-bootstrap`：为项目幂等接入本仓库的个人开发原则，只维护 `AGENTS.md` 中自己的 managed region。
- `aki-context-sync`：把开发会话中真正值得长期保存的隐性上下文审计后同步进项目权威文档。
- `aki-github-readme`：生成、重写和审查 GitHub README。
- `aki-rednote-cover`：生成“城下秋草”统一视觉的小红书封面。

## 使用方式

### Skills

通过所用 Agent 平台支持的标准 Skill 安装/发现方式使用 `skills/` 下的目录。本仓库不再维护自定义 Skill registry 或平台专属分发协议。

各平台安装位置和发现机制可能不同，以平台当前文档和 Agent Skills 规范为准。

### 项目开发原则

如果希望某个项目持续使用这里的个人开发原则，可以运行 `aki-project-bootstrap`。它会在项目根 `AGENTS.md` 中维护一个很小的 managed region，并直接引用 `main` 上的 canonical principle 文件。

这里的远程引用只是个人增量机制，不属于 `AGENTS.md` 标准本身；运行环境无法读取远程文件时必须明确报告。

### 会话上下文沉淀

经过多轮开发后，使用 `aki-context-sync` 审计当前会话、代码变更和已有文档。它只保存长期有效、不易重建且会影响未来判断的信息，不保存聊天历史、纠错过程或可直接从代码得到的事实。

## 目录

```text
.
├── AGENTS.md
├── CHANGELOG.md
├── README.md
├── assets/
│   └── aki-agent-kit-social-preview.jpg
├── principles/
│   ├── project-development.md
│   ├── game-development.md
│   ├── git.md
│   ├── simplification.md
│   ├── game-simplification.md
│   └── skill-authoring.md
└── skills/
    ├── aki-project-bootstrap/
    │   ├── SKILL.md
    │   └── assets/AGENTS.md
    ├── aki-context-sync/
    │   └── SKILL.md
    ├── aki-github-readme/
    │   └── SKILL.md
    └── aki-rednote-cover/
        └── SKILL.md
```

## 维护原则

- 上游标准已经解决的问题不在本仓库再造第二套规范。
- 当前文件只表达当前有效状态；旧结构和旧规则由 Git 历史追溯。
- 修改型 Skill 必须幂等，相同输入和项目状态下第二次执行应产生零 diff。
- 影响使用方式、职责边界、兼容性或工作流的语义变化记录在 `CHANGELOG.md`。
- 新内容只有在能改变 Agent 的判断或执行时才进入仓库，避免把项目变成个人提示词垃圾场。
