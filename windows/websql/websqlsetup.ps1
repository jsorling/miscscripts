#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/windows/websql/websqlsetup.ps1')) ;Install-Websql name.server.com
#. .\websqlsetup.ps1; Set-Dirs
Add-Type -AssemblyName 'System.Web'
$installpath = "C:\websql"

function Install-Websql {
    Write-Host "Install-Websql..."
    Set-Dirs
    Install-SQL
    Install-DotNet
    Set-Firewall
    Set-HttpSys    
} ## Install-Websql

function Set-Dirs {
    Write-Host "Set-Dirs..."
    if(!(Test-Path $installpath))
    {
        Write-Host "Creating installation directory $installpath"
        New-Item -ItemType Directory -Force -Path $installpath > $null
    }
    if(!(Test-Path $installpath\certs))
    {
        Write-Host "Creating certs directory $installpath\certs"
        New-Item -ItemType Directory -Force -Path $installpath\certs > $null
    }
    if(!(Test-Path $installpath\websites))
    {
        Write-Host "Creating websites directory $installpath\websites"
        New-Item -ItemType Directory -Force -Path $installpath\websites > $null
    }
} ## Set-Dirs

function Install-SQL {
    Write-Host "Install-SQL..."
    $sqlinstancename = "MSSQLSERVER"
    $sqlservice = Get-Service -Name $sqlinstancename -ErrorAction SilentlyContinue
    $sqlsapwd = [System.Web.Security.Membership]::GeneratePassword(32, 9)
    if($sqlservice -eq $null)
    {
        $sqlsetup = "SQLEXPR_x64_ENU.exe"
        ## http://downloadsqlserverexpress.com/
        $SQLURL = "https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLEXPR_x64_ENU.exe"
    
        Write-Host "Downloading $sqlsetup"
        Invoke-WebRequest $SQLURL -OutFile $installpath\$sqlsetup
        Write-Host "Unpacking $sqlsetup to $installpath\sqlinstall"
        Start-Process -Filepath $installpath\$sqlsetup "/Q", "/x:$installpath\sqlinstall" -Wait

        Write-Host "Creating $installpath\sqlinstall\sql.ini"

        if(!(Test-Path "$installpath\sql\$sqlinstancename"))
        {
          New-Item -ItemType Directory -Force -Path "$installpath\sql\$sqlinstancename" > $null
        }

        $ini = @"
[OPTIONS]
ACTION = "INSTALL"
UPDATEENABLED = "True"
USEMICROSOFTUPDATE = "True"
FEATURES = SQLENGINE,TOOLS
INSTANCEDIR = "$installpath\sql\$sqlinstancename"
SQLCOLLATION = "SQL_Latin1_General_CP1_CS_AS"
AGTSVCSTARTUPTYPE = "Manual"
SQLSVCSTARTUPTYPE = "Automatic"
FILESTREAMLEVEL = "0"
SQLSVCINSTANTFILEINIT = "True"
SQLSYSADMINACCOUNTS = "$env:USERDOMAIN\$env:USERNAME"
TCPENABLED = "1"
NPENABLED = "0"
INSTANCENAME = "$sqlinstancename"
IACCEPTSQLSERVERLICENSETERMS = "True"
QUIET = "True"
SECURITYMODE = "SQL"
SAPWD = "$sqlsapwd"
"@
        $ini | Out-File $installpath\sqlinstall\sql.ini -Force

        Write-Host "Setting up $installpath\sqlinstall\SETUP.EXE"
        Start-Process -Filepath $installpath\sqlinstall\SETUP.EXE "/ConfigurationFile=$installpath\sqlinstall\sql.ini" -Wait

        Write-Host "Open firewall  SQL port 1433"
        New-NetFirewallRule -DisplayName "SQLServer1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
    }
} ## Install-SQL

function Install-DotNet {
    Write-Host "Install-DotNet..."
    $dotnetsdkversionfile = "$installpath\dotnetsdkversion.txt"
    if(!(Test-Path $dotnetsdkversionfile))
    {
        $dotnet = "dotnetsdk.exe"
        $url = "https://aka.ms/dotnet/6.0/dotnet-sdk-win-x64.exe"
        Invoke-WebRequest -Uri $url -OutFile $installpath\$dotnet
        Start-Process -Filepath $installpath\$dotnet "/passive" -Wait
        & dotnet --version >> $dotnetsdkversionfile
    }
} ## Install-DotNet

function Set-Firewall {
    Write-Host "Set-Firewall..."
    $httpfirewall = "websql HTTP(S) 80, 443"
    $hr = Get-NetFirewallRule -DisplayName $httpfirewall 2> $null
    if (-not $hr)
    {
        Write-Host "Creating firewall rule $httpfirewall"
        New-NetFirewallRule -DisplayName $httpfirewall -Direction Inbound -LocalPort 80,443 -Protocol TCP -Action Allow > $null
    }    
} ## Set-Firewall

function Set-HttpSys {
    Write-Host "Set-HttpSys..."
    
    $registryPath = "HKLM:\\SYSTEM\CurrentControlSet\Services\HTTP\Parameters"
    $Name = "DisableServerHeader"
    $value = "2"

    if(!(Test-Path $registryPath))
    {
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
    }
    else 
    {
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
    }
} ## Set-HttpSys

function Request-ComputerCert {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ComputerDNSName
    )

    & $installpath\certs\Sorling.AcmeV2HCP.exe $ComputerDNSName
    Rename-Item -Path $installpath\certs\$ComputerDNSName.pfx -NewName machine.pfx
    $tp = (Get-PfxCertificate -FilePath $installpath\certs\machine.pfx).Thumbprint
    Import-PfxCertificate -FilePath $installpath\certs\machine.pfx  -CertStoreLocation Cert:\LocalMachine\My
    netsh http add sslcert ipport=0.0.0.0:443 certhash=$tp
    wmic /namespace:\\root\cimv2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash=$tp
    Write-Host "TermService needs to be restarted, net stop/start TermService"
} ## Set-MachineCert

function Set-LetsEncryptAccInfo {
    $accinfofile = "$installpath\certs\AcmeV2HCPAccInfo.json"
    if((Test-Path $accinfofile))
    {
        Remove-Item $accinfofile -Force | Out-Null
    }
    & $installpath\certs\Sorling.AcmeV2HCP.exe
    & notepad $accinfofile
} ## Set-LetsEncryptAccInfo
