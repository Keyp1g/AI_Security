# 第 2 天：LLM 输出对比实验

> 阶段：Day 2
> 模型：`qwen2.5:7b`  
> 接口：本地 Ollama `http://127.0.0.1:11434/api/generate`  
> 复现脚本：`labs/run-day02-output-comparison.ps1`

## 1. 同一 Prompt 连续运行 5 次

固定 Prompt：`Return one random English adjective and nothing else.`

固定参数：`temperature=1`、`top_p=0.9`、`num_predict=8`，不设置 seed。

| Run | Prompt Token | 生成 Token | 原始 Response |
|---:|---:|---:|---|
| 1 | 38 | 3 | `colorful` |
| 2 | 38 | 3 | `Exciting` |
| 3 | 38 | 3 | `colorful` |
| 4 | 38 | 3 | `colorful` |
| 5 | 38 | 2 | `Amazing` |

观察：同一 Prompt 和相同采样参数下出现 3 种不同文本，证明本次环境中的未固定随机采样会影响输出。5 次小样本只说明可观测差异，不能概括模型的整体稳定性。

## 2. 单变量对比

### 2.1 Temperature

控制项：Prompt、`top_p=1`、`seed=42`、`num_predict=8` 保持一致，只改变 temperature。

| temperature | 原始 Response |
|---:|---|
| 0 | `colorful` |
| 1 | `gleeful` |

观察：改变 temperature 后，本次输出发生变化。temperature 影响采样倾向，但不能替代事实核查、授权控制或输出验证。

### 2.2 上下文长度

控制项：问题、关键码、`temperature=0`、`top_p=1`、`seed=42` 和输出上限保持一致。长上下文只增加 500 段不含其他访问码的虚构文本。

| 场景 | Prompt 字符 | Prompt Token | 期望 | 原始 Response |
|---|---:|---:|---|---|
| 短上下文 | 78 | 50 | `BLUE-17` | `BLUE-17` |
| 长上下文 | 37470 | 2050 | `BLUE-17` | `None` |

观察：短上下文通过，长上下文失败。实际 Prompt 只有 2050 Token，未达到模型标称的 32768 Token 窗口，因此不能解释为窗口截断；更合理的后续假设包括信息位置效应、重复内容干扰或注意力弱化。

### 2.3 指令清晰度

控制项：模型和采样参数保持一致，只改变 Prompt 的明确程度。

模糊指令：`Help me audit this API.`

模型先给出文档、安全、性能等通用审计方向，最后才开始请求更多信息；输出达到 `num_predict=192` 并以 `done_reason=length` 停止。

清晰指令明确了本地模拟 API、授权边界、需要询问的 6 项前置条件，以及“无证据不得宣称漏洞”。模型随后逐项询问：

1. Endpoint
2. HTTP Method
3. Authentication Method
4. Allowed Scope
5. Test Environment
6. Evidence Format

观察：清晰指令让响应更接近可执行的安全测试入口，但 Prompt 仍不是权限边界；真实系统还需要服务端授权、最小权限、日志和人工审批。

## 3. 限制

- 只测试了一个本地模型和少量样本。
- temperature 对比各只有一次，不能估计输出分布。
- 上下文实验同时改变了长度和重复文本数量，后续需要按长度分层并改变关键码位置。
- 指令清晰度结果采用人工检查，尚未建立自动评分器。
- 结果只适用于记录的模型、接口和参数，不代表其他版本或服务端实现。

## 4. 复现

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\labs\run-day02-output-comparison.ps1'
```

脚本以逐行 JSON 输出场景、运行次数、采样参数、Token 数、停止原因和原始 Response，便于后续保存为日志或接入评测工具。
