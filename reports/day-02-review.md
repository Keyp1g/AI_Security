# 第 2 天复盘

> 完成日期：2026-09-16

## 今日结论

教材学习让我建立了 LLM、Token、上下文窗口、推理、预训练、微调、对齐、上下文学习、指令微调和 RLHF 的基础框架；对应证据见 `notes/day-02-llm-basics.md`。实际实验则证明了三个可观测现象：未固定 seed 时，同一 Prompt 五次产生了三种输出；短上下文能返回 `BLUE-17`，2050 Token 的重复长文本却返回 `None`；清晰指令比模糊指令更完整地询问授权范围、环境和证据格式。实验详情见 `labs/day-02-output-comparison.md`。

LLM 安全与传统安全的差异在于：输出来自概率性生成；行为依赖 Prompt 和上下文；数据会通过训练、微调或检索与模型行为耦合；输出还可能被 API、渲染器或工具继续执行。因此模型回答必须作为待验证证据，而不是安全结论。

## 后续重点

最值得继续验证的是幻觉、上下文信息丢失和拒答边界。它们分别影响事实可信度、长输入中的安全约束，以及模型对正常请求和危险请求的区分。当前仍不能独立解释 RLHF 中不同策略优化方法的差异，第 3 天先集中学习 Prompt 类型与指令层级，不提前扩展到复杂越狱。

## 完成证据

- 基础概念：`notes/day-02-llm-basics.md`
- 输出对比：`labs/day-02-output-comparison.md`
- 10 条用例：`cases/llm-security/day-02-llm-failures.md`
- 风险初表：`cases/llm-security/llm-risk-initial.md`
- 原始日志：`reports/day-02-ollama-test-log.md`
- 可复现脚本：`labs/run-day02-output-comparison.ps1`

## 今日验收

- [x] 术语表完成
- [x] 输入输出流程图完成
- [x] 10 个失败样例完成并保留实际输出
- [x] 5 次同题输出对比完成
- [x] temperature、上下文和指令清晰度分析完成
- [x] 风险初表完成
- [x] 作品 1 已合入 10 条统一编号用例

## 第 3 天准备

- 必读：总教材“模型使用：Prompt 设计与优化篇”中的 Prompt 定义与设计本质。
- 准备：Prompt、System Prompt、Developer Prompt、User Prompt 的测试记录表。
- 暂不展开：复杂 Jailbreak、真实业务接入、训练模型和大规模参数调优。
