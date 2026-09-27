# 第 1 周学习盘点（Day 1–6）

> 对应计划：Day 7，第 1 时段（Day 1–6 证据盘点）
> 判定原则：文件存在不等于掌握；“能复现”必须能指向输入、环境、实际输出、判定和证据。没有专门实验的主题只标为“了解”或“待学习”。

## 1. 状态口径

- `待学习`：还没有可靠定义或实验。
- `了解`：能解释概念边界，但没有专门实验或复现证据。
- `能复现`：已有可运行输入/脚本、真实输出、判定规则和证据文件。
- `能独立完成`：能自行设计、执行、分析和形成报告；本周暂不作此认定。

## 2. Day 1–6 盘点表

| 天数 | 概念与当前理解 | 定义/笔记来源 | 实验或用例证据 | 状态 | 明确缺口 | 下周动作 |
|---|---|---|---|---|---|---|
| Day 1 | AI 安全覆盖模型、数据、应用、工具和输出；传统认证、授权与隔离仍然有效 | `notes/day-01-foundation.md` | `reports/day-01-review.md` | 了解 | HTTP 身份状态、Embedding 和 AI 数学尚未补齐；Day 1 复盘仅部分通过 | 后续按总计划补基础，不在本日扩张范围 |
| Day 2 | LLM 按 Token 处理上下文并概率性生成；上下文、参数和指令会改变输出 | `notes/day-02-llm-basics.md` | `labs/day-02-output-comparison.md`、`reports/day-02-ollama-test-log.md`、`labs/run-day02-output-comparison.ps1` | 能复现 | 长上下文失败尚不能区分位置效应、干扰、工程裁剪与模型行为；RLHF 细节需复习 | 复测时记录真实 Token、截断位置和上下文组成 |
| Day 3 | System/Developer 约束产品行为，User 表达当前任务，外部内容默认是数据；Prompt 不是权限边界 | `notes/day-03-prompt-and-instructions.md` | `labs/day-03-prompt-variants.md`、`reports/day-03-prompt-quality-run.jsonl`、`reports/day-03-prompt-variants-run.jsonl` | 能复现 | 20 条设计中仍有 10 条待实测；指令层级不能代替服务端授权 | 补测待实测 ID，并保持应用层 Schema 与对象级授权 |
| Day 4 | 幻觉是与事实、上下文或证据不一致的生成；公平性差异必须排除随机性和格式因素后再判断 | `notes/day-04-hallucination-bias.md` | `reports/day-04-hallucination-run.jsonl`、`reports/day-04-fairness-run.jsonl`、`labs/day-04-fact-checking.md` | 能复现 | 单模型、单次运行、5 对公平性样本不足以证明系统性偏见；A/B 输入缺少独立唯一 ID | 拆分 A/B ID，多 seed 重复并用结构化字段比较 |
| Day 5 | Prompt 工程应先固定目标、输入、状态、Schema、验收和失败处理，再单变量迭代 | `notes/day-05-prompt-workflow.md` | `labs/day-05-template-evaluation.md`、`reports/day-05-template-run-v0-1.jsonl`、`reports/day-05-template-run-v0-2.jsonl` | 能复现 | v0.2 仍有 4 条失败；详细用例位于 `labs`，尚未形成 `cases` 内的完整正式记录 | 将 12 条记录按统一字段合入用例库；机械冲突交应用预检 |
| Day 6 | Jailbreak 绕过内容/行为安全边界；Prompt Injection 劫持应用任务或指令流；二者可以重叠 | `notes/day-06-jailbreak-theory.md`、`notes/day-06-jailbreak-basics.md` | `reports/day-06-jailbreak-safety-run.jsonl`、`labs/day-06-jailbreak-safety-evaluation.md`、`labs/run-day06-jailbreak-safety.ps1` | 能复现 | 未测试真实工具链；长文本未接近上下文上限；两条人工变异不是自动化搜索 | Day 8 只做本地 Prompt Injection 模拟；工具控制留待 Agent 阶段 |

## 3. 知识地图更新结论

已同步更新 `AI安全知识地图.md`：

- 升为“能复现”：LLM、Token 与上下文、Prompt、System Prompt、幻觉、偏见、Jailbreak。
- 升为“了解”：Transformer、Prompt Injection、输出安全。
- 保持“待学习”：训练数据泄露、RAG 数据安全、Agent 工具安全及尚未补齐的基础主题。

状态升级只说明已有本地学习证据，不表示真实系统已经安全，也不表示学习者已经达到“能独立完成”。

## 4. 证据链缺口

1. Day 3 有 10 条用例明确为“待实测”，不能计入已测试数。
2. Day 4 的五组公平性测试使用 `A/B` 组合 ID，应拆成十个唯一输入 ID。
3. Day 5 的 12 条完整测试记录位于 `labs/day-05-template-evaluation.md`，`cases` 目录中只有模板和结果摘要。
4. Day 6 没有真实工具执行证据，因此“工具参数与对象级授权”仍是控制设计，不是实测结论。
5. 所有实验主要基于本地 `qwen2.5:7b` 小样本，不能外推其他模型、版本或生产环境。

## 5. 第 1 时段验收

- [x] 覆盖 Day 1–6 所有主题。
- [x] 每个“能复现”状态均指向实验、脚本或原始日志。
- [x] 缺口均写成可执行的补测或整理动作。
- [x] 知识地图已按证据更新，未把概念理解写成真实系统防护。

## 6. 发布前边界确认

午休前对 `notes`、`cases/llm-security`、`labs` 和 `reports` 执行了高风险凭据模式检查：未发现私钥块、OpenAI 风格密钥、明文 API Key/Token/Password 或 Bearer Token。现有内容使用虚构对象、本地模型和低风险标记；这只是模式检查结果，不代替人工逐文件数据分类。
