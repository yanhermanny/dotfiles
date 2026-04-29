# --------------------------------------------------------------------------------
# Logger
# --------------------------------------------------------------------------------

# ---- log level ---------------------------------------------------------------
enum LogLevel {
    Info
    Task
    Warning
    Error
    Success
    Comment
    Command
}

# ==============================================================================
# Log functions
# ==============================================================================

# ---- core log function -------------------------------------------------------
function Write-Color {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Color,

        [Parameter()]
        [AllowNull()]
        [string]$Prefix,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    # Extrai quebras de linha iniciais
    $leading = ""
    $content = $Message

    if ($Message -match "^(?<leading>`n+)(?<rest>.*)$") {
        $leading = $matches.leading
        $content = $matches.rest
    }

    if ($leading) {
        Write-Host -NoNewline $leading
    }

    if ($Prefix) {
        Write-Host "$Prefix $content" -ForegroundColor $Color
    }
    else {
        Write-Host "$content" -ForegroundColor $Color
    }
}

# ---- semantic log functions --------------------------------------------------
function Log-Normal {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "Gray" -Message $Message
}

function Log-Info {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "Blue" -Prefix "ℹ️" -Message $Message
}

function Log-Task {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "Cyan" -Prefix "🔃" -Message $Message
}

function Log-Warning {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "DarkYellow" -Prefix "⚠️" -Message $Message
}

function Log-Error {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "Red" -Prefix "❌" -Message $Message
}

function Log-Success {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "DarkGreen" -Prefix "✅" -Message $Message
}

function Log-Comment {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "DarkGray" -Message $Message
}

function Log-Command {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Color -Color "Yellow" -Prefix "👉" -Message $Message
}

# ---- API pública -------------------------------------------------------------
function Log {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,

        [Parameter(Position = 1)]
        [LogLevel]$Level
    )
    switch ($Level) {
        ([LogLevel]::Info)    { Log-Info $Message }
        ([LogLevel]::Task)    { Log-Task $Message }
        ([LogLevel]::Warning) { Log-Warning $Message }
        ([LogLevel]::Error)   { Log-Error $Message }
        ([LogLevel]::Success) { Log-Success $Message }
        ([LogLevel]::Comment) { Log-Comment $Message }
        ([LogLevel]::Command) { Log-Command $Message }
        default               { Log-Normal $Message }
    }
}

# ==============================================================================
# Exportações
# ==============================================================================
Export-ModuleMember -Function Log
