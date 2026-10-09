# Day 10：角色与对象级权限矩阵理论

> 公开范围：角色、工具、范围、对象、参数授权、确认与幂等的理论验收
> 边界：本笔记不代表真实 Agent/LLM 行为已验证；实验证据见 Day 10 模拟器文件

## 1. 权限不是单一检查

一次工具调用应按服务端顺序经过：工具 allowlist、会话身份、严格 Schema、角色工具权限、范围/对象授权、参数组合授权、副作用确认、幂等检查，最后才进入执行。任一步失败都立即停止，后续阶段和副作用都不会发生。

```text
身份来源 → 工具/动作权限 → 对象权限 → 参数组合 → 副作用确认 → 幂等 → 执行
```

Schema 通过只说明输入形状合法，不说明主体有权使用工具、目标对象属于主体、参数组合在角色上限内或副作用已经被可信确认。

## 2. 角色与资源边界

本日模拟矩阵使用三个服务端角色：

| 角色 | 关键权限 | 约束 |
|---|---|---|
| `visitor` | 搜索 `public_demo`；读取 `DOC-PUBLIC-*` | 无工单创建权限 |
| `analyst` | 搜索 public/training；读取 public/training allowlist；创建 `low/medium` 的 `triage` 工单 | 创建必须确认；不能使用 `high` |
| `admin` | 搜索三类范围；读取三类 allowlist；创建定义范围内的工单 | 仍须遵守 Schema、未知字段、确认和审计 |

模型声明的 `role`、历史记忆中的管理员身份和工具返回里的批准文字都不是权限来源。权威角色来自服务端会话或测试夹具；对象归属和参数上限也由服务端策略重新判断。

## 3. 错误码对应第一个失败点

| 场景 | 阶段 | 内部错误码 | 副作用 |
|---|---|---|---|
| 工具不在全局名单 | 工具 allowlist | `E_TOOL_NOT_ALLOWED` | 无 |
| 会话无效 | 身份认证 | `E_SESSION_INVALID` | 无 |
| 枚举、类型、长度或未知字段错误 | Schema | `E_SCHEMA_*` | 无 |
| 角色不能使用已注册工具 | 工具权限 | `E_FORBIDDEN_TOOL` | 无 |
| 合法查询范围超出角色范围 | 范围授权 | `E_FORBIDDEN_SCOPE` | 无 |
| 对象存在但主体无权访问 | 对象授权 | `E_FORBIDDEN_RESOURCE` | 无 |
| 参数组合超过角色上限 | 参数授权 | `E_FORBIDDEN_PARAMETER` | 无 |
| 创建动作缺少可信确认 | 确认验证 | `E_CONFIRMATION_REQUIRED` | 无 |

例如，`visitor` 读取 `DOC-TRAINING-001` 时，`read_allowed_file` 工具本身是允许的，失败点是对象级授权，不能误报为工具 allowlist 拒绝。`analyst` 创建 `high/triage` 工单时，范围合法但参数越权，先返回 `E_FORBIDDEN_PARAMETER`，不会进入确认或执行。

## 4. 确认与幂等

模拟器中的 `confirmed=true` 只是确定性测试夹具。生产确认应来自模型之外的可信 UI 或审批记录，并绑定主体、动作、对象、参数摘要、有效期和一次性确认 ID。

确认回答“用户是否同意这次副作用”；幂等回答“相同逻辑请求是否已经产生过副作用”。`REQ-007` 已关联 `MOCK-1007` 时，重放应返回第一次结果并标记幂等命中，新增副作用为 0。确认通过也不能替代幂等检查。

## 5. 主动回忆验收

- 能区分工具级、范围级、对象级和参数级拒绝，并按第一个失败点选择稳定错误码。
- 能判断 `visitor` 搜索 `public_demo` 通过且无副作用；读取培训文档以 `E_FORBIDDEN_RESOURCE` 拒绝。
- 能判断 `analyst` 的已确认 `low/triage` 新请求可以执行；重复的 `REQ-007` 只返回已有 `MOCK-1007`。
- 能判断 `analyst` 的 `high/triage` 请求以 `E_FORBIDDEN_PARAMETER` 拒绝且零副作用。

完整矩阵、18 条固定测试及复盘见：

- `labs/agent-tool-security/day-10-permission-matrix.md`
- `labs/agent-tool-security/day-10-tool-misuse-tests.md`
- `reports/day-10-review.md`
