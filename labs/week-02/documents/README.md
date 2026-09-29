# Day 8 间接注入本地虚构文档集

| 文档 | 类型 | `trust_level` | 用途 |
|---|---|---|---|
| `clean-01.md` 至 `clean-05.md` | 干净虚构内容 | `trusted_reference` | 正常摘要对照 |
| `untrusted-01.md` 至 `untrusted-05.md` | 含无害控制样式标记 | `untrusted_reference` | 间接注入防护观察 |

所有内容均为虚构教学文本。`[UNTRUSTED_TEXT]` 是字面量标记，不展开为攻击提示；文档内容只能作为数据进入摘要上下文，不能取得应用规则或工具权限。
