# AI 安全知识地图

## 1. 基础知识
- 传统网络安全：状态=待学习；证据=
- HTTP/Web：状态=待学习；证据=
- Python：状态=了解；证据=
- AI 数学：状态=待学习；证据=

## 2. 模型基础
- LLM：状态=能复现；证据=`notes/day-02-llm-basics.md`、`labs/day-02-output-comparison.md`、`reports/day-02-review.md`
- Token 与上下文：状态=能复现；证据=`labs/day-02-output-comparison.md`、`cases/llm-security/day-02-llm-failures.md` 中 `LLM-002-06`
- Transformer：状态=了解；证据=`notes/day-01-foundation.md`、`notes/day-02-llm-basics.md`；尚无架构实验
- Prompt：状态=能复现；证据=`notes/day-03-prompt-and-instructions.md`、`labs/day-03-prompt-variants.md`
- System Prompt：状态=能复现；证据=`notes/day-03-prompt-and-instructions.md`、`reports/day-03-prompt-variants-run.jsonl`

## 3. 模型安全
- 幻觉：状态=能复现；证据=`labs/day-04-fact-checking.md`、`reports/day-04-hallucination-run.jsonl`
- 偏见：状态=能复现；证据=`cases/llm-security/day-04-hallucination-bias.md`、`reports/day-04-fairness-run.jsonl`；仅代表小样本对比
- Jailbreak：状态=能复现；证据=`labs/day-06-jailbreak-safety-evaluation.md`、`reports/day-06-jailbreak-safety-run.jsonl`
- 训练数据泄露：状态=待学习；证据=

## 4. 应用安全
- Prompt Injection：状态=了解；证据=`notes/day-06-jailbreak-theory.md`；尚未完成专门的注入实验
- RAG 数据安全：状态=待学习；证据=
- Agent 工具安全：状态=待学习；证据=
- 输出安全：状态=了解；证据=`labs/day-05-template-evaluation.md`、`cases/llm-security/jailbreak_safety_cases.md`；尚未完成真实下游执行实验

## 5. 作品映射
- 作品 1：LLM 安全测试用例库
- 作品 2：RAG 安全实验系统
- 作品 3：Agent 工具安全实验
- 作品 4：AI 安全自动化评测工具
- 作品 5：Agent 安全评估报告

## 状态说明
- 待学习：还没有可靠定义或实验
- 了解：能解释概念，但没有实验证据
- 能复现：能按步骤完成实验
- 能独立完成：能设计、执行、分析并写报告
