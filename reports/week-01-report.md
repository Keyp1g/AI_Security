# 第 1 周学习周报

> 范围：Day 1–7 的 LLM、Prompt、System Prompt、幻觉、偏见、安全对齐与 Jailbreak 基础。
> 证据规则：文件存在、格式完成、概念掌握和实验通过分别判断；待实测样例不计为通过。

## 1. 本周学习范围

本周从 AI 安全攻击面和个人能力基线开始，建立了 `Prompt -> Tokenize -> 上下文与指令 -> 模型推理 -> Decode -> Response` 的基础链路；随后学习 Prompt 设计与指令边界、幻觉与偏见核验、Prompt 工程流程化、安全对齐、Jailbreak、Prompt Injection 概念差异，以及拒答质量和应用层控制。

核心证据入口：

- `notes/day-01-foundation.md`
- `notes/day-02-llm-basics.md`
- `notes/day-03-prompt-and-instructions.md`
- `notes/day-04-hallucination-bias.md`
- `notes/day-05-prompt-workflow.md`
- `notes/day-06-jailbreak-theory.md`
- `notes/week-01-glossary.md`
- `notes/week-01-inventory.md`

## 2. 已掌握或已有稳定证据的内容

| 内容 | 当前状态 | 证据与边界 |
|---|---|---|
| LLM、Prompt、System Prompt 基础 | 能解释并能指向实验 | `labs/day-02-output-comparison.md`、`labs/day-03-prompt-variants.md`；不表示掌握模型内部全部机制 |
| 幻觉核验 | 能复现低风险测试流程 | `labs/day-04-fact-checking.md`、`reports/day-04-hallucination-run.jsonl`；只代表本地小样本 |
| 偏见 A/B 测试 | 能复现测试流程 | `reports/day-04-fairness-run.jsonl`；不能用单次差异宣布系统性偏见 |
| Prompt 模板迭代 | 能复现两轮实验与评分 | `labs/day-05-template-evaluation.md`、`reports/day-05-template-run-v0-1.jsonl`、`reports/day-05-template-run-v0-2.jsonl`；v0.2 仍有失败 |
| Jailbreak 防护验证 | 能复现 18 条本地低风险测试 | `labs/day-06-jailbreak-safety-evaluation.md`、`reports/day-06-jailbreak-safety-run.jsonl`；没有测试第三方或真实工具 |
| Jailbreak 与 Prompt Injection 区分 | 已有主动回忆和分类练习证据 | `notes/day-06-jailbreak-basics.md`；Prompt Injection 专门实验尚未开始 |

## 3. 已复现实验

1. Day 2：同一 Prompt 多次输出、长短上下文和指令清晰度对比。
2. Day 3：Prompt 质量 20 条全部实测，以及背景/目标/约束单变量观察；结果为通过 8、部分通过 8、不通过 4。
3. Day 4：10 条幻觉样例与 5 组 A/B 公平性测试，共 20 个实际响应。
4. Day 5：四类模板 12 条用例，v0.1/v0.2 两轮共 24 次运行。
5. Day 6：18 条 Jailbreak 低风险防护验证，包含 `assist`、`refuse` 和 `clarify`。

实验完成表示流程和失败证据已保存，不表示模型通过所有测试。Day 5 v0.2 为 1 条通过、7 条部分通过、4 条失败；Day 6 为 6 条通过、9 条部分通过、3 条不通过。

## 4. 用例统计与质量

依据 `cases/llm-security/week-01-case-audit.md`：

| 指标 | 数量 | 解释 |
|---|---:|---|
| 逻辑测试输入 | 80 | 去除设计稿、作品表和日志对同一 ID 的重复引用；A/B 按两个实际输入计 |
| 已实测 | 80 | 全部逻辑输入均有真实模型输出和判定 |
| 待实测 | 0 | Day 3 原10条待实测已完成本地补测 |
| 严格格式不完整 | 0 | Day 2、Day 4 A/B 与 Day 5 的原32条结构缺口已修补 |

数量目标已经超过 50 条，80 条均已实测且结构字段完整；但结构完整不等于测试通过，仍须保留部分通过、不通过和待复测状态。

## 5. 主要风险理解

- 模型输出是概率性生成的候选内容，不是事实、权限或审批结果。
- System/Developer Prompt 用于表达行为期望，不能代替会话身份、对象级授权、参数允许列表和服务端阻断。
- 幻觉核验必须区分可核验、待核验、冲突和错误；自信语气不是证据。
- 公平性差异必须控制变量并重复评估；单次 A/B 差异只是候选信号。
- Jailbreak 关注模型内容/行为安全边界，Prompt Injection 关注应用指令与数据边界；两者可以重叠。
- 正确拒答、过度拒答、不足拒答、合理帮助和主动澄清必须分别评价。

### 模型输出与应用安全控制的差别

模型可以生成分类、建议、结构化请求或看似授权的文字，但这些都只是输入给应用的一个不可信信号。真实系统必须在模型外依据会话身份、资源归属、工具允许列表、参数 Schema、敏感操作审批和审计策略决定是否展示、写入或执行。Prompt 表达期望，应用控制强制边界。

## 6. 未完成项与薄弱点

- 20 题已在对话中逐题完成并保留纠错轨迹：12 题首次通过，8 题经补答或纠正后通过，最终 20/20；不能宣称首次全部答对。
- Day 3 已全部实测，但 8 条部分通过、4 条不通过的修复方案尚未复测。
- Day 4 A/B 已拆分输入级独立 ID，仍需增加重复运行和统计比较。
- Day 5 的 12 条正式记录已合入 `cases`，但 v0.2 的 4 条失败和 7 条部分通过仍需 v0.3 复测。
- Token/上下文窗口诊断、证据状态边界、工具授权范围和公平性 A/B 目标变量仍需复练。
- Prompt Injection、RAG 和 Agent 工具控制尚未完成专门实验。

## 7. 第 2 周依赖

- 全部实验继续使用本地、虚构数据和模拟工具，不连接真实业务或第三方服务。
- 外部文档、网页、邮件、检索片段和工具返回统一视为不可信输入。
- 需要固定应用规则、来源标签、输出 Schema、服务端授权模拟和审计日志字段。
- 需要把输入、输出、工具调用和阻断原因分开保存，保持原始证据不可被修订覆盖。
- 环境和目录设计见 `reports/week-02-preparation.md`。

## 8. 三个可验证目标

1. **Prompt Injection**：在 Day 8 本地模拟问答/摘要流程中建立 20 条唯一编号用例；每条含来源、期望、实际/待实测、判定和证据，不向第三方投递注入内容。
2. **RAG**：使用 5 篇干净文档和 5 篇虚构不可信文档验证来源标签、检索范围与引用；任何未运行项保持“待实测”。
3. **Agent**：使用至少 3 个模拟工具验证工具允许列表、参数 Schema、对象级授权和高影响操作确认；不接入真实工具或凭据。

## 9. Day 7 当前验收状态

- 文件产出：统一术语表、自测题、用例审计、周报和第 2 周准备清单均已创建并可复核。
- 自测闭环：20/20 题完成原始作答、针对性补答或纠正、最终判定与回查路径。
- 结论：Day 7 实质任务与后续缺口修补均已完成；80 条已实测和结构完整仍不等于全部通过或生产系统安全。

## 10. 17:00–18:00 周末复盘

### 用例数量与状态分布

- 逻辑测试输入：80，超过总计划至少 50 条的数量目标。
- 已实测：80；待实测：0；严格格式不完整：0。
- Day 6 的 18 条结果为通过 6、部分通过 9、不通过 3。
- 80 条是输入总数，不是通过数；待实测和格式不完整是不同维度。

### 作品质量与结构缺口

1. Day 2 的结构字段已补齐；`LLM-002-06` 的上下文丢失候选仍需分层复测。
2. Day 3 的 20 条已全部运行；4 条不通过和 8 条部分通过需要保留基线后复测。
3. Day 4 的输入级 ID 已修补；公平性结论仍需要多 seed 重复和统计比较。
4. Day 5 的正式记录已合入；v0.3 应优先处理机械冲突、必填项和 Schema 校验。
5. 原始响应、失败和部分通过均保留；后续修补不得覆盖首次证据，也不为提高通过率删除失败样本。

### Day 8 入口与安全边界

- 入口文件：`notes/day-08-prompt-injection.md`、`labs/day-08-direct-injection.md`、`labs/day-08-indirect-injection.md`、`cases/llm-security/prompt_injection_cases.md`。
- 环境入口：`labs/week-02/documents/`、`labs/week-02/simulator/`、`labs/week-02/tool-stubs/`、`labs/week-02/logs/`。
- Day 8 只在本地模拟问答或摘要流程中观察 Prompt Injection 防护；外部文档和工具返回全部视为不可信输入。
- 不连接第三方服务、真实业务、真实工具或凭据；模型输出不直接产生文件、网络、数据库、邮件或命令副作用。

### 复盘签收

- [x] 已记录总用例数和状态分布。
- [x] 已记录作品质量与结构缺口，没有以数量替代证据质量。
- [x] Day 8 入口、文件和本地安全边界明确。
- [x] 20 题最终结果和真实薄弱点已回写术语表与周报。
