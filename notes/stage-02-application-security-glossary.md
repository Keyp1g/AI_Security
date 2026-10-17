# 阶段 2：应用层安全术语与薄弱项

> 对应学习单元：unit-14 步骤 1  
> 范围：学习单元 8–13。掌握状态来自本步骤闭卷回答与纠错；文件存在、概念掌握或模拟器通过均不等于真实平台已经验证。

## 1. 掌握状态

- **已掌握**：能用自己的话解释定义、边界和主要安全落点。
- **基本掌握**：核心判断正确，但仍需补充工程条件或证据要求。
- **待补强**：只有概念或模拟证据，尚不能独立验证真实集成。

## 2. 术语表

| 术语 | 定义与安全边界 | 本地证据 | 掌握状态 | 仍不确定的问题 |
|---|---|---|---|---|
| 直接 Prompt Injection | 当前用户输入中的控制性文字试图改变任务、规则、输出契约或工具行为。可疑输入是尝试；实际任务偏离、规则泄露、契约破坏或越权请求才是成功。 | notes/unit-08-prompt-injection.md；labs/unit-08-direct-injection.md | 已掌握 | 不同模型和长上下文下的稳定复现率。 |
| 间接 Prompt Injection | 控制性文字藏在网页、文档、RAG 片段或工具结果中。构造者不一定是当前用户；被阻断仍属于注入尝试。 | labs/unit-08-indirect-injection.md；reports/unit-08-indirect-injection-run-v0-1.jsonl | 已掌握 | 真实浏览器、邮件和第三方连接器传播链。 |
| Jailbreak | 绕过模型的内容或行为安全限制。它关注模型限制；Prompt Injection 关注应用的任务、指令、数据和工具边界。 | notes/unit-06-jailbreak-theory.md；notes/unit-08-prompt-injection.md | 已掌握 | 模型版本变化后的回归规律。 |
| 指令边界 | 区分可信规则、用户任务和仅供处理的不可信数据，防止数据获得控制流资格。权限和副作用必须由模型外逻辑控制。 | notes/unit-08-prompt-injection.md；labs/unit-08-control-validation.md | 已掌握 | 多轮记忆、截断和多模态输入中的边界保持。 |
| 外部内容降权 | 根据来源、信任和用途降低外部内容的检索或决策影响。降权不等于事实验证、删除或权限过滤。 | notes/unit-08-prompt-injection.md；notes/unit-09-rag-architecture.md | 基本掌握 | 阈值对误报、漏报的影响。 |
| RAG | 推理时从外部知识库检索内容并临时加入模型上下文，不会在提问时修改模型参数。 | notes/unit-09-rag-architecture.md；labs/rag-security-lab/unit-09-minimal-rag.md | 已掌握 | 生产向量库和大规模数据集未验证。 |
| 切分 | 将文档拆成可索引的 Chunk。每个片段仍需保留文档 ID、版本、权限、来源和信任元数据。 | notes/unit-09-rag-architecture.md；labs/rag-security-lab/unit-09-dataset-manifest.md | 已掌握 | 切分大小与重叠策略的安全影响。 |
| Embedding | 将内容转换为可比较的向量。高相似度只支持语义接近，不证明事实正确、来源可信、上下文完整或用户有权。 | notes/unit-09-rag-architecture.md；labs/rag-security-lab/unit-09-minimal-rag.md | 已掌握 | 当前原型不是真实 embedding 模型。 |
| 向量检索 | 根据查询和文档向量的相似度召回候选片段。候选必须在进入最终上下文前完成权限、来源和版本检查。 | notes/unit-09-rag-architecture.md；labs/rag-security-lab/logs/unit-09-run.jsonl | 已掌握 | ANN 索引和多租户过滤实现。 |
| 重排 | 使用额外规则或模型调整候选顺序。排名第一仍不表示有权、可信、未过期或适合当前用途。 | notes/unit-09-rag-architecture.md；reports/unit-09-review.md | 已掌握 | 尚未比较真实重排模型。 |
| 来源追踪 | 记录片段所属文档、版本、分片和处理链，用于引用、审计、污染调查和撤销。来源可追踪不等于内容正确。 | labs/rag-security-lab/unit-09-dataset-manifest.md | 已掌握 | 跨系统 provenance 格式。 |
| 检索时鉴权 | 在无权正文进入模型上下文前，根据主体、租户、对象和范围过滤。生成后脱敏不能撤销越权读取。 | notes/unit-09-rag-architecture.md；labs/rag-security-lab/unit-09-retrieval-pollution.md | 已掌握 | 真实 IAM、ACL 和向量库过滤尚未集成。 |
| 检索污染 | 错误、过期、低信任或恶意内容进入知识库并影响召回或回答。它不修改模型参数；执行其中指令时才同时属于间接注入。 | labs/rag-security-lab/unit-09-retrieval-pollution.md；labs/rag-security-lab/logs/unit-09-pollution-run.jsonl | 已掌握 | 索引回滚、缓存失效和历史引用撤销。 |
| Agent | 模型进入目标、规划、工具、观察、再规划的行动闭环。错误可能扩大为越权读取、重复提交或持久副作用。 | notes/unit-10-agent-components-theory.md；reports/unit-10-review.md | 已掌握 | 真实 Agent 编排器和多轮集成。 |
| Tool Calling | 模型生成候选工具名和参数，服务端验证后执行。合法 JSON、确定语气或模型自报批准均不产生权限。 | notes/unit-10-tool-calling-flow-theory.md；labs/agent-tool-security/unit-10-simulator.ps1 | 已掌握 | 真实工具网关、超时和回滚。 |
| Schema 验证 | 检查字段、类型、长度、枚举、格式和额外字段。只证明结构合规，不证明身份、权限或确认有效。 | notes/unit-10-tool-contracts-theory.md；labs/agent-tool-security/unit-10-tool-specs.md | 已掌握 | 嵌套对象和契约版本演进。 |
| 服务端授权 | 使用可信会话身份和权威资源状态，按主体、工具、动作、对象、参数重新判断权限。 | notes/unit-10-tool-calling-flow-theory.md；labs/agent-tool-security/unit-10-permission-matrix.md | 已掌握 | Web/API 对象级授权和真实 IAM。 |
| 最小权限 | 只提供完成任务所需的工具、动作、对象、字段和参数能力，不能只做工具级开关。 | notes/unit-10-permission-matrix-theory.md；labs/agent-tool-security/unit-10-permission-matrix.md | 已掌握 | 临时权限、委托、撤销和跨服务传播。 |
| 人工确认 | 高影响副作用前，由可信主体批准精确动作。确认应绑定主体、工具、对象、参数摘要、有效期和一次性标识。 | notes/unit-10-tool-calling-flow-theory.md；labs/agent-tool-security/unit-10-tool-misuse-tests.md | 已掌握 | 当前只模拟布尔值，未实现确认 token。 |
| 幂等控制 | 用稳定请求标识避免重试或重复消息产生二次副作用。确认回答是否获批，幂等回答是否已执行。 | notes/unit-10-tool-calling-flow-theory.md；labs/agent-tool-security/unit-10-simulator-results.jsonl | 已掌握 | 并发、事务和 TOCTOU。 |
| 工具结果隔离 | 将工具返回作为候选数据，执行返回 Schema、字段白名单、来源标记和敏感字段裁剪。内部 API 数据也不能授权下一动作。 | notes/unit-10-agent-components-theory.md；notes/unit-10-tool-calling-flow-theory.md | 已掌握 | 流式响应、错误堆栈和多工具合并。 |
| 日志关联 | 用用例 ID、run ID、request ID、模型调用 ID、工具调用 ID、决定码和证据路径串联完整流程，同时控制日志最小化。 | notes/unit-11-application-attack-surface.md；notes/unit-13-ai-security-testing.md | 基本掌握 | 历史记录字段不统一，防篡改审计未实现。 |
| 三层攻击面 | 使用层、应用层、平台层按职责、数据流和信任边界组织风险，是分析视角而非固定部署拓扑。 | notes/unit-11-application-attack-surface-theory.md；labs/unit-11-threat-model.md | 已掌握 | 与真实 Web 网关、IAM 和渲染器的映射。 |
| STRIDE | 身份仿冒、篡改、抵赖、信息泄露、拒绝服务、权限提升六类威胁。分类本身不是漏洞事实。 | labs/unit-11-stride-matrix.md；reports/unit-11-review.md | 已掌握 | 独立完成真实 Web/API STRIDE 分析。 |
| 训练数据泄露 | 敏感内容参与训练后，模型行为暴露或允许推断相关信息。必须排除 Prompt、RAG、工具、缓存和日志等来源。 | notes/unit-12-privacy-risks-theory.md；cases/llm-security/unit-12-privacy-leakage.md | 概念已掌握、机制待实测 | 缺可控训练集、成员真值和训练实验。 |
| 上下文泄露 | 当前 Prompt、历史、RAG 或工具数据中的受保护信息越过角色、会话、用途或展示边界。复述输入本身不自动构成泄露。 | notes/unit-12-privacy-risks.md；reports/unit-12-privacy-leakage-run.jsonl | 已掌握 | 跨会话、缓存和真实会话隔离。 |
| 成员推理 | 判断一条记录是否属于训练集，需要成员/非成员真值、统计指标、基线和误差分析。 | notes/unit-12-privacy-risks-theory.md；reports/unit-12-review.md | 基本掌握、待实验 | 没有可控训练流程和对照实验。 |
| 模型反演 | 根据输出或多次查询重建输入特征、敏感属性或近似内容，需要受控真值并排除其他数据源和幻觉。 | notes/unit-12-privacy-risks-theory.md；reports/unit-12-review.md | 基本掌握、待实验 | 尚未设计实验、指标和停止条件。 |
| 数据最小化 | 只采集、检索、传输、交给模型和保存任务必需数据。工具超额返回即是控制失效，即使最终没有展示。 | notes/unit-12-privacy-risks.md；labs/unit-12-detection-rules.md | 已掌握 | 真实业务字段分级和日志平台控制。 |
| 风险评分 | 根据严重性、可复现性、影响范围和利用复杂度辅助排序。分数不是漏洞事实、发生概率或安全证明。 | labs/unit-13-risk-scoring.md；labs/unit-13-batch-scoring.md | 已掌握 | 真实业务影响需要多角色复核。 |
| 复测 | 在修复版本上执行原失败用例和回归用例，用新 run ID 保存新证据并关联旧失败，不能覆盖历史记录。 | notes/unit-13-ai-security-testing.md；reports/unit-13-review.md | 已掌握 | 缺真实修复版本和完整闭环。 |

## 3. 五组易混概念

### 3.1 Jailbreak 与 Prompt Injection

- Jailbreak 判断模型安全限制是否被绕过。
- Prompt Injection 判断不可信内容是否破坏应用任务、指令、数据、输出契约或工具边界。
- 同一场景可以同时涉及两类风险，但应分别判定。

### 3.2 检索相关与内容可信

- 相关性：片段和查询是否接近。
- 来源信任：该来源是否适合支撑当前用途。
- 权限：当前主体是否能读取。
- 高相关不能覆盖低信任或无权限。

### 3.3 模型建议与服务端授权

- 模型输出、计划、合法 JSON 和候选参数都只是建议。
- 服务端必须从可信会话取得身份，并按主体、工具、动作、对象和参数重新授权。

### 3.4 上下文复述与训练数据泄露

- 当前输入、历史、RAG 或工具返回已经包含某值时，模型复述首先由上下文解释。
- 上下文泄露还需证明数据受保护并越过权限、会话、用途或展示边界。
- 训练数据泄露需排除其他来源，并依赖真值、对照组、统计分析和模型版本证据。

### 3.5 风险分数与漏洞事实

- 状态描述实际结果：通过、失败、阻断、待实测或未执行。
- 分数描述处置优先级；证据成熟度描述结论由设计、单次观察、稳定复现还是真实集成支持。
- 设计阶段预评分 18 分的注入用例仍是高优先级待实测项；执行后看到载荷但被阻断，才是已观察的注入尝试和应用阻断。

## 4. 阶段 3 继续补强项

| 优先级 | 薄弱项 | 当前依据 | 补强目标 |
|---|---|---|---|
| P0 | 认证、授权和对象级权限 | 能解释概念，尚无真实 HTTP/API 证据 | 能从主体、会话、动作和对象定位越权并设计服务端检查点 |
| P0 | HTTP、Cookie、Session 和状态码 | 三层模型已有，Web 链路证据不足 | 记录本地请求并解释身份保持、错误和授权决定 |
| P0 | 真实 Agent、IAM 和工具网关 | 当前只有 PowerShell 确定性模拟器 | 验证身份、Schema、对象权限、确认、幂等和审计的真实调用链 |
| P1 | SSRF 与 URL 工具边界 | 当前工具不联网 | 学习 URL 解析、重定向、DNS、内网地址和出站控制 |
| P1 | XSS、Markdown/HTML 与输出编码 | 未接真实浏览器渲染器 | 区分文本、Markdown 和 HTML 边界并验证编码位置 |
| P1 | 生产型 RAG 检索和撤销 | 当前是字符二元组模拟，回滚未动态实测 | 验证真实 Embedding、过滤、重排、缓存失效和撤销链 |
| P1 | 并发幂等、事务和 TOCTOU | 当前为单线程固定分支 | 设计重复请求、并发状态变化和检查执行竞态实验 |
| P2 | 成员推理与模型反演 | 只有概念与待实测用例 | 建立真值、对照、指标、误差分析和停止条件 |
| P2 | 修复与复测闭环 | 已有方法，缺真实修复版本 | 保留旧失败，用新 run ID 完成修复前后和回归比较 |

## 5. 步骤 1 验收

| 计划要求 | 实际成果 | 验证证据 | 验收结论 | 剩余限制 |
|---|---|---|---|---|
| 至少 20 个术语且每项关联本地文件 | 整理 31 个术语，记录定义、边界、证据、掌握状态和问题 | 本文第 2 节及学习单元 8–13 本地文件 | 通过 | 真实平台覆盖有限 |
| 至少 5 项阶段 3 薄弱知识 | 列出 9 项并设置优先级和目标 | 本文第 4 节及 unit 9–13 复盘 | 通过 | 优先级将在阶段 3 准备中再复核 |
| 五组易混概念明确区分 | 完成五组定义和结论边界 | 本文第 3 节及本步骤闭卷问答 | 通过 | 成员推理、反演和真实授权链仍缺实测 |

步骤 1 验收结论：术语、易混概念和薄弱项均已形成可复核记录，可以进入步骤 2。概念掌握不等于真实平台验证；模拟器通过不等于真实集成通过；待实测或高风险评分不等于已确认漏洞。
