param(
    [ValidateRange(1, 10)]
    [int]$From = 1,

    [ValidateRange(1, 10)]
    [int]$To = 10,

    [string]$OllamaExe = 'ollama',

    [string]$Model = 'qwen2.5:7b'
)

$ErrorActionPreference = 'Stop'
$promptFile = Join-Path $PSScriptRoot 'day02-failure-prompts.json'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom

if ($From -gt $To) {
    throw '-From must be less than or equal to -To.'
}

$ollamaCommand = Get-Command $OllamaExe -ErrorAction SilentlyContinue
if (-not $ollamaCommand) {
    $defaultOllama = Join-Path $env:LOCALAPPDATA 'Programs\Ollama\ollama.exe'
    if (-not (Test-Path -LiteralPath $defaultOllama)) {
        throw 'Ollama executable not found. Pass its path with -OllamaExe.'
    }
    $OllamaExe = $defaultOllama
}

# Keep this script ASCII so Windows PowerShell 5.1 parses it consistently.
$cases = Get-Content -LiteralPath $promptFile -Raw -Encoding UTF8 | ConvertFrom-Json
$filler = (1..500 | ForEach-Object {
    "Fictional archive paragraph $($_). This text contains no other access code."
}) -join "`n"
$cases[5].Prompt = $cases[5].Prompt.Replace('{{FILLER}}', $filler)

foreach ($caseNumber in $From..$To) {
    $case = $cases[$caseNumber - 1]
    $startedAt = Get-Date
    $responseLines = $case.Prompt | & $OllamaExe run $Model --nowordwrap
    $exitCode = $LASTEXITCODE
    $finishedAt = Get-Date

    [pscustomobject]@{
        Id = $case.Id
        Model = $Model
        StartedAt = $startedAt.ToString('yyyy-MM-dd HH:mm:ss zzz')
        DurationSeconds = [math]::Round(($finishedAt - $startedAt).TotalSeconds, 3)
        PromptCharacters = $case.Prompt.Length
        ExitCode = $exitCode
        Response = (($responseLines -join "`n").TrimEnd())
    } | ConvertTo-Json -Compress
}
