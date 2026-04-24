param(
    [Parameter(Position=0)]
    [ValidateSet("set", "remove", "get", "list", "add-path", "remove-path")]
    [string]$Command,

    [Parameter(Position=1)]
    [string]$Name,

    [Parameter(Position=2)]
    [string]$Value,

    [ValidateSet("String", "ExpandString")]
    [string]$Type = "String",

    [switch]$UnixPath
)

if (-not (Get-Module EnvTools)) {
    Import-Module EnvTools -ErrorAction Stop
}

switch ($Command) {

    "set" {
        if (-not $Name -or -not $Value) {
            throw "Uso: env set <NAME> <VALUE> [-Type String|ExpandString] [-UnixPath]"
        }
        Set-EnvVar -Name $Name -Value $Value -Type $Type -UnixPath:$UnixPath
    }

    "remove" {
        if (-not $Name) {
            throw "Uso: env remove <NAME>"
        }
        Remove-EnvVar -Name $Name
    }

    "get" {
        if (-not $Name) {
            throw "Uso: env get <NAME> [-UnixPath]"
        }
        Get-EnvVar -Name $Name -UnixPath:$UnixPath
    }

    "list" {
        Get-EnvVars
    }

    "add-path" {
        if (-not $Name) {
            throw "Uso: env add-path <PATH> [-UnixPath]"
        }
        Add-EnvPath -Value $Name -UnixPath:$UnixPath
    }

    "remove-path" {
        if (-not $Name) {
            throw "Uso: env remove-path <PATH> [-UnixPath]"
        }
        Remove-EnvPath -Value $Name -UnixPath:$UnixPath
    }

    default {
        Write-Host @"
Comandos disponíveis:
  psenv set <NAME> <VALUE> [-Type String|ExpandString] [-UnixPath]
  psenv remove <NAME>
  psenv get <NAME> [-UnixPath]
  psenv list
  psenv add-path <PATH> [-UnixPath]
  psenv remove-path <PATH> [-UnixPath]
"@
    }
}
