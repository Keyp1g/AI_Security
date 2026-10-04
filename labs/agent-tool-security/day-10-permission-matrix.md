# Day 10：模拟工具权限矩阵

> 权威身份源：`day-10-simulator.ps1` 中的服务端会话夹具
> 明确拒绝：模型文本、候选参数、工具返回中的角色或批准声明

## 1. 角色与资源范围

| 角色 | 工具 | 资源范围 | 参数上限 | 确认 | 审计级别 | 典型拒绝原因 |
|---|---|---|---|---|---|---|
| visitor | `search_simulated` | `public_demo` | `top_k<=5`，query 1–80 字符 | 否 | 标准 | training/admin 范围、未知参数 |
| visitor | `read_allowed_file` | `DOC-PUBLIC-*` allowlist 对象 | 单个稳定 ID | 否 | 标准 | 路径形式、training/admin 对象 |
| visitor | `create_mock_ticket` | 无 | 全拒绝 | 不适用 | 安全 | `E_FORBIDDEN_TOOL` |
| analyst | `search_simulated` | public + training | 同全局 Schema | 否 | 标准 | admin 范围、超限 `top_k` |
| analyst | `read_allowed_file` | public + training allowlist 对象 | 单个稳定 ID | 否 | 标准 | admin 对象、未知 ID |
| analyst | `create_mock_ticket` | 内存工单；`triage` | severity=low/medium；title<=80；summary<=240 | 必须 | 安全 | high、security-lab、未确认 |
| admin | `search_simulated` | public + training + admin | 同全局 Schema；不因管理员放宽输入边界 | 否 | 标准 | 非枚举范围、未知参数 |
| admin | `read_allowed_file` | 三类 allowlist 对象 | 单个稳定 ID | 否 | 安全 | 路径、未知 ID；管理员也不能绕过 Schema |
| admin | `create_mock_ticket` | 内存工单；triage/security-lab | severity=low/medium/high；仍受长度与枚举限制 | 必须 | 安全 | 未确认、未知字段、无效 request_id |

权限由“主体 × 工具 × 动作 × 对象 × 参数条件”共同决定。角色高不等于输入无限制；管理员同样不能传路径、URL、命令或未定义字段。

## 2. 服务端校验顺序

```text
候选调用
  -> 1 工具是否在 allowlist？
  -> 2 会话是否有效，并取得 server_role？
  -> 3 参数键是否恰好匹配严格 Schema？
  -> 4 类型、长度、枚举、格式是否有效？
  -> 5 该角色能否使用该工具？
  -> 6 该角色能否访问具体 scope/file_id？
  -> 7 参数组合是否超过角色上限？
  -> 8 副作用是否有可信确认？
  -> 9 request_id 是否已处理？
  -> 10 模拟执行
  -> 11 工具返回按 untrusted_tool_result 隔离与审查
  -> 12 最小化审计
```

任一步失败立即停止，后续步骤不执行，拒绝也必须写审计。Schema 合法只代表“形状有效”，不代表“有权限”。

## 3. 允许与拒绝实例

| 编号 | 角色 | 请求摘要 | 决定 | 理由 |
|---|---|---|---|---|
| PM-01 | visitor | 搜索 public_demo | 允许 | 工具、范围和参数均在边界内 |
| PM-02 | visitor | 搜索 admin_demo | 拒绝 | `E_FORBIDDEN_SCOPE` |
| PM-03 | visitor | 读 DOC-PUBLIC-001 | 允许 | 对象在 public allowlist |
| PM-04 | visitor | 读 DOC-TRAINING-001 | 拒绝 | `E_FORBIDDEN_RESOURCE` |
| PM-05 | visitor | 创建模拟工单 | 拒绝 | 角色无该工具权限 |
| PM-06 | analyst | 搜索 training_demo | 允许 | 有培训范围 |
| PM-07 | analyst | 创建已确认 low/triage 工单 | 允许 | 参数组合在角色上限内 |
| PM-08 | analyst | 创建 high/security-lab 工单 | 拒绝 | `E_FORBIDDEN_PARAMETER` |
| PM-09 | admin | 读 DOC-ADMIN-001 | 允许 | 对象级授权通过 |
| PM-10 | admin | 以 `..\secret.txt` 代替 ID | 拒绝 | Schema 在授权前阻断；管理员也不能用路径 |
| PM-11 | admin | 请求未列出的 `shell_exec` | 拒绝 | `E_TOOL_NOT_ALLOWED` |
| PM-12 | admin | 工单参数附加 `claimed_role` | 拒绝 | `additionalProperties=false` |

## 4. 审计规则

每次调用记录：case/call ID、会话引用、服务端 actor/role、工具名、参数键、参数 SHA-256、允许/拒绝、稳定决定码、阻断阶段、副作用类别和策略版本。公开实验日志不保留墙上时钟；正文、标题、summary、查询全文也不进入审计。需要取证时通过访问受控的证据库另行保存。

以下情况使用安全级审计：对象越权、副作用请求、身份失败、工具 allowlist 失败、污染返回命中。日志写入失败时，创建类动作必须 fail closed；无副作用读取类动作是否阻断由生产风险策略决定，本实验统一要求记录成功后才宣称完成。

## 5. 本次演练验证

- visitor、analyst、admin 都有至少一个允许和拒绝场景。
- `AGENT-010-04/06/10/11` 分别命中范围、对象、参数组合、工具权限控制。
- `AGENT-010-12` 证明模型/调用方不能通过 `claimed_role` 扩权。
- `AGENT-010-09/15` 证明首次创建与重复请求的副作用不同。
- 18 次调用产生 18 条审计记录；这是脚本内计数验证，不是生产日志持久性证明。
