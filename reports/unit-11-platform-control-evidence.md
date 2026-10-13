# 学习单元 11：平台控制证据摘要

> 发布范围：从授权云服务器案例和执行手册中提取的脱敏结论。本文不含公网地址、私钥、账户凭据、完整评测输出或个人活动时间线。

## 1. 证据状态

| 控制项 | 控制前观察 | 控制后证据 | 当前判定 | 残余风险 |
|---|---|---|---|---|
| SSH 身份认证 | 公网 SSH 出现失败登录；密码认证和 root 直登曾开放 | 有效配置为 `AllowUsers lighthouse`、`AuthenticationMethods publickey`、`PermitRootLogin no`、`PasswordAuthentication no`、`KbdInteractiveAuthentication no`；root 新连接拒绝 | 服务器实测 | TCP/22 仍受扫描；管理密钥和云控制台账户仍需保护 |
| 主机网络边界 | 主机防火墙曾未启用，主要依赖云侧边界 | firewalld active，public zone 仅保留 SSH 和云环境必要的 DHCPv6；外部探测只有 TCP/22 可达 | 服务器实测 | 云控制台 IPv4/IPv6 规则仍需人工复核 |
| Ollama 暴露面 | 若模型 API 监听公网，可能被未授权调用 | 容器仅绑定 `127.0.0.1:11434`；应用端口外部不可达；通过 SSH 隧道访问 | 服务器实测 | 主机或 SSH 会话失陷后，回环服务仍可能被访问 |
| Docker 日志与资源 | 默认日志可能持续增长；小内存推理可能影响可用性 | Docker 日志设置 `max-size=10m`、`max-file=3`；约 2 GiB swap 已启用 | 服务器实测 | 其他系统日志、模型文件和报告仍需磁盘配额与告警 |

## 2. 尚未完成

- SELinux 当前未作为已部署控制。
- Qdrant 尚未部署，向量库隔离与 API key 管理仍待验证。
- cron 定时评测尚未完成一次成功运行。
- 云控制台 IPv4/IPv6 入站规则需要单独人工复核。

## 3. 证据边界

本摘要证明平台基线中若干配置和外部可达性状态，不证明模型、RAG 或 Agent 应用本身安全。对应应用层测试仍使用 `TM-011-xx` 并保持待实测。
