# jt-gate.ps1 - the single write gate for the Arcana (AspectClass) BG3 mod (ADR-0007).
#
# A write to the GAME copy of the mod (...\Baldurs Gate 3\Data\...\AspectClass_9d734fbd-...) needs:
#   1. the message starts with [fechado] (game and Toolkit closed); no tag = open; one message only;
#   2. the message names a ticket (ARC-####) whose header says `implementation: claude` (00.07).
# Writes into 56_Vanilla_Code_Reference (Larian content, local only) are always denied.
# The synchronized copy in 50_ENGINEERING/51_Mod_Source is NOT gated (ADR-0003).
#
# Wired in ~/.claude/settings.json (global, so it also works when a session starts in the Data folder).
# Modes (first argument):
#   prompt   - UserPromptSubmit: read the tag and ticket ids, save them per session, inject a context line
#   pretool  - PreToolUse: deny writes that break the rules above
#   posttool - PostToolUse: after a game-copy edit, remind sync_data / commit / Context Keeper
#
# Any parse error exits 0 silently, so a broken payload never blocks unrelated work.

param([string]$Mode)

$ErrorActionPreference = 'Stop'
$Marker   = 'AspectClass_9d734fbd'
$GameDir  = 'Baldurs Gate 3[\\/]+Data'
$Vanilla  = '56_Vanilla_Code_Reference'
$Repo     = if ($env:ARCANA_REPO) { $env:ARCANA_REPO } else { 'C:\Lumox Studios\Arcana Class' }
$StateDir = Join-Path $env:USERPROFILE '.claude\hooks\state'

function Out-Json($obj) {
    # ASCII-only JSON: escape every non-ASCII char so console encoding can't corrupt it.
    $json = $obj | ConvertTo-Json -Depth 5 -Compress
    $json = [regex]::Replace($json, '[^\x00-\x7F]', { param($m) '\u{0:x4}' -f [int][char]$m.Value })
    [Console]::Out.Write($json)
}

function Get-StateFile($sessionId) {
    $safe = ($sessionId -replace '[^A-Za-z0-9_-]', '_')
    if (-not $safe) { $safe = 'unknown' }
    Join-Path $StateDir "$safe.txt"
}

function Test-ArcanaCwd($cwd) {
    $c = ([string]$cwd) -replace '/', '\'
    ($c -like '*Baldurs Gate 3\Data*') -or ($c -like '*Lumox Studios\Arcana Class*')
}

function Test-GamePath($p) { $s = [string]$p; ($s -like "*$Marker*") -and ($s -match $GameDir) }

# implementation field of a ticket, read now (it may change during the turn)
function Get-Implementation($id) {
    $f = Get-ChildItem -Path (Join-Path $Repo '10_PRODUCTION') -Recurse -Filter "$id*.md" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $f) { return $null }
    $m = Select-String -Path $f.FullName -Pattern '^implementation:\s*(\w+)' | Select-Object -First 1
    if ($m) { return $m.Matches[0].Groups[1].Value } else { return $null }
}

function Deny($reason) {
    Out-Json @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = $reason } }
    exit 0
}

try {
    $reader = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), [Text.Encoding]::UTF8)
    $in = $reader.ReadToEnd() | ConvertFrom-Json
} catch { exit 0 }

switch ($Mode) {

    'prompt' {
        $prompt = [string]$in.prompt
        $state = 'open'
        if ($prompt -match '^\s*\[(fechado|aberto)\]' -and $Matches[1] -ieq 'fechado') { $state = 'closed' }
        $tickets = ([regex]::Matches($prompt, 'ARC-\d{4}') | ForEach-Object { $_.Value } | Select-Object -Unique) -join ','

        if (-not (Test-Path $StateDir)) { New-Item -ItemType Directory -Path $StateDir | Out-Null }
        Set-Content -Path (Get-StateFile $in.session_id) -Value @($state, $tickets) -Encoding ASCII

        if (Test-ArcanaCwd $in.cwd) {
            if ($state -eq 'closed') {
                $msg = 'Jogo/Toolkit: FECHADO ([fechado] nesta mensagem). Escrita nos arquivos do mod no jogo liberada so para tickets citados nesta mensagem com implementation: claude'
                $msg += if ($tickets) { " (tickets citados: $tickets)." } else { ' - nenhum ticket ARC-#### citado, entao o mod segue somente leitura.' }
            } else {
                $msg = 'Jogo/Toolkit: ABERTO ou nao informado (sem [fechado] nesta mensagem). Somente leitura, investigacao e plano. Mudancas em arquivos do mod vao como blocos copy-paste. Arquivos fora do jogo (projeto, memoria) continuam liberados.'
            }
            Out-Json @{ hookSpecificOutput = @{ hookEventName = 'UserPromptSubmit'; additionalContext = $msg } }
        }
    }

    'pretool' {
        $tool = [string]$in.tool_name
        $ti   = $in.tool_input
        $hit  = $false

        if ($tool -in 'Edit', 'Write', 'MultiEdit', 'NotebookEdit') {
            $fp = [string]$ti.file_path
            if (-not $fp) { $fp = [string]$ti.notebook_path }
            if ($fp -like "*$Vanilla*") {
                Deny 'jt-gate: 56_Vanilla_Code_Reference guarda conteudo da Larian extraido localmente e nunca e editado por agentes (ADR-0007). Use os scripts de extracao.'
            }
            if (Test-GamePath $fp) { $hit = $true }
        }
        elseif ($tool -in 'Bash', 'PowerShell') {
            # Heuristic: the command names the game copy AND redirects into it or uses a mutating command.
            # Reads (grep, cat, Divine extracting to another folder, sync_data) pass.
            $cmd = [string]$ti.command
            if ((Test-GamePath $cmd) -or ($cmd -like "*$Marker*" -and $cmd -match '(?i)\bcd\b[^;&|]*Data')) {
                $redirectIntoMod = $cmd -match ">{1,2}\s*[`"']?[^|;&`"']*$Marker"
                if ($cmd -match "(?i)(\s-d|--destination)\s+[`"']?[^`"']*$Marker") { $redirectIntoMod = $true }
                $mutating = $cmd -match '(?i)(\bsed\s+-i|\bperl\s+(-\w*\s+)*-\w*i|\btee\b|\bcp\b|\bmv\b|\brm\b|\btouch\b|\bmkdir\b|Set-Content|Add-Content|Out-File|Copy-Item|Move-Item|Remove-Item|New-Item|Rename-Item|Clear-Content)'
                if ($redirectIntoMod -or $mutating) { $hit = $true }
            }
        }

        if ($hit) {
            $f = Get-StateFile $in.session_id
            $lines = if (Test-Path $f) { @(Get-Content $f) } else { @('open', '') }
            if ($lines[0].Trim() -ne 'closed') {
                Deny 'jt-gate: escrita no mod bloqueada. Esta mensagem nao comecou com [fechado], entao Jogo/Toolkit contam como ABERTOS. Nao contorne: entregue blocos copy-paste ou peca ao usuario para reenviar com [fechado].'
            }
            $ids = if ($lines.Count -gt 1 -and $lines[1]) { $lines[1].Split(',') } else { @() }
            $ok = $false
            foreach ($id in $ids) { if ((Get-Implementation $id) -eq 'claude') { $ok = $true } }
            if (-not $ok) {
                Deny 'jt-gate: escrita no mod bloqueada (00.07). Precisa de um ticket ARC-#### citado nesta mensagem com implementation: claude no cabecalho. Sem isso o time entrega a spec (55) e o Owner implementa no Toolkit.'
            }
        }
    }

    'posttool' {
        $fp = [string]$in.tool_input.file_path
        if (Test-GamePath $fp) {
            $msg = 'jt-gate: arquivo do mod editado (copia do jogo). Ao fechar a tarefa: (1) rodar 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh para atualizar 51_Mod_Source, (2) commit + push com o id do ticket, (3) handoff ao Guardiao do Contexto para atualizar 05_LIVE_CONTEXT. Story/*.txt: o usuario compila no Story Editor e voce le Story\log.txt depois.'
            Out-Json @{ hookSpecificOutput = @{ hookEventName = 'PostToolUse'; additionalContext = $msg } }
        }
    }
}

exit 0
