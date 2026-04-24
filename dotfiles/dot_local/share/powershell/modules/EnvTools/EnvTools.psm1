function Set-EnvVar {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Value,

        [ValidateSet("String", "ExpandString")]
        [string]$Type = "String"
    )

    $regPath = "HKCU:\Environment"

    New-ItemProperty `
        -Path $regPath `
        -Name $Name `
        -Value $Value `
        -PropertyType $Type `
        -Force | Out-Null

    Set-Item -Path "Env:$Name" -Value $Value
}

function Remove-EnvVar {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $regPath = "HKCU:\Environment"

    Remove-ItemProperty -Path $regPath -Name $Name -ErrorAction SilentlyContinue
    Remove-Item "Env:$Name" -ErrorAction SilentlyContinue
}

function Get-EnvVar {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $regPath = "HKCU:\Environment"
    $item = Get-ItemProperty -Path $regPath -Name $Name -ErrorAction SilentlyContinue

    return $item.$Name
}

function Get-EnvVars {
    Get-ItemProperty -Path "HKCU:\Environment"
}

function Resolve-PathEntry {
    param($Path)
    return ($Path -replace '/', '\').TrimEnd('\').ToLowerInvariant()
}

function Sync-SessionPath {
    $machine = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    $user = [System.Environment]::GetEnvironmentVariable("PATH", "User")

    if ($machine -and $user) {
        $env:PATH = "$machine;$user"
    }
    elseif ($machine) {
        $env:PATH = $machine
    }
    else {
        $env:PATH = $user
    }
}

function Add-EnvPath {
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    $regPath = "HKCU:\Environment"

    $current = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    $entries = if ($current) { $current -split ';' } else { @() }

    $normalized = $entries | ForEach-Object { Resolve-PathEntry $_ }

    if ($normalized -notcontains (Resolve-PathEntry $Value)) {
        $entries += $Value
    }

    $newPath = ($entries | Where-Object { $_ }) -join ';'

    New-ItemProperty `
        -Path $regPath `
        -Name "PATH" `
        -Value $newPath `
        -PropertyType "ExpandString" `
        -Force | Out-Null

    Sync-SessionPath
}

function Remove-EnvPath {
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    $regPath = "HKCU:\Environment"

    $current = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if (-not $current) { return }

    $entries = $current -split ';'

    $filtered = $entries | Where-Object {
        (Resolve-PathEntry $_) -ne (Resolve-PathEntry $Value)
    }

    $newPath = ($filtered | Where-Object { $_ }) -join ';'

    New-ItemProperty `
        -Path $regPath `
        -Name "PATH" `
        -Value $newPath `
        -PropertyType "ExpandString" `
        -Force | Out-Null

    Sync-SessionPath
}

Export-ModuleMember -Function `
    Set-EnvVar,
    Remove-EnvVar,
    Get-EnvVar,
    Get-EnvVars,
    Add-EnvPath,
    Remove-EnvPath
