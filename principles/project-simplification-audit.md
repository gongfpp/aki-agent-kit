# 项目精简审计

目标：寻找**有证据支持、能够真正删除或合并现有复杂度**的候选。宁可留下几个高置信项目，也不要堆大量薄弱猜测。

## 优先寻找

- 没有生产消费者的 API、方法、事件、配置、Helper、Package；
- 只有测试或文档使用、但并非关键契约的行为；
- 两套状态或 representation 在维护同一个事实；
- 所有实现都必须支持、但消费者根本不用的接口能力；
- 只为测试、Demo 或 Support 存在的独立层或 Package；
- 没有真实产品需求的推测性通用设计；
- 仅用于保护无用 API 的 invariant、rollback、特殊测试和防御逻辑；
- 标准库或成熟依赖已经覆盖的手写 parser、retry、glob、diff 等基础设施；
- 多套机制表达同一个 lifecycle、liveness 或 settlement 状态。

## 审计方法

先广泛扫描，不要找到第一个 unused symbol 就结束。

复杂异步代码要明确：

- 谁拥有资源；
- 谁负责释放；
- 每个 flag / sentinel / promise / cancellation / disposer 分别表达什么状态。

如果多个机制实际上表达同一个事实，优先收敛为一个 transaction 或 lifecycle controller。

## 用真实调用证明

优先使用 `rg` 搜索：

- symbol
- event
- package
- config key
- method
- wire string

然后读取真实 call site。

把消费者分成：

- **Production**：生产源码、真实 loader/config/runtime 路径；
- **Non-production**：tests、docs、README、snapshot、comments；
- **Ambiguous**：可能属于真实运行路径的 example/script，需要继续确认。

不要因为“看起来复杂”就修改。

## 放弃或降级候选

出现以下情况时通常不要删：

- 存在真实生产调用者；
- 已有设计记录明确解释该结构为什么存在；
- 删除会产生大量无关改动，却没有真正减少 API 或行为面；
- 收益正确但非常小——改成局部 TODO 即可。

## 引入依赖的判断

依赖替换只有在产生**净删除**时才算精简：

`删除的实现 + 专属测试 + 文档 > 新增 glue code 和依赖成本`

Wrapper 如果只是把同样的复杂度搬到另一个位置，不算精简。

## 输出候选

每个重要候选明确：

- **Problem**：当前复杂度及生产消费者证据；
- **Proposal**：具体删除、合并、降级或迁移什么；
- **What we give up**：删除后失去什么能力；
- **Acceptance criteria**：什么状态代表完成；
- **Risks**：行为/API 变化和风险。

代码精简时，相关测试、注释、README、JSDoc 和生成物一起收敛。

最终目标不是“代码看起来更漂亮”，而是实际减少维护中的 API、状态、生命周期、依赖和行为表面积。
