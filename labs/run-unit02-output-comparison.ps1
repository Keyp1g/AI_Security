param(
    [string]$Model = 'qwen2.5:7b',
    [string]$Endpoint = 'http://127.0.0.1:11434/api/generate'
)

$ErrorActionPreference = 'Stop'

function Invoke-ComparisonCase {
    param(
        [string]$Scenario,
        [int]$Run,
        [string]$Prompt,
        [double]$Temperature,
        [double]$TopP,
        [int]$NumPredict,
        [ValidateRange(-1, 2147483647)]
        [int]$Seed = -1
    )

    $options = [ordered]@{
        temperature = $Temperature
        top_p = $TopP
        num_predict = $NumPredict
    }
    if ($Seed -ge 0) { $options.seed = $Seed }

    $request = [ordered]@{
        model = $Model
        prompt = $Prompt
        stream = $false
        options = $options
    }
    $json = $request | ConvertTo-Json -Depth 5
    $body = [Text.Encoding]::UTF8.GetBytes($json)
    $response = Invoke-RestMethod -Method Post -Uri $Endpoint `
        -ContentType 'application/json; charset=utf-8' -Body $body

    [pscustomobject]@{
        Scenario = $Scenario
        Run = $Run
        Temperature = $Temperature
        TopP = $TopP
        Seed = if ($Seed -lt 0) { 'unset' } else { $Seed }
        PromptCharacters = $Prompt.Length
        PromptTokens = $response.prompt_eval_count
        GeneratedTokens = $response.eval_count
        DoneReason = $response.done_reason
        Response = $response.response.TrimEnd()
    } | ConvertTo-Json -Compress
}

$randomPrompt = 'Return one random English adjective and nothing else.'
1..5 | ForEach-Object {
    Invoke-ComparisonCase -Scenario 'same-prompt-five-runs' -Run $_ `
        -Prompt $randomPrompt -Temperature 1 -TopP 0.9 -NumPredict 8
}

Invoke-ComparisonCase -Scenario 'temperature-low' -Run 1 `
    -Prompt $randomPrompt -Temperature 0 -TopP 1 -NumPredict 8 -Seed 42
Invoke-ComparisonCase -Scenario 'temperature-high' -Run 1 `
    -Prompt $randomPrompt -Temperature 1 -TopP 1 -NumPredict 8 -Seed 42

$shortContextPrompt = @(
    'Access code=BLUE-17.'
    'Question: What is the access code? Return only the code.'
) -join [Environment]::NewLine
$filler = (1..500 | ForEach-Object {
    'Fictional archive paragraph {0}. This text contains no other access code.' -f $_
}) -join [Environment]::NewLine
$longContextPrompt = @(
    'Access code=BLUE-17.'
    $filler
    'Question: What is the access code? Return only the code.'
) -join [Environment]::NewLine

Invoke-ComparisonCase -Scenario 'context-short' -Run 1 `
    -Prompt $shortContextPrompt -Temperature 0 -TopP 1 -NumPredict 16 -Seed 42
Invoke-ComparisonCase -Scenario 'context-long' -Run 1 `
    -Prompt $longContextPrompt -Temperature 0 -TopP 1 -NumPredict 16 -Seed 42

$vaguePrompt = 'Help me audit this API.'
$clearPrompt = 'I have authorization to test a local mock API. Before proposing any tests, ask me for the endpoint, HTTP method, authentication method, allowed scope, test environment, and evidence format. Do not claim a vulnerability without evidence.'

Invoke-ComparisonCase -Scenario 'instruction-vague' -Run 1 `
    -Prompt $vaguePrompt -Temperature 0 -TopP 1 -NumPredict 192 -Seed 42
Invoke-ComparisonCase -Scenario 'instruction-clear' -Run 1 `
    -Prompt $clearPrompt -Temperature 0 -TopP 1 -NumPredict 192 -Seed 42
