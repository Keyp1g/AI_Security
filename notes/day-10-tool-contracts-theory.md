# Day 10：三个模拟工具契约理论

> 公开范围：已完成的工具契约、参数边界、错误语义与最小披露理论
> 状态：本部分已通过主动回忆与错误分类练习；角色与对象级权限矩阵理论留待下一阶段

## 学习目标

理解安全工具契约为什么不只是 JSON Schema，并能根据第一个失败点区分 Schema、工具权限、对象权限、参数权限、确认和 allowlist 错误。

## 一、完整工具契约

一个完整契约至少包括：

```text
输入结构
＋调用主体与资源范围
＋业务参数条件
＋返回结构
＋错误语义
＋副作用与审计要求
```

JSON Schema 只覆盖输入结构。它能检查必需字段、类型、长度、枚举、格式和未知字段，但不能证明调用主体有权、对象属于主体、参数组合符合业务规则或副作用已经确认。

因此应区分：

```text
Schema 通过
≠ 身份有效
≠ 工具有权
≠ 对象有权
≠ 参数组合被允许
≠ 副作用已确认
```

## 二、`search_simulated`：范围受限查询

契约参数：

```text
query：字符串，长度 1–80
scope：public_demo / training_demo / admin_demo
top_k：整数，范围 1–5
额外字段：拒绝
```

角色允许范围：

```text
visitor → public_demo
analyst → public_demo + training_demo
admin   → public_demo + training_demo + admin_demo
```

需要分开判断两类请求：

- `scope="secret_demo"` 不属于 Schema 枚举，返回 `E_SCHEMA_SCOPE`；
- `visitor + scope="admin_demo"` 的枚举合法，但主体越权，返回 `E_FORBIDDEN_SCOPE`。

前者是结构/值域问题，后者是对象范围授权问题。二者不能都归为“未认证”或笼统的 403。

## 三、`read_allowed_file`：稳定对象 ID

工具只接受类似以下的稳定 ID：

```json
{ "file_id": "DOC-PUBLIC-001" }
```

不接受相对路径、绝对路径、盘符、UNC、目录、URL 或编码后的路径。若接口接收路径，服务端需要处理路径遍历、规范化、符号链接、编码差异和内部目录枚举；稳定 ID 把资源解析权收回服务端批准对象表。

同一个字段可能出现三类结果：

```text
格式错误 → E_SCHEMA_FILE_ID
格式正确但对象不存在 → E_RESOURCE_NOT_FOUND
格式正确且对象存在但主体越权 → E_FORBIDDEN_RESOURCE
```

生产系统可以对外统一后两类模糊响应，减少资源枚举；内部审计仍可保留精确原因码。返回内容始终是 `untrusted_tool_result`，自然语言内容不获得下一步指令权。

## 四、`create_mock_ticket`：副作用契约

这个工具不仅有字段 Schema，还有角色与参数组合约束：

```text
visitor → 没有创建工具权限
analyst → low/medium，owner_group=triage，必须确认
admin   → 允许已定义的 low/medium/high 枚举，仍需确认和幂等
```

`confirmed=true` 在本地模拟器中只是确定性测试夹具。生产系统不能把模型生成的布尔值当作可信确认；确认应来自模型外的可信 UI 或服务端审批记录，并绑定：

```text
主体、动作、对象、参数摘要、有效期、一次性确认 ID
```

角色更高也不会自动放宽 Schema、未知字段、对象范围或审计要求。

## 五、未知字段与参数走私

三个工具都使用：

```json
"additionalProperties": false
```

这会阻止调用方偷偷加入 `role`、`authorized`、`url`、`path`、`command`、`claimed_role` 或 `approval_override` 等字段。

如果网关忽略未知字段、下游组件却读取它，就会出现：

```text
同一请求
→ 网关和下游对字段有不同解释
→ 安全语义不一致
→ 参数走私或权限绕过
```

新增字段应通过版本化 Schema、策略、测试和审计一起发布，而不是静默接受。

## 六、稳定错误码与第一个失败点

| 第一个失败阶段 | 内部错误码 | 是否执行 |
|---|---|---:|
| 工具 allowlist | `E_TOOL_NOT_ALLOWED` | 否 |
| 会话身份 | `E_SESSION_INVALID` | 否 |
| Schema 类型/长度/格式/枚举 | `E_SCHEMA_*` | 否 |
| 角色工具权限 | `E_FORBIDDEN_TOOL` | 否 |
| 查询范围 | `E_FORBIDDEN_SCOPE` | 否 |
| 对象授权 | `E_FORBIDDEN_RESOURCE` | 否 |
| 对象不存在 | `E_RESOURCE_NOT_FOUND` | 否 |
| 参数组合授权 | `E_FORBIDDEN_PARAMETER` | 否 |
| 副作用确认 | `E_CONFIRMATION_REQUIRED` | 否 |
| 全部通过 | `OK` | 仅模拟 |

HTTP 401/403 是传输层状态，不能替代这些应用内部的稳定业务错误码。例如 Schema 枚举错误可以映射到 HTTP 400，但内部仍应保留 `E_SCHEMA_SCOPE`；范围越权可以映射到 HTTP 403，但内部仍应保留 `E_FORBIDDEN_SCOPE`。

## 主动回忆验收

学习者完成了工具契约组成、稳定 ID、确认边界、未知字段和六场景错误分类练习：

- 能完整列出工具契约的六类以上内容，而不是只写 Schema。
- 能说明路径输入带来的遍历、规范化、符号链接和目录枚举问题。
- 能准确区分 `secret_demo → E_SCHEMA_SCOPE` 与 `visitor/admin_demo → E_FORBIDDEN_SCOPE`。
- 能说明 `confirmed=true` 只能控制本地测试分支，生产确认必须从模型之外的可信状态验证。
- 能解释 `additionalProperties=false` 防止参数走私和跨层解析差异。
- 经过纠错后，准确判断：`top_k=6 → E_SCHEMA_LIMIT`；analyst 读取 admin 对象 → `E_FORBIDDEN_RESOURCE`；路径 ID → `E_SCHEMA_FILE_ID`；analyst high 工单 → `E_FORBIDDEN_PARAMETER`；未确认创建 → `E_CONFIRMATION_REQUIRED`；未注册工具 → `E_TOOL_NOT_ALLOWED`。上述场景均不产生副作用。

## 验收边界

本公开笔记只证明三个工具契约的理论边界和错误分类已通过主动回忆；角色与对象级权限矩阵的完整理论、真实 Agent 框架和模型行为留待后续阶段。
