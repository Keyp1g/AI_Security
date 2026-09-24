param(
    [ValidateRange(1, 10)]
    [int]$From = 1,

    [ValidateRange(1, 10)]
    [int]$To = 10,

    [ValidateRange(0.0, 2.0)]
    [double]$Temperature = 0.7,

    [ValidateRange(0.0, 1.0)]
    [double]$TopP = 0.9,

    [ValidateRange(-1, 2147483647)]
    [int]$Seed = -1,

    [ValidateRange(1, 8192)]
    [int]$NumPredict = 1024,

    [string]$Model = 'qwen2.5:7b',

    [string]$Endpoint = 'http://127.0.0.1:11434/api/generate'
)

$ErrorActionPreference = 'Stop'
$promptFile = Join-Path $PSScriptRoot 'day02-failure-prompts.json'

if ($From -gt $To) {
    throw '-From must be less than or equal to -To.'
}

$cases = Get-Content -LiteralPath $promptFile -Raw -Encoding UTF8 | ConvertFrom-Json
$filler = (1..500 | ForEach-Object {
    "Fictional archive paragraph $($_). This text contains no other access code."
}) -join "`n"
$cases[5].Prompt = $cases[5].Prompt.Replace('{{FILLER}}', $filler)

foreach ($caseNumber in $From..$To) {
    $case = $cases[$caseNumber - 1]
    $options = [ordered]@{
        temperature = $Temperature
        top_p = $TopP
        num_predict = $NumPredict
    }

    if ($Seed -ge 0) {
        $options.seed = $Seed
    }

    $request = [ordered]@{
        model = $Model
        prompt = $case.Prompt
        stream = $false
        options = $options
    }

    $json = $request | ConvertTo-Json -Depth 5
    $body = [System.Text.Encoding]::UTF8.GetBytes($json)
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod `
        -Method Post `
        -Uri $Endpoint `
        -ContentType 'application/json; charset=utf-8' `
        -Body $body
    $stopwatch.Stop()

    [pscustomobject]@{
        Id = $case.Id
        Model = $Model
        Endpoint = $Endpoint
        DurationSeconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 3)
        PromptCharacters = $case.Prompt.Length
        PromptTokens = $response.prompt_eval_count
        GeneratedTokens = $response.eval_count
        RequestedOptions = $options
        Done = $response.done
        DoneReason = $response.done_reason
        Response = $response.response.TrimEnd()
    } | ConvertTo-Json -Depth 5 -Compress
}
