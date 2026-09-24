# 独立游戏精简审计

本文件只补充 `simplification.md` 在游戏项目中的额外证据和风险，不重复通用状态、抽象、依赖和生命周期原则。

## 玩家可达性

- 先实际运行游戏并确认当前可达流程、核心循环、失败/成功和结算路径，再判断系统价值。
- 玩家真实路径无法触发的玩法、场景、按钮、事件、配置和资源优先进入精简候选；仅供 Debug、Demo、Prototype、Benchmark 或测试使用的内容需要明确开发价值。
- 核心体验正在依赖的复杂度不能仅因结构不漂亮而删除。

## 非代码引用

游戏引用可能存在于 Scene/Prefab、Resource、序列化数据、Animation、Input Map、Localization、Audio、Save Field、Group/Tag 和编辑器配置中；删除前必须检查这些引用，不能只依据代码搜索结果判断资源无用。

## 内容生产成本

玩法的长期成本同时包括代码与持续的关卡、对话、美术、动画、音频、数值、事件和测试内容。需要大量持续内容才能成立、但玩家可感知价值不足的系统，可以优先考虑删除、合并或降级，而不是继续优化实现。

## 游戏候选额外证据

除通用精简审计要求外，每个重要候选还应说明：

- **Player impact**：玩家能否感知变化；
- **Content impact**：减少或新增多少持续内容生产；
- **Save/resource risk**：存档、场景、资源和序列化引用风险；
- **Tooling impact**：编辑器工具、Debug 流程和开发场景是否受影响。

功能删除后同步清理相关 Scene、Resource、Asset、Signal、Input Map、Config、Save Field、Localization、Animation、Audio、Test、Debug UI 和设计文档，避免留下半套失效系统。
