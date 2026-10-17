# 学习单元与成果注册表

本文件是公开学习成果的统一索引。学习单元表示依赖和验收顺序，不表示自然日；阶段表示课程结构，不表示自然周。

状态含义：

- `已验收`：计划动作已执行，成果与证据已形成；实验可以包含失败结果。
- `部分公开`：本地成果尚未全部进入公开范围。
- `待开始`：只存在计划，不表示已经完成。

## 当前进度

| 阶段 | 学习单元 | 状态 | 说明 |
|---|---|---|---|
| 阶段 1 | 单元 1–7 | 已验收 | LLM、Prompt、幻觉、偏见、Jailbreak 基础与阶段验收 |
| 阶段 2 | 单元 8–13 | 已验收至单元 13 | Prompt Injection、RAG、Agent、应用攻击面、隐私风险与测试方法论 |
| 阶段 2 | 单元 14 | 部分公开 | 阶段验收进行中；步骤 1 术语回顾已验收，其余步骤待完成 |
| 阶段 3–6 | 单元 15–42 | 待开始 | 仅保留本地计划，不进入当前公开成果清单 |

## 阶段 1：LLM 与 Prompt 基础

### 学习单元 1：基线与资料索引

- [计划](../plan/unit-01.md)
- [基础笔记](../notes/unit-01-foundation.md)
- [复盘](../reports/unit-01-review.md)

### 学习单元 2：LLM 基础

- [计划](../plan/unit-02.md)
- [基础笔记](../notes/unit-02-llm-basics.md)
- [输出对比实验](../labs/unit-02-output-comparison.md)
- [失败样例](../cases/llm-security/unit-02-llm-failures.md)
- [失败样例输入](../labs/unit02-failure-prompts.json)
- [失败样例运行器](../labs/run-unit02-failure-cases.ps1)
- [Ollama 接口运行器](../labs/run-unit02-ollama-api.ps1)
- [输出对比运行器](../labs/run-unit02-output-comparison.ps1)
- [Ollama 测试日志](../reports/unit-02-ollama-test-log.md)
- [复盘](../reports/unit-02-review.md)

### 学习单元 3：Prompt 与指令

- [计划](../plan/unit-03.md)
- [理论笔记](../notes/unit-03-prompt-and-instructions.md)
- [Prompt 质量样例](../cases/llm-security/unit-03-prompt-quality-cases.md)
- [变量实验](../labs/unit-03-prompt-variants.md)
- [Prompt 质量输入](../labs/unit03-prompt-quality-cases.json)
- [变量实验输入](../labs/unit03-prompt-variants.json)
- [运行器](../labs/run-unit03-prompt-quality.ps1)
- [质量原始记录](../reports/unit-03-prompt-quality-run.jsonl)
- [变量原始记录](../reports/unit-03-prompt-variants-run.jsonl)
- [复盘](../reports/unit-03-review.md)

### 学习单元 4：幻觉、偏见与过度依赖

- [计划](../plan/unit-04.md)
- [理论笔记](../notes/unit-04-hallucination-bias.md)
- [事实核查实验](../labs/unit-04-fact-checking.md)
- [测试用例](../cases/llm-security/unit-04-hallucination-bias.md)
- [统一用例库](../cases/llm-security/hallucination_bias_cases.md)
- [幻觉测试输入](../labs/unit04-hallucination-bias-cases.json)
- [公平性测试输入](../labs/unit04-fairness-pairs.json)
- [幻觉运行器](../labs/run-unit04-hallucination.ps1)
- [公平性运行器](../labs/run-unit04-fairness.ps1)
- [幻觉原始记录](../reports/unit-04-hallucination-run.jsonl)
- [公平性原始记录](../reports/unit-04-fairness-run.jsonl)
- [复盘](../reports/unit-04-review.md)

### 学习单元 5：Prompt 工程流程化

- [计划](../plan/unit-05.md)
- [理论笔记](../notes/unit-05-prompt-workflow.md)
- [模板实验](../labs/unit-05-template-evaluation.md)
- [模板定义](../cases/llm-security/prompt_templates.md)
- [正式用例](../cases/llm-security/prompt_template_cases.md)
- [运行器](../labs/run-unit05-template-evaluation.ps1)
- [v0.1 原始记录](../reports/unit-05-template-run-v0-1.jsonl)
- [v0.2 原始记录](../reports/unit-05-template-run-v0-2.jsonl)
- [复盘](../reports/unit-05-review.md)

### 学习单元 6：Jailbreak 基础

- [计划](../plan/unit-06.md)
- [理论笔记](../notes/unit-06-jailbreak-theory.md)
- [完整笔记](../notes/unit-06-jailbreak-basics.md)
- [测试入口](../cases/llm-security/unit-06-jailbreak-safety.md)
- [完整用例](../cases/llm-security/unit-06-jailbreak-safety-cases.md)
- [作品用例表](../cases/llm-security/jailbreak_safety_cases.md)
- [拒答质量对比](../labs/unit-06-refusal-quality.md)
- [人工评估](../labs/unit-06-jailbreak-safety-evaluation.md)
- [测试输入](../labs/unit06-jailbreak-safety-cases.json)
- [运行器](../labs/run-unit06-jailbreak-safety.ps1)
- [原始记录](../reports/unit-06-jailbreak-safety-run.jsonl)
- [复盘](../reports/unit-06-review.md)

### 学习单元 7：阶段 1 验收

- [计划与验收](../plan/unit-07.md)
- [学习盘点](../notes/stage-01-inventory.md)
- [统一术语表](../notes/stage-01-glossary.md)
- [用例审计](../cases/llm-security/stage-01-case-audit.md)
- [自测题](../labs/stage-01-self-test.md)
- [阶段报告](../reports/stage-01-report.md)
- [阶段 2 准备](../reports/stage-02-preparation.md)

## 阶段 2：Prompt Injection、RAG、Agent 与应用安全

### 学习单元 8：Prompt Injection

- [计划](../plan/unit-08.md)
- [理论笔记](../notes/unit-08-prompt-injection.md)
- [直接注入实验](../labs/unit-08-direct-injection.md)
- [间接注入实验](../labs/unit-08-indirect-injection.md)
- [控制验证](../labs/unit-08-control-validation.md)
- [直接注入输入](../labs/unit08-direct-injection-cases.json)
- [间接注入输入](../labs/unit08-indirect-injection-cases.json)
- [控制用例输入](../labs/unit08-control-cases.json)
- [直接注入运行器](../labs/run-unit08-direct-injection.ps1)
- [间接注入运行器](../labs/run-unit08-indirect-injection.ps1)
- [控制验证运行器](../labs/run-unit08-control-cases.ps1)
- [本地虚构文档与模拟器](../labs/stage-02/documents/README.md)
- [正式用例库](../cases/llm-security/prompt_injection_cases.md)
- [直接注入原始记录](../reports/unit-08-direct-injection-run-v0-2.jsonl)
- [间接注入原始记录](../reports/unit-08-indirect-injection-run-v0-1.jsonl)
- [控制验证原始记录](../reports/unit-08-control-cases-run-v0-4.jsonl)
- [复盘](../reports/unit-08-review.md)

### 学习单元 9：RAG 基础架构

- [计划](../plan/unit-09.md)
- [理论笔记](../notes/unit-09-rag-architecture.md)
- [数据集清单](../labs/rag-security-lab/unit-09-dataset-manifest.md)
- [最小原型](../labs/rag-security-lab/unit-09-minimal-rag.md)
- [检索污染实验](../labs/rag-security-lab/unit-09-retrieval-pollution.md)
- [实验运行器](../labs/rag-security-lab/unit-09-run-rag-experiments.py)
- [主流程原始记录](../labs/rag-security-lab/logs/unit-09-run.jsonl)
- [污染对照原始记录](../labs/rag-security-lab/logs/unit-09-pollution-run.jsonl)
- [系统需求](../labs/rag-security-lab/requirements.md)
- [复盘](../reports/unit-09-review.md)

### 学习单元 10：Agent 与 Tool Calling

- [计划](../plan/unit-10.md)
- [组件理论](../notes/unit-10-agent-components-theory.md)
- [控制链理论](../notes/unit-10-tool-calling-flow-theory.md)
- [工具契约理论](../notes/unit-10-tool-contracts-theory.md)
- [权限矩阵理论](../notes/unit-10-permission-matrix-theory.md)
- [工具契约](../labs/agent-tool-security/unit-10-tool-specs.md)
- [权限矩阵](../labs/agent-tool-security/unit-10-permission-matrix.md)
- [模拟器](../labs/agent-tool-security/unit-10-simulator.ps1)
- [工具滥用测试](../labs/agent-tool-security/unit-10-tool-misuse-tests.md)
- [模拟器原始记录](../labs/agent-tool-security/unit-10-simulator-results.jsonl)
- [系统需求](../labs/agent-tool-security/requirements.md)
- [复盘](../reports/unit-10-review.md)

### 学习单元 11：LLM 应用层攻击面

- [计划](../plan/unit-11.md)
- [理论笔记](../notes/unit-11-application-attack-surface-theory.md)
- [完整笔记](../notes/unit-11-application-attack-surface.md)
- [威胁模型](../labs/unit-11-threat-model.md)
- [STRIDE 矩阵](../labs/unit-11-stride-matrix.md)
- [复盘前门禁](../reports/unit-11-pre-review-gate.md)
- [平台控制证据摘要](../reports/unit-11-platform-control-evidence.md)
- [AI 应用安全检查清单](../AI应用安全检查清单.md)
- [复盘](../reports/unit-11-review.md)

### 学习单元 12：训练数据泄露与隐私风险

- 状态：已验收。已完成概念、生命周期、20 条合成样例、检测规则、8 条模型行为测试、4 条确定性工具控制测试、16 条正式用例和复盘。
- 结果边界：模型行为人工复核为 4 条通过、3 条失败、1 条格式失败；工具控制 4 条本地通过。训练成员推理、模型反演、真实日志平台、真实 IAM/工具网关、缓存和删除传播仍待验证。
- [计划](../plan/unit-12.md)
- [理论公开稿](../notes/unit-12-privacy-risks-theory.md)
- [完整笔记](../notes/unit-12-privacy-risks.md)
- [合成样例](../labs/unit-12-synthetic-secrets.md)
- [检测规则](../labs/unit-12-detection-rules.md)
- [运行器](../labs/run-unit12-privacy-leakage.ps1)
- [实验设计与人工复核](../cases/llm-security/unit-12-privacy-leakage.md)
- [机器可读原始证据](../reports/unit-12-privacy-leakage-run.jsonl)
- [复盘](../reports/unit-12-review.md)
- [作品一正式用例库](../cases/llm-security/README.md)

### 学习单元 13：AI 安全测试方法论

- 状态：已验收。已完成 11 阶段红队流程、统一用例规范、64 条既有用例迁移审计、四维评分规则、20 条代表性样例批量评分、评估报告模板、5 条候选发现登记和复盘。
- 结果边界：批量评分包含失败 11 条、待实测 2 条、阻断 7 条；该统计只描述代表性样例。待实测、阻断、用例数量、风险分数和模板存在均不表示真实系统安全。
- [计划](../plan/unit-13.md)
- [方法论笔记](../notes/unit-13-ai-security-testing.md)：AI 红队 11 阶段流程、角色职责、停止规则与本地模拟应用最小测试计划。
- [统一用例规范](../cases/llm-security/case-schema.md)：用例字段、ID 命名与五态判定规范（v1.0）。
- [既有用例迁移审计](../cases/llm-security/unit-13-case-normalization.md)：学习单元 8–12 共 64 条用例的字段覆盖与缺口清单。
- [风险评分规则](../labs/unit-13-risk-scoring.md)：严重性、可复现性、影响范围和利用复杂度得分的锚点与人工复核要求。
- [批量评分](../labs/unit-13-batch-scoring.md)：四类资产各 5 条的状态感知评分和异常检查。
- [作品 5 评估报告模板](../reports/agent-security-assessment/assessment-template.md)：范围、发现、证据、修复、复测和限制模板。
- [复盘](../reports/unit-13-review.md)：评分主观性、证据缺口和学习单元 14 验收入口。

### 学习单元 14：阶段 2 验收

- 状态：进行中、部分公开。当前只完成并公开步骤 1；不表示学习单元 14 或阶段 2 最终验收已经通过。
- [应用层安全术语与薄弱项](../notes/stage-02-application-security-glossary.md)：31 个术语、五组易混概念、9 项阶段 3 补强项，以及“计划要求 → 实际成果 → 验证证据 → 验收结论 → 剩余限制”映射。
- 尚未公开：30 道自测、作品审计与 readiness、端到端威胁模型、阶段报告和阶段 3 Web 准备。

## 作品入口

- [LLM 安全测试用例库](../cases/llm-security/README.md)
- [RAG 安全实验系统](../labs/rag-security-lab/requirements.md)
- [Agent 工具安全实验](../labs/agent-tool-security/requirements.md)
- [AI 应用安全检查清单](../AI应用安全检查清单.md)

后续学习单元只有在完成“计划要求 → 实际成果 → 验证证据”映射并通过发布审查后，才加入本注册表的已验收清单。
