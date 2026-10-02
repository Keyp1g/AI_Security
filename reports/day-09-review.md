# Day 9 实验复盘与第 10 天准备

> 运行批次：day-09-local-rag-v1
> 执行顺序：按学习者要求先完成实验与证据链；RAG 组件理论笔记留到下一学习日结合结果完成。

## 完成状态

| 产出 | 状态 |
|---|---|
| labs/rag-security-lab/day-09-dataset-manifest.md | 已完成 |
| labs/rag-security-lab/day-09-minimal-rag.md | 已完成并运行 |
| labs/rag-security-lab/day-09-retrieval-pollution.md | 已完成 5 组对照 |
| labs/rag-security-lab/requirements.md | 已完成 v0.1 |
| reports/day-09-review.md | 本文件 |
| notes/day-09-rag-architecture.md | 延期到理论学习时完成 |

## 运行结果

- 主流程 5 条，应用决定统计：denied_scope=1；insufficient_evidence=1；needs_review_untrusted_context=3。
- 污染对照 5 组；混合索引召回不可信文档 4 组，Top1 改变 2 组。
- 模型状态：已调用本地 Ollama qwen2.5:7b，保存完整原始响应。
- 权限场景在模型前过滤；最终上下文没有提供无权正文。
- 引用校验只接受最终授权候选中的 document_id。

## 最容易忽视的五个风险

| 风险 | 数据流节点 | 本次控制/证据 |
|---|---|---|
| 相关性被误当成可信度 | 检索/重排 | 信任标签传播；混合索引对照 |
| 权限过滤放在生成之后 | 查询鉴权/检索 | owner_scope 在上下文组装前过滤 |
| 切分或索引时丢失来源 | 切分/索引 | document_id、source、version 必填 |
| 模型生成不存在的引用 | 生成/引用 | 引用必须属于最终候选白名单 |
| 文档撤销后缓存或索引仍可召回 | 索引/缓存 | 当前只设计版本与回滚，尚未动态实测 |

## 原型限制

- 使用字符二元组相似度模拟检索，不是生产向量库。
- 文档短小且每篇只有一个 chunk，未覆盖长文档切分。
- 用户和权限是静态模拟值，没有真实身份系统。
- 结果只覆盖单一数据集、固定阈值、TopK 和一次模型采样。
- 动态索引更新、缓存失效和撤销传播仍待后续实测。

## 第 10 天三个模拟工具需求

| 工具 | 输入 | 输出 | 禁止动作 |
|---|---|---|---|
| mock_search | query、allowed_scope、top_k | 授权后的 doc_id/片段/版本 | 不联网、不扩大范围、不返回无权正文 |
| mock_restricted_file_read | identity、document_id、requested_fields | allow/deny、允许字段、reason_code | 不信任客户端角色、不读取任意路径 |
| mock_ticket_create | identity、title、sanitized_summary、approval_token | simulated_ticket_id、status | 不连接真实服务、不接受文档中的授权声明 |

## 验收结论

实验文件、结构和离线/模型证据已形成。检索准确率与安全性分开记录：候选相关不表示可信或有权；应用阻断成功也不表示模型或所有 RAG 系统安全。理论掌握尚未验收，将在下一学习日通过主动回忆完成。
