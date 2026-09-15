# 独立游戏项目精简审计

目标：寻找**有真实项目证据支持，并且能够真正减少开发、内容生产和维护成本**的候选。

宁可最后只找到几个确定应该删除或合并的东西，也不要因为“感觉这里有点复杂”就大规模重构。

最终判断标准只有两个：

1. 玩家实际体验有没有受损；
2. 项目以后是不是更容易继续做。

## 优先寻找

重点检查这些东西：

- 已经没有任何真实玩家路径能够触发的玩法、场景、按钮、事件、配置和资源；
- 只有 Debug、Demo、旧原型或测试场景还在使用的系统；
- UI、Player、GameManager、关卡场景、存档各维护一份相同状态；
- 为一个实现专门设计了一整套 Interface、Manager、Factory、Registry；
- 所有实现都被迫支持，但实际玩法根本不会使用的能力；
- 为“以后可能有多人模式 / Mod / DLC / 大地图 / 大量角色”提前建设的通用架构；
- 已经被废弃玩法留下的兼容逻辑、状态 Flag、特殊分支、调试工具和配置；
- 引擎已经成熟提供，却仍然自己维护的 Tween、事件系统、资源加载、对象池、序列化等基础设施；
- 多套机制同时表达同一个游戏状态；
- 一项玩法带来的开发成本明显超过玩家能够感知到的价值；
- 一个系统本身已经做完，但继续使用它需要长期制作大量专属美术、动画、数值或关卡内容；
- 为一个非常简单的行为使用复杂状态机、事件总线或多层抽象。

例如：

```text
Player.is_dead
GameState.player_dead
HUD.show_game_over
Level.failed
```

如果四个状态实际上都只是在表达：

```text
玩家已经死亡
```

这里通常就存在值得收敛的状态设计。

## 审计时先看真实游戏，再看代码

不要先打开代码寻找“看起来不漂亮”的地方。

先实际跑游戏，把当前真实流程写清楚：

```text
启动
↓
主菜单
↓
进入游戏
↓
核心循环
↓
失败 / 成功
↓
结算
↓
下一轮
```

然后确认每个系统到底在哪一段被玩家真正使用。

一个设计在代码层面非常优雅，如果整个玩家流程根本碰不到它，仍然应该进入删除候选。

## 广泛扫描，不要找到一个 unused 就结束

先扫描整个项目：

```text
scripts/
scenes/
resources/
assets/
autoload/
ui/
data/
save/
addons/
```

然后搜索：

- class / symbol；
- scene / prefab；
- resource；
- signal / event；
- input action；
- config key；
- save key；
- animation name；
- group / tag；
- wire string；
- feature flag。

代码项目可以优先使用：

```bash
rg "symbol"
rg "signal_name"
rg "config_key"
rg "scene_name"
```

Godot 项目还要同时注意 `.gd`、`.tscn`、`.tres`、`.godot` 等引用。

不要因为脚本里搜不到引用就直接删资源。

场景、序列化资源、动画轨道和编辑器配置同样可能建立引用。

## 把使用者分成三类

### Player Path

真实游戏运行过程中玩家能够进入的路径。

例如：

```text
Main Menu
Combat
Inventory
Shop
Level Generation
Save / Load
Game Over
```

这是最高优先级证据。

### Development Only

只服务开发过程：

```text
Test Scene
Debug Panel
Prototype
Benchmark
Editor Tool
Temporary Cheat
```

这类东西可以存在，但必须明确知道它为什么存在。

如果一个“临时 Debug 工具”半年以后还挂在正式项目里，就应该重新判断。

### Ambiguous

例如：

```text
example/
experimental/
old/
prototype/
support/
legacy/
```

看起来可能没有用，但需要确认。

不要仅凭目录名字删除。

## 复杂状态系统必须画清楚状态所有权

遇到复杂异步逻辑、战斗状态、场景切换、AI、任务系统时，明确回答：

- 谁拥有状态；
- 谁能够修改；
- 谁只是观察；
- 谁创建资源；
- 谁负责释放；
- Signal 谁连接；
- Timer 谁启动；
- Coroutine / async 谁负责结束；
- 每个 bool / enum / sentinel 到底代表什么。

如果看到：

```text
is_loading
load_finished
loading_task
cancel_loading
load_token
loading_state
```

先不要继续修。

先确认这些东西是不是实际上都在表达一个：

```text
LoadingTransaction
```

如果是，就优先收敛。

## 重点查重复状态

独立游戏项目做久以后，非常容易出现：

```text
Player.hp
HUD.hp
SaveData.hp
GameManager.player_hp
```

正确方向通常是：

```text
PlayerState.hp
   ↓
Gameplay
UI
Save
Audio / VFX
```

UI 不应该自己维护 HP。

存档系统也不应该变成第二个游戏状态管理器。

存档负责保存和恢复权威状态。

## 重点查“为了以后”存在的代码

看到下面这些理由时要特别敏感：

> 以后可能做多人。
>
> 以后可能支持 Mod。
>
> 以后可能有 100 种武器。
>
> 以后可能换引擎。
>
> 以后可能做 DLC。

这些未来确实有可能发生。

但如果当前项目只有：

```text
1 个玩家
12 种武器
20 个房间
单机游戏
```

就优先服务这个规模。

未来真实出现需求的时候再抽象，通常比现在猜未来便宜。

## 从内容成本反向审计功能

独立游戏还有一种代码审计经常漏掉的东西：

**系统维护成本很低，但内容维护成本极高。**

例如做了一个“NPC 好感度系统”。

代码只有 600 行，看起来并不复杂。

但它要求：

```text
20 个 NPC
×
5 个关系阶段
×
专属对话
×
事件
×
立绘
×
结局
```

真正产生的是几个月内容工作量。

所以审计功能时，同时问：

```text
这个系统未来需要多少内容才能看起来不像半成品？
```

如果成本远大于玩家体验收益，删除整个系统可能比优化代码更有效。

## 判断抽象有没有价值

看到下面这种结构：

```text
IWeapon
BaseWeapon
WeaponFactory
WeaponRegistry
WeaponProvider
WeaponManager
Sword
```

先查看项目实际有多少种实现。

如果只有：

```text
Sword
Gun
```

而且行为差异很小，就需要判断这些抽象到底解决了什么真实问题。

抽象存在的理由应该来自已经发生的变化，而不是想象中的变化。

## 引入插件或依赖的判断

使用成熟插件只有在产生**净删除**时才算精简：

```text
删除的代码
+
删除的专属测试
+
删除的维护文档
+
减少的维护风险

>

新增 glue code
+
插件升级成本
+
学习成本
+
兼容成本
```

如果原来有：

```text
CustomDialogueSystem
1800 行
```

换插件以后变成：

```text
DialoguePluginAdapter
900 行
+
插件配置
+
特殊兼容
+
大量 Override
```

那只是把复杂度换了一个位置。

## 放弃或降级候选

出现下面情况时通常不要删：

- 玩家真实核心路径正在使用；
- 删除后明显损害核心体验；
- 已有设计记录明确解释这个结构解决了什么问题；
- 当前复杂度来自真实玩法复杂度，本身没有明显重复；
- 删除会牵扯大量内容，却几乎没有减少长期维护面；
- 系统已经稳定，而且未来基本不需要继续修改；
- 收益存在但很小。

最后这种情况直接留：

```text
TODO: revisit after vertical slice
```

通常就够了。

## 每个重要候选都要说清楚

### Problem

当前复杂度是什么。

并给出真实证据，例如：

```text
该 InventoryCache 只有 DebugInventoryScene 调用，
正式游戏路径没有消费者。
```

### Proposal

明确准备：

```text
删除
合并
降级
迁移
内联
数据化
```

什么东西。

### Player Impact

玩家会不会看到变化。

例如：

```text
无玩家可见变化。
```

或者：

```text
失去武器耐久度系统。
```

### What We Give Up

删除以后失去什么未来能力。

例如：

```text
以后如果需要 Mod，需要重新增加动态注册机制。
```

这没有关系，明确知道代价即可。

### Acceptance Criteria

例如：

```text
删除 WeaponRegistry；
武器仍然可以装备、攻击、掉落和存档；
正式流程没有新的报错；
代码只剩一个权威武器状态来源。
```

### Risks

明确：

- 存档兼容；
- 资源引用；
- 场景引用；
- 玩家行为变化；
- 数值变化；
- 内容丢失；
- 编辑器工具失效。

## 删除功能时要一起收尾

代码删掉以后，同时检查：

```text
Scene
Resource
Asset
Signal
Input Map
Config
Save Field
Localization
Animation
Audio
Test
Debug UI
Comment
README
Design Doc
```

不要出现：

> 功能删了，但项目里还留着半套尸体。

## 最后的判断标准

项目精简的目标不是：

```text
代码更漂亮
文件更少
架构更高级
```

真正要减少的是：

```text
玩家无法感知的系统
重复游戏状态
无用玩法规则
特殊分支
生命周期
维护接口
无价值内容生产
未来承诺
开发者脑内负担
```

如果删除 1000 行代码以后，项目依然需要理解同样多的状态和规则，那基本没有真正变简单。

如果只删除 100 行，却让：

```text
一个状态只有一个 Owner
一个玩法只有一种实现路径
一个功能少维护一整套内容
```

那才是有效的精简。
