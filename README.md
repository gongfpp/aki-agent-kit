# aki-skills

面向个人 AI 工作流与 GitHub 内容整理的可复用 Skills。

![aki-skills 仓库封面：AI 工作流 Skill 集，右侧为终端符号与小草视觉锚点](assets/aki-skills-social-preview.jpg)

## 当前包含

### `aki-rednote-cover-skill`

用于生成和迭代小红书知识/工具类笔记封面。核心识别系统是 3:4 竖版、草绿色纯底、黑字主视觉，以及个人 IP“城下秋草”。

### `aki-github-readme-skill`

用于生成、重写和审查 GitHub 仓库 README，覆盖项目定位、首屏结构、最小运行路径、图片与社交预览、可访问性和长期维护。

## 使用原则

- 先确认仓库事实，再写说明，不编造命令、指标或功能。
- 视觉素材服务于理解，不用复杂装饰替代项目证据。
- README 图片保留准确 alt 文本，并使用仓库内相对路径。
- 每个 Skill 保持小范围、可复用，并在真实使用后持续迭代。

## 目录

```text
skills/
├── aki-rednote-cover-skill/
│   ├── SKILL.md
│   └── agents/openai.yaml
└── aki-github-readme-skill/
    ├── SKILL.md
    └── agents/openai.yaml
```

## 说明

本仓库由“城下秋草”维护。两个 Skill 当前均提供中文说明，后续迭代会优先保持规则稳定、边界清晰和低维护成本。
