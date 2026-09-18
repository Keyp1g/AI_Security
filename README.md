# AI 安全学习与实践

本项目以 [Acmesec/theAIMythbook](https://github.com/Acmesec/theAIMythbook)《Ai 迷思录（应用与安全指南）》为总教材，记录在其知识体系基础上的个人学习路线、阅读笔记、实验验证、案例整理和项目完善。

本仓库不是上游教材的镜像或替代品。上游教材内容请以原仓库为准；本仓库主要保存个人的学习证据、补充解释、可复现实验和后续作品。

## 当前进度

- 已公开：总路线、42 天总计划，以及 Day 1、Day 2、Day 3 的完整成果
- 当前进度：Day 3 已完成 Prompt 定义、指令边界、20 条质量用例、10 条模型实测、三组单变量实验、正式用例合入和当日复盘
- 学习环境：本地模型、虚构数据、模拟工具和明确授权的实验环境

## 目录

| 路径 | 内容 |
| --- | --- |
| `plan/` | 总计划与逐日学习计划 |
| `notes/` | 概念笔记和阅读记录 |
| `reports/` | 每日复盘、评估报告和阶段总结 |
| `cases/` | 结构化安全测试案例 |
| `labs/` | 可运行实验及实验说明 |
| `tools/` | 评测器和辅助脚本 |
| `路线/` | 学习路线参考截图 |

## 已公开内容

- [42 天总计划](plan/AI安全42天逐日逐小时学习计划.md)
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
- [Prompt 质量正式用例（10 条）](cases/llm-security/prompt_quality_cases.md)
- [Day 3 背景、目标与约束实验](labs/day-03-prompt-variants.md)
- [Day 3 Prompt 质量运行脚本](labs/run-day03-prompt-quality.ps1)
- [Day 3 Prompt 质量原始记录](reports/day-03-prompt-quality-run.jsonl)
- [Day 3 单变量实验原始记录](reports/day-03-prompt-variants-run.jsonl)
- [Day 3 复盘](reports/day-03-review.md)
- [学习索引](学习索引.md)
- [AI 安全路线拆解](AI安全路线拆解.md)
- [AI 安全知识地图](AI安全知识地图.md)
- [能力基线](能力基线.md)
- [作品目标总览](作品目标总览.md)
- [每日复盘模板](每日复盘模板.md)
- [目录说明](notes/目录说明.md)

## 更新方式

每完成一个阶段再发布对应成果，保留计划、证据、卡点和复盘之间的对应关系。后续如果形成适合上游教材的修正或补充，会先与原内容区分，再考虑向上游仓库提交 Issue 或 Pull Request。

## 安全边界

所有实验默认使用本地环境、虚构数据和模拟工具。不在未授权目标上测试，不提交真实 API Key、个人信息、业务数据或本地模型文件。
