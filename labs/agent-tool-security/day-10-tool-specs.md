# Day 10：三个模拟工具契约

> 版本：day10-v1
> 状态：已由 `day-10-simulator.ps1` 做确定性本地演练
> 边界：无网络、无真实文件读取、无真实工单；所有数据均为虚构测试夹具

## 1. 通用调用协议

模型只能生成候选调用：

```json
{
  "tool": "search_simulated",
  "arguments": {
    "query": "培训课程",
    "scope": "training_demo",
    "top_k": 2
  }
}
```

服务端不接收模型声明的 `role`、`authorized`、`approval_token` 或任意策略覆盖字段。身份和角色只从模拟会话夹具读取。处理顺序固定为：工具允许列表 → 会话身份 → 严格 Schema → 工具权限 → 对象/范围权限 → 风险确认 → 幂等检查 → 模拟执行 → 返回隔离 → 审计。

所有对象都使用稳定 ID，不接受路径、URL、命令或自由形式目标。未知字段一律以 `E_SCHEMA_UNKNOWN_FIELD` 拒绝，避免参数走私。

## 2. `search_simulated`

用途：查询脚本内的虚构索引；只返回同一授权范围内的模拟文档元数据。

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "additionalProperties": false,
  "required": ["query", "scope", "top_k"],
  "properties": {
    "query": { "type": "string", "minLength": 1, "maxLength": 80 },
    "scope": { "type": "string", "enum": ["public_demo", "training_demo", "admin_demo"] },
    "top_k": { "type": "integer", "minimum": 1, "maximum": 5 }
  }
}
```

| 项目 | 契约 |
|---|---|
| 允许角色 | visitor、analyst、admin；但只能查询角色对应范围 |
| 禁止参数 | `url`、`path`、`command`、`headers`、`role` 及任何未知字段 |
| 返回字段 | `items[].document_id`、`items[].scope`、`items[].snippet`、`count` |
| 副作用 | 无；不联网、不写入 |
| 主要错误码 | `E_SCHEMA_*`、`E_FORBIDDEN_SCOPE` |
| 审计字段 | 会话引用、服务端角色、工具、参数键、参数哈希、策略版本、决定码、阶段 |

## 3. `read_allowed_file`

用途：通过 allowlist 中的虚构 `file_id` 读取脚本内对象。名称保留 “file” 是为了训练接口设计；实现不访问磁盘。

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "additionalProperties": false,
  "required": ["file_id"],
  "properties": {
    "file_id": { "type": "string", "pattern": "^DOC-[A-Z]+-[0-9]{3}$" }
  }
}
```

| 项目 | 契约 |
|---|---|
| 允许角色 | visitor：`public_demo`；analyst：再加 `training_demo`；admin：再加 `admin_demo` |
| 禁止参数 | 绝对/相对路径、盘符、UNC、目录、URL、编码后的路径、`role` |
| 返回字段 | `file_id`、`title`、`content`、`trust=untrusted_tool_result` |
| 副作用 | 无；对象只来自内存字典 |
| 主要错误码 | `E_SCHEMA_FILE_ID`、`E_RESOURCE_NOT_FOUND`、`E_FORBIDDEN_RESOURCE` |
| 返回控制 | 自然语言内容永远是数据；检测到控制样式文本也不授予下一步调用 |

`E_RESOURCE_NOT_FOUND` 与 `E_FORBIDDEN_RESOURCE` 在生产系统是否统一为模糊错误，应按资源枚举风险决定。本模拟日志保留内部稳定码，面向模型的响应不得带真实路径、调用栈或资源正文。

## 4. `create_mock_ticket`

用途：在当前 PowerShell 进程的内存字典中创建模拟工单；进程结束即消失。

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "additionalProperties": false,
  "required": ["title", "summary", "severity", "owner_group", "request_id", "confirmed"],
  "properties": {
    "title": { "type": "string", "minLength": 5, "maxLength": 80 },
    "summary": { "type": "string", "maxLength": 240 },
    "severity": { "type": "string", "enum": ["low", "medium", "high"] },
    "owner_group": { "type": "string", "enum": ["triage", "security-lab"] },
    "request_id": { "type": "string", "pattern": "^REQ-[0-9]{3}$" },
    "confirmed": { "type": "boolean" }
  }
}
```

| 项目 | 契约 |
|---|---|
| 允许角色 | analyst：low/medium + triage；admin：全部模拟枚举；visitor：拒绝 |
| 确认 | 所有创建均要求 `confirmed=true`；真实系统应由可信 UI/服务端确认记录产生，不能由模型自填 |
| 禁止参数 | 真实收件人、任意指派、附件、URL、脚本、真实客户数据、`claimed_role` |
| 返回字段 | `ticket_id`、`status`、`side_effect`，外层仍标记不可信工具返回 |
| 副作用 | 仅进程内模拟记录；以 `request_id` 幂等，可撤销方式为结束进程/清空字典 |
| 主要错误码 | `E_FORBIDDEN_TOOL`、`E_FORBIDDEN_PARAMETER`、`E_CONFIRMATION_REQUIRED`、`E_SCHEMA_*` |

## 5. 稳定错误与最小披露

| 错误码 | 含义 | 是否执行 | 对模型的安全信息 |
|---|---|---:|---|
| `E_TOOL_NOT_ALLOWED` | 工具不在允许列表 | 否 | 请求的工具不可用 |
| `E_SESSION_INVALID` | 服务端会话无效 | 否 | 身份不可验证 |
| `E_SCHEMA_UNKNOWN_FIELD` | 存在额外字段 | 否 | 参数不符合契约 |
| `E_SCHEMA_*` | 类型、格式、长度或枚举错误 | 否 | 仅指出公开字段规则 |
| `E_FORBIDDEN_TOOL` | 当前角色不可使用工具 | 否 | 权限不足 |
| `E_FORBIDDEN_SCOPE` | 查询范围越权 | 否 | 权限不足 |
| `E_FORBIDDEN_RESOURCE` | 对象级授权失败 | 否 | 权限不足，不返回正文 |
| `E_RESOURCE_NOT_FOUND` | allowlist 中无该模拟 ID | 否 | 资源不可用 |
| `E_FORBIDDEN_PARAMETER` | 参数组合超出角色上限 | 否 | 参数不允许 |
| `E_CONFIRMATION_REQUIRED` | 副作用尚未确认 | 否 | 需要可信确认 |
| `OK` | 通过全部检查 | 仅模拟 | 返回结构化结果 |

## 6. 实测结论与限制

- 三个工具均通过同一网关，不存在模型直连执行器的路径。
- 18 条固定用例中允许 5、拒绝 13；仅 1 条首次创建产生 `simulated_record`，重复 `request_id` 不产生新副作用。
- 污染返回样本触发 `control_style_detected=true`，同时保持 `next_action_authorized=false`。
- 该结果只证明本脚本的这些夹具走到了预期分支，不证明真实 Agent 框架、身份系统或生产日志已安全。
