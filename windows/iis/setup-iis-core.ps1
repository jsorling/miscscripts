#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/windows/iis/setup-iis-core.ps1'))
$installpath = "C:\vmhosttools"

function Set-Dirs {
    Write-Host "Set-Dirs..."
    if(!(Test-Path $installpath))
    {
        Write-Host "Creating installation directory $installpath"
        New-Item -ItemType Directory -Force -Path $installpath > $null
    }    
} ## Set-Dirs

function SetWindowsFeature{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$featureName,
        [Parameter(Mandatory)]
        [bool]$turnOff
    )

    if(-not (Get-WindowsFeature -Name $featureName).Installed -and -not $turnOff){
        Add-WindowsFeature $featureName
    } 
    if($turnOff) {
        Remove-WindowsFeature $featureName
    }
}

function Install-IIS {
    Set-Dirs
    Write-Host "Installing IIS..."

    SetWindowsFeature Web-Default-Doc $false
    SetWindowsFeature Web-Http-Errors $false
    SetWindowsFeature Web-Static-Content $false
    SetWindowsFeature Web-Http-Logging $false
    SetWindowsFeature Web-Stat-Compression $false
    SetWindowsFeature Web-WebSockets $false

    #https://dotnet.microsoft.com/permalink/dotnetcore-current-windows-runtime-bundle-installer
    $url = "https://download.visualstudio.microsoft.com/download/pr/c5e0609f-1db5-4741-add0-a37e8371a714/1ad9c59b8a92aeb5d09782e686264537/dotnet-hosting-6.0.8-win.exe"
    $outpath = "$installpath\corehostingbundle.exe"
    Invoke-WebRequest -Uri $url -OutFile $outpath
    Start-Process -Filepath $outpath -ArgumentList "-install -quiet"

    net stop w3svc /y
    net start w3svc
    
    Stop-IISSite -Name 'default web site' -Confirm:$false
           
} ## Install-IIS

function UnInstall-IIS {   
    Set-Dirs
    Write-Host "UnInstalling IIS..."

    net stop w3svc /y

    SetWindowsFeature Web-Default-Doc $true
    SetWindowsFeature Web-Http-Errors $true
    SetWindowsFeature Web-Static-Content $true
    SetWindowsFeature Web-Http-Logging $true
    SetWindowsFeature Web-Stat-Compression $true
    SetWindowsFeature Web-WebSockets $true  
    
    shutdown -r 
} ## UnInstall-IIS


#UnInstall-IIS
Install-IIS