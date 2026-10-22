# AI 安全学习与实践

本项目以 [Acmesec/theAIMythbook](https://github.com/Acmesec/theAIMythbook) 为总教材，记录可验证的 AI 安全学习、实验和作品成果。项目按阶段（`stage-NN`）和学习单元（`unit-NN`）组织，不按自然日或周次打卡。

## 当前状态

- 阶段 1（学习单元 1–7）：已验收。
- 阶段 2（学习单元 8–14）：已完成例外验收，可以进入阶段 3。
- 学习单元 14 的步骤 1–6、8、9 已验收；步骤 7 按学习者要求跳过。作品 1 有 144 条唯一设计用例、92 条达到最低结构标准，距离 100 条结构化目标差 8 条；作品 5 正式完整报告仍未完成。上述例外保留状态，不登记为已完成。
- 学习单元 12 已完成隐私风险概念、数据生命周期、20 条合成样例、检测规则、8 条模型行为测试、4 条确定性工具控制测试、16 条正式用例和复盘。
- 学习单元 12 的本地模型结论仅适用于 Ollama qwen2.5:7b、固定参数和本轮样本；工具结论仅适用于确定性模拟器。训练成员推理、模型反演、真实日志平台、真实 IAM/工具网关、缓存和删除传播仍待验证。
- 学习单元 13 已完成 AI 红队 11 阶段流程与授权/停止边界、统一用例规范、64 条既有用例迁移审计、四维风险评分、20 条代表性样例批量评分、作品 5 评估报告模板、5 条候选发现登记和复盘。批量评分中的失败、待实测与阻断分开统计；数量、分数和模板存在均不作为系统安全结论。
- 后续学习单元只保留本地计划，经过证据审查后再加入公开注册表。

## 入口

- [学习单元与成果注册表](docs/learning-units.md)：按阶段列出计划、笔记、实验、用例和复盘证据。
- [学习单元 13 计划](plan/unit-13.md)：完成标准、步骤与验收边界。
- [学习单元 13 方法论](notes/unit-13-ai-security-testing.md)：AI 红队流程、最小测试计划、授权边界与三层证据要求。
- [统一用例规范](cases/llm-security/case-schema.md)与[迁移审计](cases/llm-security/unit-13-case-normalization.md)：五态判定、字段规范、12 条代表性映射与缺口清单。
- [风险评分规则](labs/unit-13-risk-scoring.md)与[批量评分](labs/unit-13-batch-scoring.md)：四维锚点、20 条代表性样例和人工复核条件。
- [作品 5 评估报告模板](reports/agent-security-assessment/assessment-template.md)与[单元复盘](reports/unit-13-review.md)：发现—证据—修复—复测追踪和学习单元 14 验收入口。
- [阶段 2 应用层安全术语与薄弱项](notes/stage-02-application-security-glossary.md)：学习单元 14 步骤 1 的 31 个术语、五组易混概念、掌握状态和阶段 3 补强项。
- [阶段 2 应用层安全自测](labs/stage-02-self-test.md)：学习单元 14 步骤 2 的 30 道完整记录；包含原始限时答案、标准答案、辅助评分、理由、本地证据、错因和步骤验收，最终得分 54/60（90%）。
- [阶段 2 作品 1 用例审计](cases/llm-security/stage-02-case-audit.md)：按唯一 ID 和统一五态盘点 144 条用例，抽样 18 条，确认 92 条达到步骤 3 最低结构标准并记录 8 条差额与迁移计划。
- [作品 2 RAG readiness](labs/rag-security-lab/stage-02-readiness.md)、[作品 3 Agent readiness](labs/agent-tool-security/stage-02-readiness.md)与[作品 5 报告 readiness](reports/agent-security-assessment/stage-02-readiness.md)：逐项核对需求、证据、安全验收和后续缺口。
- [阶段 2 端到端威胁模型](labs/stage-02-end-to-end-threat-model.md)：本地模拟知识问答 Agent 的 16 个资产、5 个角色、10 条信任边界、18 条 STRIDE 威胁和复测入口。
- [阶段 2 验收报告](reports/stage-02-report.md)：汇总完成资产、五态统计、作品进度、三个核心结论、风险债务和阶段 3 Web 基础入口。
- [本地 Ollama 跨层实验验收](reports/stage-02-local-ollama-e2e-acceptance.md)：保留两轮失败与修复过程，并记录 RAG 删除传播、可信确认、20 并发幂等和完整跨层 Agent 连续五轮通过证据。
- [阶段 3 Web 环境准备](reports/stage-03-web-preparation.md)：学习单元 14 步骤 8 的本地回环环境、浏览器隔离、证据脱敏、允许/禁止边界和 Unit 15 前置条件；步骤 7 按学习者要求跳过。
- [总计划](plan/AI安全分阶段学习与成果验收计划.md)：路线、依赖和验收闭环。
- [项目结构](docs/project-structure.md)：目录职责、命名和发布边界。
- [项目领域上下文](CONTEXT.md)：核心术语和不变量。
- [架构决策 ADR-0001](docs/adr/0001-use-learning-units-as-progress-identity.md)：为什么使用学习单元作为唯一进度身份。
- [学习索引](学习索引.md)：教材入口与阅读顺序。
- [学习单元复盘模板](学习单元复盘模板.md)：统一记录目标、证据、实验和验收结论。

## 目录

| 路径 | 内容 |
|---|---|
| `plan/` | 总计划和学习单元计划 |
| `notes/` | 概念、阅读和机制笔记 |
| `labs/` | 实验说明、夹具和运行器 |
| `cases/` | 结构化安全测试用例和作品用例库 |
| `reports/` | 原始运行证据、复盘和阶段总结 |
| `docs/` | 领域上下文、成果注册表、结构说明和 ADR |
| `tools/` | 可复用评测器和辅助脚本 |
| `路线/` | 阶段与作品路径图 |

## 公开边界

公开成果必须满足“计划要求 → 实际产物 → 验证证据”映射。实验失败会如实保留，不能被改写成安全结论；尚未覆盖真实平台的范围继续标为待验证。模型文件、教材副本、编辑器日志、服务器运行手册、个人草稿和后续学习单元不进入公开范围。

所有测试使用本地环境、合成数据、模拟工具或明确授权的实验环境，不提交真实密钥、个人信息或业务数据。
