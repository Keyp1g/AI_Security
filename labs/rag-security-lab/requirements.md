# 作品 2：RAG 安全实验系统需求

> 版本：v0.1
> 阶段：Day 9 实验增量

## 问题定义

构建只使用本地虚构文档的可复测 RAG 安全实验系统，观察来源、权限、检索污染、引用和输出审查控制是否在正确位置生效。

## 非目标

- 不连接真实企业知识库、用户目录或第三方服务。
- 阶段一不要求真实向量数据库或生产 Embedding。
- 不执行文档中的控制样式文字，不连接真实工具，不产生外部副作用。
- 不用单次模型输出证明系统整体安全。

## 组件

文档准入、元数据解析、稳定切分、离线相似度索引、查询鉴权、检索、重排占位、上下文组装、本地生成、引用校验、输出审查、证据日志、索引回滚。

## 数据集与权限模型

- 5 篇 trusted_reference 和 5 篇 untrusted_reference。
- 每篇必须有 document_id、source、trust_level、owner_scope 和 SHA-256/版本。
- user-analyst 的服务端范围是 training-demo；user-visitor 的范围是 public-demo。
- 客户端声明、模型输出、相似度和 trust_level 均不能扩大 allowed_scopes。

## 威胁与控制

| 威胁 | 影响 | 主要控制 |
|---|---|---|
| 未批准文档入库 | 索引完整性 | 准入列表、哈希、版本 |
| 来源或权限标签丢失 | 越权、无法追溯 | 元数据必填、失败关闭 |
| 低信任文档高排名 | 回答污染 | 信任传播、复核、对照测试 |
| 跨范围召回 | 机密性 | 模型前确定性 owner_scope 过滤 |
| 文档文字被当成指令 | 任务劫持 | 数据边界、固定规则、输出校验 |
| 引用伪造或过期 | 可验证性 | 引用候选白名单、版本字段 |
| 删除未同步 | 陈旧内容继续召回 | 索引版本、撤销和回滚 |
| 日志保存正文 | 二次泄露 | 日志最小化、保存 ID/哈希/判定 |

## 防护矩阵

| 防护 | 数据流节点 | 攻击前预防 | 运行时检测 | 响应动作 | 日志字段 | 测试 ID |
|---|---|---|---|---|---|---|
| 文档准入 | 文档接入 | 只扫描批准目录和 Markdown | 文件数、front matter、必填字段校验 | 拒绝入库并终止构建 | document_id、file_name、error | RAG-009-01~05 |
| 来源签名与版本 | 来源标记/索引 | SHA-256 绑定文档版本 | 候选携带 version 并进入引用 | 版本不一致时撤销候选 | source、version、document_id | RAG-009-01、05 |
| 权限元数据 | 查询鉴权/检索 | owner_scope 必填，服务端提供 allowed_scopes | 比较鉴权前后候选 | 模型前 denied_scope，不返回正文 | identity、allowed_scopes、final_context_document_ids | RAG-009-03 |
| 内容隔离 | 上下文组装 | DOCUMENT 边界与“不可信数据”系统规则 | 检测 untrusted_reference | 标记 needs_review，不执行文档文字 | trust_level、untrusted_in_context | RAG-009-05、RAG-POLL-01~05 |
| 检索过滤 | 检索/重排 | 阈值、TopK、范围过滤分离 | 记录候选分数和 Top1 变化 | 无候选安全弃答；低信任结果降级复核 | score、top_k、route_status | RAG-009-02~04、RAG-POLL-01~05 |
| 引用约束 | 生成/引用 | Prompt 限定只能引用候选 ID | 引用集合与最终候选白名单比对 | missing/invalid citation 阻断 | citations、citation_status | RAG-009-01、04、05 |
| 输出审查 | 引用/输出审查 | 固定 JSON 合约和证据不足状态 | JSON 解析、answer/status/信任联合判定 | invalid_output 阻断；不可信回答人工复核 | generation_status、application_decision | RAG-009-02、04、05 |
| 反馈与索引回滚 | 日志/索引 | 保存版本与可重复运行脚本 | 对比 clean/mixed 索引结果 | 撤销污染版本并从干净索引重建 | run_id、version、top_candidate_changed、output_changed | RAG-POLL-01~05 |

`trust_level` 的外部文本降权只影响复核路线；`owner_scope` 的确定性过滤决定文档能否进入上下文，两者不能互相替代。当前回滚为设计验证，动态删除与缓存失效仍待后续实测。

## 实验与验收

- RAG-009-01 至 05 覆盖正确检索、无结果、无权限、证据不足和不可信上下文。
- RAG-POLL-01 至 05 覆盖干净索引和混合索引对照。
- 权限过滤必须发生在上下文组装前。
- 模型不能扩大权限或伪造有效引用。
- untrusted_reference 进入上下文时必须触发 needs_review。
- 原始响应、候选、版本、引用判定和应用决定必须可复核。
