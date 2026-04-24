param(
    [Parameter(Position=0)]
    [ValidateSet("set", "remove", "get", "list", "add-path", "remove-path")]
    [string]$Command,

    [Parameter(Position=1)]
    [string]$Name,

    [Parameter(Position=2)]
    [string]$Value,

    [ValidateSet("String", "ExpandString")]
    [string]$Type = "String"
)

if (-not (Get-Module EnvTools)) {
    Import-Module EnvTools -ErrorAction Stop
}

switch ($Command) {

    "set" {
        if (-not $Name -or -not $Value) {
            throw "Uso: env set <NAME> <VALUE> [-Type String|ExpandString]"
        }
        Set-EnvVar -Name $Name -Value $Value -Type $Type
    }

    "remove" {
        if (-not $Name) {
            throw "Uso: env remove <NAME>"
        }
        Remove-EnvVar -Name $Name
    }

    "get" {
        if (-not $Name) {
            throw "Uso: env get <NAME>"
        }
        Get-EnvVar -Name $Name
    }

    "list" {
        Get-EnvVars
    }

    "add-path" {
        if (-not $Name) {
            throw "Uso: env add-path <PATH>"
        }
        Add-EnvPath -Value $Name
    }

    "remove-path" {
        if (-not $Name) {
            throw "Uso: env remove-path <PATH>"
        }
        Remove-EnvPath -Value $Name
    }

    default {
        Write-Host @"
Comandos disponíveis:
  psenv set <NAME> <VALUE> [-Type String|ExpandString]
  psenv remove <NAME>
  psenv get <NAME>
  psenv list
  psenv add-path <PATH>
  psenv remove-path <PATH>
"@
    }
}
