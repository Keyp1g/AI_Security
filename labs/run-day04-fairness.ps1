param(
    [string]$CaseFile = (Join-Path $PSScriptRoot 'day04-fairness-pairs.json'),
    [string]$OutputFile = (Join-Path (Split-Path $PSScriptRoot -Parent) 'reports\day-04-fairness-run.jsonl'),
    [string]$Model = 'qwen2.5:7b',
    [string]$Endpoint = 'http://127.0.0.1:11434/api/generate',
    [double]$Temperature = 0,
    [double]$TopP = 1,
    [int]$Seed = 42,
    [int]$NumPredict = 256
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$cases = Get-Content -LiteralPath $CaseFile -Raw -Encoding UTF8 | ConvertFrom-Json
$records = New-Object System.Collections.Generic.List[string]

foreach ($case in @($cases)) {
    $options = [ordered]@{ temperature = $Temperature; top_p = $TopP; seed = $Seed; num_predict = $NumPredict }
    $request = [ordered]@{ model = $Model; prompt = $case.Prompt; stream = $false; options = $options }
    $json = $request | ConvertTo-Json -Depth 8
    $body = [System.Text.Encoding]::UTF8.GetBytes($json)
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod -Method Post -Uri $Endpoint -ContentType 'application/json; charset=utf-8' -Body $body
    $stopwatch.Stop()
    $record = [ordered]@{
        Id = $case.Id; Pair = $case.Pair; Category = $case.Category; Objective = $case.Objective
        Model = $Model; Endpoint = $Endpoint
        DurationSeconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 3)
        Parameters = $options; Prompt = $case.Prompt
        ExpectedBehavior = $case.ExpectedBehavior; Evaluation = $case.Evaluation
        PromptTokens = $response.prompt_eval_count; GeneratedTokens = $response.eval_count
        Done = $response.done; DoneReason = $response.done_reason
        Response = $response.response.TrimEnd()
    }
    $records.Add(($record | ConvertTo-Json -Depth 8 -Compress))
    [pscustomobject]@{ Id = $case.Id; Pair = $case.Pair; Seconds = $record.DurationSeconds; Characters = $record.Response.Length } | Format-Table -AutoSize | Out-String | Write-Host
}

$outputDirectory = Split-Path $OutputFile -Parent
if (-not (Test-Path -LiteralPath $outputDirectory)) { [void](New-Item -ItemType Directory -Path $outputDirectory) }
[System.IO.File]::WriteAllLines($OutputFile, $records, $utf8NoBom)
Write-Host ('Saved {0} records to {1}' -f $records.Count, $OutputFile)
