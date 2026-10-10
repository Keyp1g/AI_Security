# AI 安全学习与实践

本项目以 [Acmesec/theAIMythbook](https://github.com/Acmesec/theAIMythbook)《Ai 迷思录（应用与安全指南）》为总教材，记录在其知识体系基础上的个人学习路线、阅读笔记、实验验证、案例整理和项目完善。

本仓库不是上游教材的镜像或替代品。上游教材内容请以原仓库为准；本仓库主要保存个人的学习证据、补充解释、可复现实验和后续作品。

## 当前进度

- 已公开：总路线、分阶段学习计划、Day 1 至 Day 8 的完整学习成果，以及 Day 9、Day 10 的完整模拟实验与理论验收成果
- 当前进度：Day 9 理论与实验均已完成；Day 10 计划内任务、实验、六组件理论、Tool Calling 控制链、三个工具契约和权限矩阵理论均已完成；Day 11 已公开三层攻击面理论与逻辑模型，完整威胁建模和检查清单仍在本地
- 审计结论：Day 10 的 18 个确定性场景均有唯一 ID 和逐行证据，允许 5、拒绝 13；这只证明本地模拟网关的固定分支，不代表真实 Agent 或模型安全
- 发布边界：Day 9 理论、实验和复盘已完整公开；本次公开 Day 10 计划、权限矩阵理论和既有实验/复盘证据；学习方法论、教材副本、调试中间版本、服务器未完成资产和 Day 11 及后续内容仍留在本地
- 学习环境：本地模型、虚构数据、模拟工具和明确授权的实验环境

## 目录

| 路径 | 内容 |
| --- | --- |
| `plan/` | 分阶段总计划与学习单元计划 |
| `notes/` | 概念笔记和阅读记录 |
| `reports/` | 学习单元复盘、评估报告和阶段总结 |
| `cases/` | 结构化安全测试案例 |
| `labs/` | 可运行实验及实验说明 |
| `tools/` | 评测器和辅助脚本 |
| `路线/` | 学习阶段与作品路径图 |

## 已公开内容

- [AI 安全分阶段学习与成果验收计划](plan/AI安全分阶段学习与成果验收计划.md)
- [Day 1 计划](plan/1Day.md)
- [Day 1 基础笔记](notes/day-01-foundation.md)
- [Day 1 复盘](reports/day-01-review.md)
- [Day 2 计划](plan/2Day.md)
- [Day 2 LLM 基础笔记](notes/day-02-llm-basics.md)
- [Day 2 输出对比实验](labs/day-02-output-comparison.md)
- [Day 2 LLM 失败样例](cases/llm-security/day-02-llm-failures.md)
- [LLM 安全测试用例库](cases/llm-security/README.md)
- [LLM 风险初表](cases/llm-security/llm-risk-initial.md)
- [Day 2 Ollama 测试日志](reports/day-02-ollama-test-log.md)
- [Day 2 复盘](reports/day-02-review.md)
- [Day 3 计划](plan/3Day.md)
- [Day 3 Prompt 与指令笔记](notes/day-03-prompt-and-instructions.md)
- [Day 3 Prompt 质量样例（20 条）](cases/llm-security/day-03-prompt-quality-cases.md)
- [Prompt 质量正式用例（20 条）](cases/llm-security/prompt_quality_cases.md)
- [Day 3 背景、目标与约束实验](labs/day-03-prompt-variants.md)
- [Day 3 Prompt 质量运行脚本](labs/run-day03-prompt-quality.ps1)
- [Day 3 Prompt 质量原始记录](reports/day-03-prompt-quality-run.jsonl)
- [Day 3 单变量实验原始记录](reports/day-03-prompt-variants-run.jsonl)
- [Day 3 复盘](reports/day-03-review.md)
- [Day 4 幻觉、偏见与过度依赖理论笔记](notes/day-04-hallucination-bias.md)
- [Day 4 计划](plan/4Day.md)
- [Day 4 事实核查记录](labs/day-04-fact-checking.md)
- [Day 4 幻觉与公平性测试用例](cases/llm-security/day-04-hallucination-bias.md)
- [Day 4 统一用例库](cases/llm-security/hallucination_bias_cases.md)
- [Day 4 幻觉测试输入](labs/day04-hallucination-bias-cases.json)
- [Day 4 公平性测试输入](labs/day04-fairness-pairs.json)
- [Day 4 幻觉测试脚本](labs/run-day04-hallucination.ps1)
- [Day 4 公平性测试脚本](labs/run-day04-fairness.ps1)
- [Day 4 幻觉原始响应](reports/day-04-hallucination-run.jsonl)
- [Day 4 公平性原始响应](reports/day-04-fairness-run.jsonl)
- [Day 4 复盘](reports/day-04-review.md)
- [Day 5 Prompt 工程工作流](notes/day-05-prompt-workflow.md)
- [Day 5 四类可复测 Prompt 模板](cases/llm-security/prompt_templates.md)
- [Day 5 Prompt 模板正式用例（12 条）](cases/llm-security/prompt_template_cases.md)
- [Day 5 模板测试与两轮评估](labs/day-05-template-evaluation.md)
- [Day 5 可复现实验脚本](labs/run-day05-template-evaluation.ps1)
- [Day 5 v0.1 原始响应](reports/day-05-template-run-v0-1.jsonl)
- [Day 5 v0.2 原始响应](reports/day-05-template-run-v0-2.jsonl)
- [Day 5 复盘](reports/day-05-review.md)
- [Day 6 Jailbreak 基础理论](notes/day-06-jailbreak-theory.md)
- [Day 6 计划](plan/6Day.md)
- [Day 6 完整学习笔记](notes/day-06-jailbreak-basics.md)
- [Day 6 合规安全测试入口](cases/llm-security/day-06-jailbreak-safety.md)
- [Day 6 完整用例定义](cases/llm-security/day-06-jailbreak-safety-cases.md)
- [Day 6 正式作品用例表](cases/llm-security/jailbreak_safety_cases.md)
- [Day 6 拒答、帮助与澄清质量对比](labs/day-06-refusal-quality.md)
- [Day 6 人工评估](labs/day-06-jailbreak-safety-evaluation.md)
- [Day 6 可复现测试输入](labs/day06-jailbreak-safety-cases.json)
- [Day 6 可复现实验脚本](labs/run-day06-jailbreak-safety.ps1)
- [Day 6 原始模型响应](reports/day-06-jailbreak-safety-run.jsonl)
- [Day 6 复盘](reports/day-06-review.md)
- [Day 7 计划与最终验收](plan/7Day.md)
- [阶段 1 学习盘点（Day 1–6）](notes/week-01-inventory.md)
- [阶段 1 统一术语表](notes/week-01-glossary.md)
- [阶段 1 LLM 安全用例审计](cases/llm-security/week-01-case-audit.md)
- [阶段 1 自测题（20 题）](labs/week-01-self-test.md)
- [阶段 1 学习报告与复盘](reports/week-01-report.md)
- [阶段 2 本地实验准备清单](reports/week-02-preparation.md)
- [Day 8 计划](plan/8Day.md)
- [Day 8 Prompt Injection 笔记](notes/day-08-prompt-injection.md)
- [Day 8 直接注入实验](labs/day-08-direct-injection.md)
- [Day 8 间接注入实验](labs/day-08-indirect-injection.md)
- [Day 8 控制验证实验](labs/day-08-control-validation.md)
- [Day 8 Prompt Injection 正式用例库（20 条）](cases/llm-security/prompt_injection_cases.md)
- [Day 8 复盘与 Day 9 准备](reports/day-08-review.md)
- [Day 9 计划与实验完成状态](plan/9Day.md)
- [Day 9 RAG 架构理论笔记](notes/day-09-rag-architecture.md)
- [Day 9 本地 RAG 数据集清单](labs/rag-security-lab/day-09-dataset-manifest.md)
- [Day 9 最小 RAG 原型与运行记录](labs/rag-security-lab/day-09-minimal-rag.md)
- [Day 9 检索污染测试记录](labs/rag-security-lab/day-09-retrieval-pollution.md)
- [Day 9 RAG 安全实验系统需求](labs/rag-security-lab/requirements.md)
- [Day 9 可复现实验脚本](labs/rag-security-lab/day-09-run-rag-experiments.py)
- [Day 9 主流程原始证据](labs/rag-security-lab/logs/day-09-run.jsonl)
- [Day 9 污染对照原始证据](labs/rag-security-lab/logs/day-09-pollution-run.jsonl)
- [Day 9 实验复盘](reports/day-09-review.md)
- [Day 10 计划与实验完成状态](plan/10Day.md)
- [Day 10 六组件理论（已验收部分）](notes/day-10-agent-components-theory.md)
- [Day 10 Tool Calling 控制链理论（已验收部分）](notes/day-10-tool-calling-flow-theory.md)
- [Day 10 三个模拟工具契约理论（已验收部分）](notes/day-10-tool-contracts-theory.md)
- [Day 10 角色与对象级权限矩阵理论](notes/day-10-permission-matrix-theory.md)
- [Day 10 模拟工具契约](labs/agent-tool-security/day-10-tool-specs.md)
- [Day 10 权限矩阵与服务端校验顺序](labs/agent-tool-security/day-10-permission-matrix.md)
- [Day 10 工具滥用防护测试（18 条）](labs/agent-tool-security/day-10-tool-misuse-tests.md)
- [Day 10 可复现实验脚本](labs/agent-tool-security/day-10-simulator.ps1)
- [Day 10 去时间线原始证据](labs/agent-tool-security/day-10-simulator-results.jsonl)
- [作品 3 Agent Tool Security Lab 需求](labs/agent-tool-security/requirements.md)
- [Day 10 实验复盘](reports/day-10-review.md)
- [Day 11 LLM 应用层攻击面（三层模型）](notes/day-11-application-attack-surface-theory.md)
- [学习索引](学习索引.md)
- [AI 安全路线拆解](AI安全路线拆解.md)
- [AI 安全知识地图](AI安全知识地图.md)
- [能力基线](能力基线.md)
- [作品目标总览](作品目标总览.md)
- [学习单元复盘模板](每日复盘模板.md)
- [目录说明](notes/目录说明.md)

## 更新方式

每完成一个阶段再发布对应成果，保留计划、证据、卡点和复盘之间的对应关系。后续如果形成适合上游教材的修正或补充，会先与原内容区分，再考虑向上游仓库提交 Issue 或 Pull Request。

## 文件命名约定

- 计划文件沿用已有的 `NDay.md` 形式；笔记、实验说明和报告使用 `day-NN-topic` 形式。
- 机器可读用例和运行脚本沿用仓库既有的 `dayNN-topic`、`run-dayNN-topic` 形式，避免与历史入口断链。
- 正式用例库使用主题化 snake_case；文档夹具使用 `clean-NN`、`untrusted-NN` 等能表达信任属性的名称。
- 路线图使用内容语义名称，不使用截图生成时间作为文件名。

## 安全边界

所有实验默认使用本地环境、虚构数据和模拟工具。不在未授权目标上测试，不提交真实 API Key、个人信息、业务数据或本地模型文件。
