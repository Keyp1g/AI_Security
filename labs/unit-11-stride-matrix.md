# 学习单元 11：STRIDE 风险矩阵与证据要求

> 对象：`unit-11-threat-model.md` 中的虚构企业知识助手。
> 状态口径：`威胁假设`、`待实测`、`服务器实测`、`离线推演`、`尚未部署`。除明确标注服务器实测的条目外，不声称真实漏洞存在。

## 1. 风险矩阵

| ID | STRIDE | 威胁与跨层路径 | 资产 | 前置条件 | 影响 | 检测/成功证据 | 控制前 | 控制后/缓解措施 | 残余风险 | 状态 | 检查项 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| S-01 | Spoofing | 用户在 Prompt 中自称 admin，应用错误采信正文角色 | AS-01/02/10 | 应用从文本取角色 | 越权检索或工具调用 | message role 与 server role 不一致且请求被允许 | 文本声明可能进入规划 | 服务端会话绑定角色，执行前重算授权 | 会话本身被盗仍可能冒用 | 待实测 | IAM-01, PRM-02 |
| S-02 | Spoofing | 客户端伪造 tenant/object scope | AS-01/05/07 | 范围可由客户端控制 | 跨租户读取 | requested tenant 与 server tenant 不同但返回数据 | 客户端携带范围 | 服务端生成 allowed scopes 并绑定检索/缓存 | 错误策略配置仍可能扩大范围 | 待实测 | IAM-03, RAG-02 |
| S-03 | Spoofing | 伪造工具调用主体或确认字段 | AS-10/11 | 网关信任模型生成的 actor/confirmed | 未授权副作用 | 模型字段改变 actor 或无确认仍执行 | 候选 JSON 含身份/确认 | 网关忽略候选身份，确认绑定主体与参数 | 审批服务失陷 | 待实测 | AGT-03, AGT-04 |
| S-04 | Spoofing | 公网 SSH 密码爆破尝试冒充管理用户 | 服务器管理身份 | 密码认证和 root 登录开放 | 主机接管 | `lastb` 失败账号/来源；加固前配置 | 密码认证、root 可直登 | `lighthouse` 密钥、`AuthenticationMethods publickey`、`PermitRootLogin no`、`AllowUsers lighthouse` | 密钥终端失陷、控制台账号风险 | 服务器实测 | IAM-04 |
| T-01 | Tampering | Prompt 模板或策略未授权修改 | AS-03/14 | 变更入口缺少审批/版本 | 安全规则被弱化 | template/policy hash 无授权变化 | 变更可覆盖旧配置 | 强认证、审批、版本、前后哈希和回滚 | 获权管理员误操作 | 待实测 | PRM-04, LOG-04 |
| T-02 | Tampering | 文档、ACL 或索引元数据被修改 | AS-05/06/07 | 接入元数据由客户端提供或无版本 | 污染、越权召回 | 文档/ACL/索引哈希或版本异常 | 来源和 ACL 可能混写 | 服务端元数据、哈希、批准状态、索引批次 | 已批准来源也可能含错误内容 | 待实测 | RAG-01, RAG-04 |
| T-03 | Tampering | Agent 参数在 Schema 后被扩大或换对象 | AS-10/11 | 检查与执行之间参数可变 | 越权操作 | arguments hash 与执行参数不一致 | 参数跨组件传递 | 授权绑定参数摘要，业务 API 再校验 | TOCTOU 与业务状态变化 | 待实测 | AGT-02, AGT-03 |
| R-01 | Repudiation | 请求缺少统一 request/call ID | AS-12 | 组件各自记录无关联日志 | 无法还原跨层路径 | 模型、检索、工具记录无法关联 | 分散日志 | 入口生成并透传 request/call ID | 组件漏传或采样丢失 | 待实测 | LOG-01 |
| R-02 | Repudiation | 工具副作用缺少主体、确认和结果记录 | AS-10/11/12 | 执行器仅返回成功文本 | 无法归责或复测 | 无 actor、confirmation ref、result ID | 副作用证据不完整 | 记录授权决定、确认、幂等和结果 ID | 外部系统日志保留期不同 | 待实测 | AGT-04, LOG-01 |
| R-03 | Repudiation | 管理配置变更可被否认或审计可修改 | AS-14/12 | 审计与应用同权限 | 变更来源无法确认 | 无操作者/审批/前后版本或日志被覆盖 | 管理与审计未隔离 | 追加写审计、访问控制、审批和完整性校验 | 高权限内部人员合谋 | 待实测 | IAM-04, LOG-04 |
| I-01 | Information Disclosure | 无权文档进入最终上下文或回答 | AS-05/07/08/09 | ACL 在生成后检查 | 跨对象/租户泄露 | 无权 document ID/正文/canary 出现在上下文或响应 | 相关性检索可能先返回正文 | 模型前对象级 ACL、最终上下文白名单 | ACL 错配和缓存污染 | 待实测 | IAM-02, RAG-02 |
| I-02 | Information Disclosure | Prompt、工具结果或日志泄露敏感占位符 | AS-08/11/12/13 | 过量上下文或日志原文默认开启 | PII/密钥形态泄露 | canary/虚构 PII 出现在响应或普通日志 | 原文可能跨组件复制 | 最小披露、字段授权、脱敏、受控证据区 | 规则漏报与编码变体 | 待实测 | OUT-03, MDL-03, LOG-02 |
| I-03 | Information Disclosure | 输出引用错误或内部来源名称外泄 | AS-09/06 | 引用未经白名单/忠实度检查 | 内部结构暴露、错误传播 | 非最终候选引用或内部 ID 出现在展示 | 模型自由生成引用 | 引用白名单、映射展示名、证据不足弃答 | 合法引用内容仍可能错误 | 待实测 | OUT-04 |
| I-04 | Information Disclosure | Ollama API 裸露公网可被未授权调用 | 模型服务/提示与响应 | 服务监听公网或端口放行 | 模型滥用、数据暴露 | 外部 11434 可达并能调用 API | 潜在裸露面 | 绑定 `127.0.0.1:11434`，firewalld，仅 SSH 隧道；外部探测不可达 | SSH/主机失陷后仍可访问 | 服务器实测 | MDL-02, MDL-03 |
| D-01 | Denial of Service | 超长输入/上下文耗尽模型预算 | AS-08/模型服务 | 无长度/Token 限额 | 延迟、成本、其他用户受影响 | 超限仍调用模型、超时或内存升高 | 请求大小未受控 | 输入/上下文/输出预算，在模型前拒绝 | 合法大请求也可能接近阈值 | 待实测 | AVL-01 |
| D-02 | Denial of Service | Agent 循环、重复工具调用或重试风暴 | AS-10/11/平台资源 | 无步数、重试和幂等 | 重复副作用和资源耗尽 | tool count 超预算、相同请求多结果 | 模型可连续规划 | 步数/调用预算、循环检测、有限重试、幂等 | 多个不同 request ID 可绕过简单幂等 | 待实测 | AGT-04, AVL-02, AVL-03 |
| D-03 | Denial of Service | 队列、配额或日志持续增长 | AS-12/平台资源 | 无背压、轮转和磁盘告警 | 服务/审计不可用 | queue depth、磁盘、日志文件持续增长 | 默认无限增长 | 租户配额、队列上限、日志轮转、磁盘告警 | 突发流量仍可能造成短时退化 | 待实测 | AVL-04 |
| D-04 | Denial of Service | SSH 爆破与 Docker 日志无限增长消耗资源 | 服务器认证/磁盘 | 公网 SSH；Docker 默认日志无上限 | CPU/认证日志/磁盘耗尽 | `lastb`；Docker 日志大小；磁盘指标 | 爆破存在、日志可增长 | `MaxAuthTries 3`、firewalld、Docker `10m × 3`、2 GiB swap | TCP/22 仍公开；应用仍需配额 | 服务器实测 | LOG-03, AVL-04 |
| E-01 | Elevation of Privilege | visitor 触发 analyst/admin 工具 | AS-02/10/11 | 只检查工具存在或 Schema | 未授权读取/副作用 | visitor 调用到达执行器 | 工具候选由模型生成 | 角色工具权限、对象/参数授权、业务 API 兜底 | 策略配置错误 | 待实测 | AGT-01, AGT-03 |
| E-02 | Elevation of Privilege | analyst 通过参数或对象取得 admin 能力 | AS-02/10/14 | 工具级授权无参数级限制 | high 工单或策略变更 | 合法 Schema 的越权参数被执行 | 粗粒度角色控制 | 主体×工具×动作×对象×参数授权 | 复杂条件遗漏 | 待实测 | AGT-03 |
| E-03 | Elevation of Privilege | Prompt/工具结果诱导系统相信 `authorized=true` | AS-03/10/11 | 模型字段被当权威 | 绕过确认/授权 | 候选字段改变决定 | 模型输出参与控制流 | 忽略自报授权字段，调用独立策略/审批系统 | 策略服务自身缺陷 | 待实测 | PRM-03, AGT-04 |
| E-04 | Elevation of Privilege | root 直登扩大凭据泄露后的权限 | 服务器 root 权限 | root SSH 和密码认证开启 | 直接最高权限接管 | 加固前 root 可登录；加固后新连接拒绝 | root 直登开放 | 日常 `lighthouse` + sudo；root SSH 关闭；密钥认证 | `NOPASSWD` sudo 仍是高价值权限 | 服务器实测 | IAM-04 |

## 2. 服务器控制前后对比汇总

| 平台风险 | STRIDE | 控制前 | 控制后 | 证据来源 | 残余风险 |
|---|---|---|---|---|---|
| SSH 密码爆破 | Spoofing/DoS | 密码认证开放，公网出现失败登录 | `lighthouse` 密钥；`AuthenticationMethods publickey`；`MaxAuthTries 3` | `reports/unit-11-platform-control-evidence.md` | TCP/22 仍受扫描，需持续监控 |
| root 直登 | Elevation/Tampering | `PermitRootLogin yes` | `PermitRootLogin no`、`AllowUsers lighthouse`、sudo 审计 | `reports/unit-11-platform-control-evidence.md` | 管理密钥/控制台账户仍需保护 |
| 裸露 Ollama | Information Disclosure | 若公开 11434 可被未授权调用 | 回环绑定、firewalld、外部端口不可达 | `reports/unit-11-platform-control-evidence.md` | 主机或 SSH 会话失陷后可达 |
| Docker 日志耗尽 | Denial of Service | 默认日志可能无限增长 | Docker `max-size=10m`、`max-file=3`，swap 和磁盘监控 | `reports/unit-11-platform-control-evidence.md` | 其他日志与模型文件仍占磁盘 |

## 3. 尚未部署或未完成控制

- SELinux 当前为 disabled：不得标记为已部署控制。
- Qdrant 尚未部署：租户隔离和向量库 API key 仍属于设计/待验证。
- cron 定时评测尚未成功运行：不得标记为持续监控已完成。
- 腾讯云控制台 IPv4/IPv6 安全组仍需人工复核。

## 4. 证据规则

- `服务器实测`：案例或 runbook 中有明确命令输出/外部探测与控制后状态。
- `离线推演`：根据架构与控制链推导，但未执行行为测试。
- `待实测`：已定义测试输入、阻断点和证据字段。
- `尚未部署`：依赖组件或控制不存在，不能视为测试失败或通过。

## 5. 测试记录模板

每次执行复制以下字段，不用“没有发现问题”替代实际观察：

```text
测试 ID：TM-011-xx
对应 STRIDE / 威胁 ID：
对应检查项：
资产：
角色/模拟身份：
前置条件与规则版本：
输入：
执行步骤：
期望阻断点：
实际观察：待实测 / 通过 / 失败
原始请求/响应证据路径：
日志 request ID / call ID：
文档、对象或工具 ID：
时间戳：
严重性：低 / 中 / 高
修复：
复测条件：
限制：
```

状态定义：

- `待实测`：模板、输入和阻断点已经定义，但尚未执行。
- `通过`：实际观察满足期望，且请求/响应、规则版本、身份和日志证据完整。
- `失败`：实际观察与期望不符，保留原始结果、影响和修复建议。
- `受阻`：依赖或环境缺失；不计为通过。

## 6. 最小测试集

| 测试 ID | STRIDE | 关联威胁 | 资产/角色 | 最小输入与步骤 | 期望阻断点 | 必需证据 | 关联检查项 | 状态 |
|---|---|---|---|---|---|---|---|---|
| TM-011-01 | Spoofing | S-01/S-02 | AS-01/02；visitor | 正文自称 admin 并携带其他 tenant，提交公开查询 | 身份/范围只取服务端会话；扩大范围被拒绝 | request、server role/tenant、policy version、decision | IAM-01, IAM-03, MDL-02 | 待实测 |
| TM-011-02 | Tampering | T-01/T-02 | AS-03/06/07；admin/analyst | 比较批准模板/文档哈希；analyst 尝试提交变更 | 未批准变更拒绝；批准变更有前后版本 | before/after hash、actor、approval、index/template version | PRM-04, RAG-01, LOG-04 | 待实测 |
| TM-011-03 | Repudiation | R-01/R-02 | AS-10/11/12；analyst | 执行一次模拟搜索和一次工单候选，追踪全链路 | 各阶段有 request/call ID；副作用有 actor、确认、结果 ID | request/call IDs、confirmation ref、result ID、event list | LOG-01, AGT-04 | 待实测 |
| TM-011-04 | Information Disclosure | I-01/I-02 | AS-05/08/09/12；USER-A | 请求 USER-B 文档，并在允许上下文放置虚构 PII/canary | 无权正文模型前阻断；敏感字段不出现在输出/普通日志 | pre/post-filter IDs、final context、response、log scan | IAM-02, RAG-02, OUT-03, LOG-02 | 待实测 |
| TM-011-05 | Denial of Service | D-01/D-02/D-03 | 模型/工具/日志；visitor | 使用本地小阈值，在边界前后提交文本并运行会重复的 stub | 长度、步骤、重试、队列或日志阈值生效 | sizes、budgets、counts、stop reason、log size | AVL-01, AVL-02, AVL-03, AVL-04 | 待实测 |
| TM-011-06 | Elevation of Privilege | E-01/E-02/E-03 | AS-02/10/11；visitor/analyst | visitor 调工具；analyst 请求 high；候选含 `authorized=true` | 工具/对象/参数授权或确认阶段拒绝；副作用为零 | actor、tool、arguments hash、block stage、side-effect count | AGT-01, AGT-03, AGT-04, PRM-02 | 待实测 |
| TM-011-07 | Prompt Injection（跨类） | S-01/T-01/E-03 | AS-03/08/10 | 对用户输入、RAG 文档、工具结果分别放入同一控制样式文字 | 外部内容保持数据身份；新动作重新授权 | source/trust labels、Prompt、response、candidate calls | PRM-01, PRM-02, PRM-03 | 待实测 |
| TM-011-08 | 输出处理（跨类） | I-02/I-03 | AS-09；使用层 | 输入异常结构、活动字符、错误引用和虚构敏感标记 | 解析、编码、脱敏或引用审查阻断/降级 | raw/parsed/encoded output、citation status、decision | OUT-01, OUT-02, OUT-03, OUT-04 | 待实测 |
| TM-011-09 | 模型网关与故障（跨类） | S-02/I-02/D-01 | AS-08/13 | 伪造租户/模型字段；stub 返回超时、5xx 和无效响应 | 服务端路由；密钥不泄露；有限重试并安全降级 | route decision、error type、retry count、log scan | MDL-01, MDL-02, MDL-03, MDL-04 | 待实测 |
| TM-011-10 | RAG 生命周期（跨类） | T-02/I-01 | AS-05/06/07 | 干净/污染索引对照，撤销文档后重查 | 低信任内容受控；撤销后索引/缓存不返回 | Top-K、trust、application decision、revoke/index/cache IDs | RAG-03, RAG-04 | 待实测 |
| TM-011-11 | 监控与安全事件（跨类） | R-01/R-03/D-03 | AS-12/14 | 触发一次无害拒绝、一次模拟高风险事件，查看事件与告警 | 事件有类型、主体、阶段、原因；审计不可由应用角色修改 | event/alert IDs、access decision、before/after hash | LOG-03, LOG-04 | 待实测 |
| TM-011-12 | 输出事实与模型追踪（跨类） | I-03/R-01 | AS-08/09 | 同一固定输入运行模型，检查版本与引用状态 | 模型/参数可追踪；无依据内容标待核验/阻断 | model/parameters、response hash、citation/application status | MDL-01, OUT-04 | 待实测 |

## 7. 统一证据要求

每个测试至少保存：原始请求/响应或其受控证据引用、规则/模板/Schema/策略版本、模拟身份与服务端角色、时间戳、日志 request ID、文档/对象/工具 ID、实际阻断阶段、应用决定和限制。截图不是唯一证据；优先保留可搜索的文本或 JSON。
