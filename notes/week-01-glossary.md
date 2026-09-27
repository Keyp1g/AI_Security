# 第 1 周统一术语表

> 对应计划：Day 7，第 2 时段（统一术语表）
> 状态说明：`能复现` 表示已有本地实验链；`了解（需复习）` 表示能描述定义，但边界、机制或证据仍需巩固。

| 术语 | 定义 | 易混概念与边界 | 安全意义 | 证据文件 | 掌握状态 |
|---|---|---|---|---|---|
| LLM | 在大量文本上训练、根据输入 Token 和已有参数预测后续 Token 并生成文本的模型 | LLM 是模型，不等于包含鉴权、知识库和工具的完整应用 | 输出具有概率性且可能错误，必须当作待验证内容 | `notes/day-02-llm-basics.md`；`labs/day-02-output-comparison.md` | 能复现 |
| Token | 模型处理文本时使用的离散单位，可能是字、词的一部分或符号 | 不等于“一个汉字”或“一个单词”；字符数不能直接代替 Token 数 | 影响上下文容量、截断、成本和规则是否仍在有效窗口 | `notes/day-02-llm-basics.md`；`cases/llm-security/day-02-llm-failures.md` | 了解（需复习） |
| 上下文窗口 | 一次推理中模型可接收和处理的 Token 范围 | 窗口容量不等于模型一定会同等利用所有位置；工程裁剪也不等于模型遗忘 | 规则或证据被截断、淹没或忽略时可能造成任务偏移 | `labs/day-02-output-comparison.md`；`notes/day-06-jailbreak-theory.md` | 能复现（需复习边界） |
| 推理 | 模型在参数固定时，根据当前上下文计算并生成输出的过程 | 不等于训练；普通推理不会因为一次对话自动更新模型参数 | 推理结果受上下文和采样影响，不能把一次输出当作稳定保证 | `notes/day-02-llm-basics.md`；`reports/day-02-review.md` | 了解 |
| Prompt | 交给模型的任务、上下文、约束和输出要求 | Prompt 能表达意图，但不能强制实现身份认证、对象授权或工具隔离 | Prompt 不应成为唯一安全控制；输出仍需解析和校验 | `notes/day-03-prompt-and-instructions.md`；`labs/day-03-prompt-variants.md` | 能复现 |
| System Prompt | 由模型服务或应用设置的高层行为说明 | 优先级较高不代表不可被误解，也不是真实权限边界 | 可约束模型行为，但不能代替服务端鉴权、允许列表和审批 | `notes/day-03-prompt-and-instructions.md`；`reports/day-03-prompt-variants-run.jsonl` | 能复现 |
| Developer Prompt | 由应用开发者提供、用于定义产品行为和任务规则的指令 | 与 System Prompt 职责相近但层级不同；不能把外部文档当作 Developer 指令 | 用于稳定应用行为，但敏感操作必须由确定性代码控制 | `notes/day-03-prompt-and-instructions.md` | 了解（需复习） |
| User Prompt | 用户在当前请求中表达的目标和输入 | 用户声称“我是管理员”仍是不可信输入，不会自动获得更高权限 | 必须经过输入分类、身份绑定、对象授权和参数验证 | `notes/day-03-prompt-and-instructions.md`；`cases/llm-security/prompt_quality_cases.md` 中 `LLM-003-16` | 能复现 |
| 上下文学习 | 模型根据当前 Prompt 中的示例或说明临时调整本次回答方式 | 不更新模型参数；微调会通过训练更新参数 | 恶意示例也可能改变当前行为，因此示例和外部内容都需视为不可信输入 | `notes/day-02-llm-basics.md` | 了解（需复习） |
| 幻觉 | 模型生成听起来合理、但与事实、上下文或可用证据不一致的内容 | “未证实”不等于“错误”；流畅、具体或自信也不等于真实 | 可造成错误引用、错误安全建议和错误业务决定，需要来源核验与降级 | `notes/day-04-hallucination-bias.md`；`reports/day-04-hallucination-run.jsonl` | 能复现 |
| 偏见 | 模型对群体、标签或情境表现出无法由任务条件解释的系统性差异 | 单个 A/B 差异只是候选信号，不足以证明系统性偏见 | 影响公平性、合规和高影响决策，需要控制变量、重复测试和人工复核 | `cases/llm-security/day-04-hallucination-bias.md`；`reports/day-04-fairness-run.jsonl` | 能复现（需复习统计边界） |
| 过度拒答 | 模型错误拒绝本可安全帮助的正常或防御性请求 | 不等于安全性更高；应与正确拒答、不足拒答分别评价 | 会降低可用性并掩盖边界识别不足 | `labs/day-06-refusal-quality.md`；`cases/llm-security/jailbreak_safety_cases.md` 中 `LLM-006-09/10` | 能复现 |
| 不足拒答 | 面对明确越界、未授权或高风险请求时，模型仍提供了不应提供的帮助 | 与“回答不准确”不同，核心是安全边界没有被保持 | 可能直接促成未授权行为，应进行意图识别、输出审查和安全替代 | `cases/llm-security/day-02-llm-failures.md` 中 `Case-02-08`；`notes/day-06-jailbreak-theory.md` | 了解 |
| 安全对齐 | 通过训练和策略使模型更倾向于遵循人类意图、价值和安全规则 | 是行为优化，不是形式化安全证明，也不等于应用层防护 | 必须叠加鉴权、最小权限、输出验证、审计和人工复核 | `notes/day-06-jailbreak-theory.md`；`reports/day-06-review.md` | 了解（需复习） |
| Jailbreak | 通过设计输入或对话诱导模型绕过原本应遵守的内容或行为安全限制 | 角色扮演、编码和长文本只是策略；是否成功取决于实际输出是否越界 | 说明模型拒答不能作为唯一防线，需要多层控制和对抗评估 | `notes/day-06-jailbreak-theory.md`；`reports/day-06-jailbreak-safety-run.jsonl` | 能复现 |
| Prompt Injection | 不可信输入试图覆盖上层指令、劫持应用预定任务或影响工具调用 | Jailbreak 关注内容/行为安全边界；Injection 关注指令与数据、应用任务边界；二者可重叠 | 外部网页、邮件和 RAG 文档都应作为不可信数据，工具执行需独立授权 | `notes/day-06-jailbreak-theory.md`；`reports/day-06-review.md` | 了解（需专门实验） |

## 本周优先复习项

1. **Token 与上下文窗口**：复测时必须记录 Token、截断策略和关键信息位置，不能用字符数直接推断窗口行为。
2. **偏见**：当前只有五对单次 A/B 结果；必须区分随机差异、截断、格式失败和系统性不公平。
3. **安全对齐**：记住“提高安全行为倾向”不等于“证明系统安全”。
4. **Developer Prompt**：需要继续巩固它与 System、User、外部数据的职责边界。
5. **Prompt Injection**：目前只有概念与分类证据，专门的本地模拟安排在第 2 周。

## 第 2 时段验收

- [x] 共 16 个术语，每项包含定义、易混边界、安全意义、证据和状态。
- [x] 明确区分 Jailbreak 与 Prompt Injection。
- [x] 标出至少 3 个需复习项。
- [x] 未把“了解概念”误写成“已防护真实系统”。
