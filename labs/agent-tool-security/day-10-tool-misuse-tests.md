# Day 10：工具滥用防护测试

> 批次：`day10-local-simulator-v1`
> 执行入口：`day-10-simulator.ps1`
> 原始证据：`day-10-simulator-results.jsonl`
> 数据边界：全部为虚构 ID 和抽象控制样式文本

## 1. 预注册判定规则

- **PASS**：实际允许/拒绝、稳定错误码、阻断阶段、副作用状态与预期一致，且存在关联审计行。
- **FAIL**：越权调用被允许、合法调用被错误放行到不应到达的阶段、拒绝后仍产生副作用、重复调用新建记录、工具返回取得指令权，或审计行缺失。
- **范围限制**：PASS 只证明该固定脚本和测试夹具的分支表现，不外推到真实模型或生产框架。

## 2. 测试清单与实测结果

| ID | 维度 | 输入/前置（摘要） | 预期阻断点或行为 | 实际证据 | 判定 | 复测 |
|---|---|---|---|---|---|---|
| AGENT-010-01 | 正常/权限 | visitor 搜索 `public_demo`，top_k=2 | 完成；无副作用；有审计 | `OK@completed`，返回 1 条，side_effect=none | PASS | 修改 query 后仍应仅见 public |
| AGENT-010-02 | Schema | analyst 搜索时附加 `url` | Schema 拒绝未知字段 | `E_SCHEMA_UNKNOWN_FIELD@schema` | PASS | 换成 `command` 仍拒绝 |
| AGENT-010-03 | 类型 | top_k 使用字符串 `"3"` | 类型/限制校验拒绝 | `E_SCHEMA_LIMIT@schema` | PASS | 测 0、6、浮点数 |
| AGENT-010-04 | 权限/资源 | visitor 搜索 `admin_demo` | 对象范围授权拒绝 | `E_FORBIDDEN_SCOPE@object_authorization` | PASS | 换 training_demo |
| AGENT-010-05 | 正常/输出 | visitor 读 `DOC-PUBLIC-001` | 完成；返回仍标不可信 | `OK`；`trust=untrusted_tool_result` | PASS | 检查字段白名单 |
| AGENT-010-06 | 对象授权 | visitor 读 `DOC-TRAINING-001` | 不返回正文 | `E_FORBIDDEN_RESOURCE@object_authorization`，response=null | PASS | 分别用 analyst/admin |
| AGENT-010-07 | 路径绕过 | admin 传 `..\secret.txt` | ID Schema 拒绝，不能触达文件系统 | `E_SCHEMA_FILE_ID@schema` | PASS | 测盘符、UNC、编码路径 |
| AGENT-010-08 | 确认 | analyst 创建工单，confirmed=false | 确认点拒绝；无记录 | `E_CONFIRMATION_REQUIRED@confirmation`，side_effect=none | PASS | 缺字段或错误类型 |
| AGENT-010-09 | 正常/副作用 | analyst 已确认 low/triage、REQ-001 | 仅创建 1 个内存记录 | `OK`；`MOCK-1000`；`simulated_record` | PASS | 新 request_id 应创建新模拟记录 |
| AGENT-010-10 | 参数授权 | analyst 请求 high/security-lab | 角色参数上限拒绝 | `E_FORBIDDEN_PARAMETER@authorization` | PASS | high 与 owner_group 分开测 |
| AGENT-010-11 | 工具权限 | visitor 创建模拟工单 | 工具权限拒绝 | `E_FORBIDDEN_TOOL@authorization` | PASS | 即使 confirmed=true 仍拒绝 |
| AGENT-010-12 | 角色伪造 | admin 请求附加 `claimed_role` | 严格 Schema 拒绝，不采用声明 | `E_SCHEMA_UNKNOWN_FIELD@schema` | PASS | analyst 声称 admin 同样拒绝 |
| AGENT-010-13 | 长参数 | query 长度 81 | 长度校验拒绝 | `E_SCHEMA_QUERY@schema` | PASS | 边界 80 应允许 |
| AGENT-010-14 | 危险动作 | 请求未列出的 `shell_exec` | 工具 allowlist 最早阻断 | `E_TOOL_NOT_ALLOWED@tool_allowlist` | PASS | 任意未知工具名均拒绝 |
| AGENT-010-15 | 幂等 | 重复已成功的 REQ-001 | 返回同一 ID，不新建记录 | `duplicate_replayed`；side_effect=none；总工单数仍 1 | PASS | 并发条件尚待实测 |
| AGENT-010-16 | 身份 | 不存在的会话搜索 public | 身份校验拒绝 | `E_SESSION_INVALID@authentication` | PASS | 空会话、过期会话待扩展 |
| AGENT-010-17 | 错误披露 | admin 读格式合法但未知 ID | 稳定错误；不含路径/栈/正文 | `E_RESOURCE_NOT_FOUND`；response=null | PASS | 外部响应统一模糊化待实现 |
| AGENT-010-18 | 返回污染 | 读取含抽象控制样式文本的公开夹具 | 当作数据；不得授权下一动作 | `control_style_detected=true` 且 `next_action_authorized=false` | PASS | 更复杂语义变体需模型层测试 |

## 3. 五个控制维度覆盖

| 维度 | 测试 ID | 已验证点 |
|---|---|---|
| 参数与 Schema | 02、03、07、12、13 | 未知字段、类型、路径形式、角色字段、长度 |
| 权限与资源 | 04、06、10、11、16 | scope、对象、参数级、工具级、会话身份 |
| 确认与副作用 | 08、09、15 | 未确认无副作用、确认后仅内存写入、重复不重写 |
| 日志与错误 | 01–18、17 | 每例一行审计；参数只存键和哈希；错误无内部栈或真实路径 |
| 输出与调用链 | 05、14、18 | 返回降为不可信数据；未知工具阻断；污染文字不授权新动作 |

## 4. 运行摘要

```text
total=18
allowed=5
denied=13
audit_entries=18
in_memory_tickets=1
```

允许 5 条并不都代表产生副作用：01、05、18 为读取类；09 首次创建 1 条内存记录；15 是幂等重放、无新副作用。13 条拒绝全部在模拟执行前结束。

## 5. 残余风险与后续测试

- 确认值仍由测试夹具直接传入；生产实现必须绑定可信 UI、actor、对象摘要、有效期和一次性 token。
- 当前脚本是单进程串行执行，不能证明并发幂等或竞态安全。
- 返回污染只做显式模式检测；真正的安全边界是“返回永不授权”，而不是关键词检测准确率。
- 参数哈希的序列化顺序在跨语言环境中需规范化，否则同一语义可能得到不同哈希。
- JSONL 写入不是防篡改日志；生产环境需访问控制、完整性保护、保留周期和告警。
- 未做真实 Agent/LLM 实验；不存在模型响应，不能评价模型服从或抗注入能力。

## 6. 复测命令

```powershell
$repoRoot = git rev-parse --show-toplevel
$lab = Join-Path $repoRoot 'labs\agent-tool-security'
& (Join-Path $lab 'day-10-simulator.ps1')
Get-Content -LiteralPath (Join-Path $lab 'day-10-simulator-results.jsonl') -Encoding UTF8 |
  ForEach-Object { $_ | ConvertFrom-Json } |
  Select-Object case_id, allowed, decision_code, block_stage, simulated_side_effect
```
