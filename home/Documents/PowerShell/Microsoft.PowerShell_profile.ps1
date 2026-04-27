# --------------------------------------------------------------------------------
# PowerShell Profile
# --------------------------------------------------------------------------------

# ==============================================================================
# Inicialização
# ==============================================================================

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==============================================================================
# XDG Base Directories
# ==============================================================================

if (-not $env:XDG_CONFIG_HOME) {
    $env:XDG_CONFIG_HOME = Join-Path $HOME ".config"
}

if (-not $env:XDG_DATA_HOME) {
    $env:XDG_DATA_HOME = Join-Path $HOME ".local" "share"
}

if (-not $env:XDG_STATE_HOME) {
    $env:XDG_STATE_HOME = Join-Path $HOME ".local" "state"
}

if (-not $env:XDG_BIN_HOME) {
    $env:XDG_BIN_HOME = Join-Path $HOME ".local" "bin"
}

# Adiciona XDG_BIN_HOME ao PATH se não estiver presente
if (Test-Path $env:XDG_BIN_HOME) {
    if (-not ($env:PATH -split ";" | Where-Object { $_ -eq $env:XDG_BIN_HOME })) {
        $env:PATH = "$env:XDG_BIN_HOME;$env:PATH"
    }
}

# ==============================================================================
# Variáveis de ambiente
# ==============================================================================

# ---- bat ---------------------------------------------------------------------
$env:BAT_CONFIG_DIR = Join-Path $env:XDG_CONFIG_HOME "bat"

# ---- fnm ---------------------------------------------------------------------
$env:FNM_DIR = Join-Path $env:XDG_DATA_HOME "fnm"

# ---- pipx --------------------------------------------------------------------
$env:PIPX_BIN_DIR = $env:XDG_BIN_HOME
$env:PIPX_HOME = Join-Path $env:XDG_DATA_HOME "pipx"

# ---- pyenv-win ---------------------------------------------------------------
$pyenvRoot = Join-Path $env:XDG_DATA_HOME "pyenv" "pyenv-win"
$env:PYENV = $pyenvRoot
$env:PYENV_HOME = $pyenvRoot
$env:PYENV_ROOT = $pyenvRoot

# ---- less --------------------------------------------------------------------
$env:LESS = "-RMnS~#3i -+F -+X"
$env:LESSCHARSET = "utf-8"
$env:LESSHISTFILE = "-"

# ==============================================================================
# Diretórios XDG específicos do PowerShell
# ==============================================================================

$xdgModules = Join-Path $env:XDG_DATA_HOME "powershell" "modules"
$xdgScripts = Join-Path $env:XDG_DATA_HOME "powershell" "scripts"

# Garante que os diretórios existam
foreach ($dir in @($xdgModules, $xdgScripts)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

# Adiciona o diretório de scripts ao PATH se não estiver presente
if (-not ($env:PATH -split ";" | Where-Object { $_ -eq $xdgScripts })) {
    $env:PATH = "$xdgScripts;$env:PATH"
}

# ==============================================================================
# PSModulePath (módulos PowerShell)
# ==============================================================================

if (-not ($env:PSModulePath -split ";" | Where-Object { $_ -eq $xdgModules })) {
    $env:PSModulePath = "$xdgModules;$env:PSModulePath"
}

# ==============================================================================
# Histórico (XDG_STATE)
# ==============================================================================

$historyDir  = Join-Path $env:XDG_STATE_HOME "powershell"
$historyFile = Join-Path $historyDir "history.txt"

if (-not (Test-Path $historyDir)) {
    New-Item -ItemType Directory -Force -Path $historyDir | Out-Null
}

Set-PSReadLineOption -HistorySavePath $historyFile

# Evita duplicatas consecutivas
Set-PSReadLineOption -HistoryNoDuplicates

# ==============================================================================
# Integrações do sistema
# ==============================================================================

# ---- WinGet CommandNotFound --------------------------------------------------
if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound) {
    try {
        Import-Module Microsoft.WinGet.CommandNotFound -ErrorAction Stop
    } catch {
        Write-Verbose "Falha ao carregar Microsoft.WinGet.CommandNotFound"
    }
}

# ==============================================================================
# Ferramentas de desenvolvimento
# ==============================================================================

# ---- fnm ---------------------------------------------------------------------
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    try {
        fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
    } catch {
        Write-Warning "Falha ao inicializar fnm"
    }
}

# ==============================================================================
# Atalhos de teclado (PSReadLine)
# ==============================================================================

# Ctrl+L → limpa a tela
Set-PSReadLineKeyHandler -Key Ctrl+l -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
    Write-Host "`e[3J" -NoNewline   # Limpa o scrollback (buffer do terminal)
}

# ==============================================================================
# Finalização
# ==============================================================================
Write-Verbose "[PROFILE] carregado com sucesso"
