param(
    [string]$CaseFile = (Join-Path $PSScriptRoot 'day03-prompt-quality-cases.json'),
    [string]$OutputFile = (Join-Path (Split-Path $PSScriptRoot -Parent) 'reports\day-03-prompt-quality-run.jsonl'),
    [string]$Model = 'qwen2.5:7b',
    [string]$Endpoint = 'http://127.0.0.1:11434/api/generate',
    [ValidateRange(0.0, 2.0)]
    [double]$Temperature = 0,
    [ValidateRange(0.0, 1.0)]
    [double]$TopP = 1,
    [ValidateRange(0, 2147483647)]
    [int]$Seed = 42,
    [ValidateRange(1, 8192)]
    [int]$NumPredict = 256
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom

$cases = Get-Content -LiteralPath $CaseFile -Raw -Encoding UTF8 | ConvertFrom-Json
$selected = @($cases | Where-Object { $_.Run -eq $true })

if ($selected.Count -eq 0) {
    throw 'No cases are marked for execution.'
}

$lines = New-Object System.Collections.Generic.List[string]

foreach ($case in $selected) {
    $options = [ordered]@{
        temperature = $Temperature
        top_p = $TopP
        seed = $Seed
        num_predict = $NumPredict
    }

    $request = [ordered]@{
        model = $Model
        prompt = $case.Prompt
        stream = $false
        options = $options
    }

    if (-not [string]::IsNullOrWhiteSpace($case.SystemPrompt)) {
        $request.system = $case.SystemPrompt
    }

    $json = $request | ConvertTo-Json -Depth 8
    $body = [System.Text.Encoding]::UTF8.GetBytes($json)
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod -Method Post -Uri $Endpoint -ContentType 'application/json; charset=utf-8' -Body $body
    $stopwatch.Stop()

    $record = [ordered]@{
        Id = $case.Id
        Category = $case.Category
        Objective = $case.Objective
        Model = $Model
        Endpoint = $Endpoint
        DurationSeconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 3)
        Parameters = $options
        SystemPrompt = $case.SystemPrompt
        Prompt = $case.Prompt
        ExpectedBehavior = $case.ExpectedBehavior
        Evaluation = $case.Evaluation
        PromptTokens = $response.prompt_eval_count
        GeneratedTokens = $response.eval_count
        Done = $response.done
        DoneReason = $response.done_reason
        Response = $response.response.TrimEnd()
    }

    $line = $record | ConvertTo-Json -Depth 8 -Compress
    $lines.Add($line)
    [pscustomobject]@{
        Id = $case.Id
        Category = $case.Category
        Seconds = $record.DurationSeconds
        DoneReason = $record.DoneReason
        ResponseCharacters = $record.Response.Length
    } | Format-Table -AutoSize | Out-String | Write-Host
}

$outputDirectory = Split-Path $OutputFile -Parent
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    [void](New-Item -ItemType Directory -Path $outputDirectory)
}

[System.IO.File]::WriteAllLines($OutputFile, $lines, $utf8NoBom)
Write-Host ('Saved {0} records to {1}' -f $lines.Count, $OutputFile)
