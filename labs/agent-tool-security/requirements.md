# 作品 3：Agent Tool Security Lab 需求文档

> 版本：v0.1
> 阶段：Day 10 确定性模拟原型

## 1. 问题与目标

构建一个不依赖真实 Agent 框架的本地安全网关，验证“模型只能建议调用，服务端决定是否执行”。网关必须对模拟工具执行严格参数校验、主体/对象/动作授权、副作用确认、幂等、工具返回隔离和审计，并用固定用例留下可复核证据。

完成定义不是“模型表现安全”，而是：所有候选调用只能经确定性控制到达模拟执行器；拒绝无副作用；允许与拒绝均有证据；工具返回不能授权后续动作。

## 2. 范围

- 三个模拟工具：`search_simulated`、`read_allowed_file`、`create_mock_ticket`。
- 三个模拟角色：visitor、analyst、admin。
- 三类虚构资源范围：public_demo、training_demo、admin_demo。
- 固定 PowerShell 脚本、18 条测试和 JSONL 审计证据。
- 只在内存中保存虚构索引、文档和模拟工单。

## 3. 非目标

- 不连接网络、真实文件系统、工单、邮件、支付、账户或命令执行器。
- 不集成真实 LLM/Agent，不评价某个模型抵抗 Prompt Injection 的能力。
- 不实现生产身份系统、分布式锁、防篡改日志或真实人工审批。
- 不保存真实秘密、客户数据、系统配置或攻击载荷。

## 4. 角色模型

| 角色 | 搜索范围 | 读取范围 | 工单能力 |
|---|---|---|---|
| visitor | public | public | 无 |
| analyst | public、training | public、training | low/medium，仅 triage，须确认 |
| admin | public、training、admin | 三类 allowlist | 全部模拟枚举，仍须确认 |

身份来自服务端会话映射。客户端/模型提供的 `role`、`authorized`、`claimed_role` 或自然语言批准都不可信。

## 5. 调用协议与状态模型

```text
proposed
  -> schema_validated
  -> authenticated
  -> authorized(tool/object/parameter)
  -> awaiting_confirmation（仅副作用动作）
  -> executing_simulated
  -> completed | denied | failed_closed
  -> audited
```

拒绝状态不得返回到 executing。创建请求以 `request_id` 进入幂等表：首次成功为 `created_in_memory`，后续相同 ID 为 `duplicate_replayed`。

调用最小输入是可信 session 引用、allowlist 工具名和严格 arguments；输出是公开决定码、结构化模拟结果和内部审计关联 ID。原始自然语言理由不能影响授权。

## 6. 威胁模型

| 威胁 | 安全属性 | 强制控制 | 证据 |
|---|---|---|---|
| 任意工具名/危险动作 | 完整性 | 工具 allowlist | AGENT-010-14 |
| 未知字段与参数走私 | 完整性 | additionalProperties=false | 02、12 |
| 类型、长度、枚举绕过 | 完整性/可用性 | 严格 Schema | 03、13 |
| 路径遍历或任意文件 | 机密性 | 只接受 allowlist 稳定 ID | 07 |
| 水平/垂直越权 | 机密性/完整性 | 服务端角色 + 对象级授权 | 04、06、10、11 |
| 模型伪造身份或批准 | 授权完整性 | 会话为唯一身份源；可信确认 | 08、12、16 |
| 重复提交 | 完整性 | request_id 幂等 | 09、15 |
| 工具返回注入 | 控制流完整性 | untrusted 标签；永不从返回授权 | 18 |
| 错误泄露内部结构 | 机密性 | 稳定错误码、最小响应 | 17 |
| 审计缺失/敏感日志 | 可追责性/机密性 | 每调用一行；键+哈希，不存正文 | 01–18 |

## 7. 日志需求

必须记录：case/call ID、session 引用、服务端 actor 和 role、工具、参数键、规范化参数哈希、allow/deny、决定码、阻断阶段、副作用类别、策略版本。公开实验日志不保存墙上时钟；生产系统可以在受控日志中保留合规所需时间字段。

不得记录：真实令牌、密钥、完整 query/summary/content、真实路径、调用栈和客户数据。生产化前需补充日志完整性、访问控制、告警、保留和删除策略。

## 8. 功能验收

- [x] 三个工具均有严格参数契约与稳定返回。
- [x] visitor、analyst、admin 的功能范围可区分。
- [x] 搜索与读取只访问脚本内虚构数据。
- [x] 模拟工单仅写进程内存，并支持 `request_id` 幂等。
- [x] 脚本在 PowerShell 下可复跑并输出 JSONL。

## 9. 安全验收

- [x] 模型/调用方不能传入有效角色或覆盖授权决定。
- [x] 工具、动作、对象和参数条件分别校验。
- [x] 创建动作未确认时无副作用。
- [x] 路径、URL、命令和未知工具不能到达执行器。
- [x] 工具返回标记为不可信，控制样式文本不能触发下一动作。
- [x] 18 条测试都有决定、阶段和审计证据。
- [ ] 并发幂等、防篡改日志和真实可信确认：阶段一未实现。
- [ ] 真实 Agent 框架适配与模型实验：不在本阶段范围。

## 10. 测试优先级

1. P0：工具 allowlist、身份、Schema、对象授权、确认失败关闭。
2. P0：拒绝无副作用，重复请求不重复创建。
3. P1：工具返回隔离、错误最小披露、审计完整性。
4. P1：并发请求、确认 token 绑定与过期、日志写入失败。
5. P2：接入具体 Agent 框架后验证适配层，仍不得把模型作为授权器。

## 11. 交付物

- `day-10-tool-specs.md`
- `day-10-permission-matrix.md`
- `day-10-tool-misuse-tests.md`
- `day-10-simulator.ps1`
- `day-10-simulator-results.jsonl`
- 本 `requirements.md`
