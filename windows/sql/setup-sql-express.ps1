#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/windows/sql/setup-sql-express.ps1'))
$installpath = "C:\vmhosttools"

function Set-Dirs {
    Write-Host "Set-Dirs..."
    if(!(Test-Path $installpath))
    {
        Write-Host "Creating installation directory $installpath"
        New-Item -ItemType Directory -Force -Path $installpath > $null
    }    
} ## Set-Dirs

function Get-Password {
    [char[]]$lch = "abcdefghjkmnopqrstuvwxyz"
    [char[]]$uch = "ABCDEFGHJKMNPQRSTUVWXYZ"
    [char[]]$nch = "123456789"
    [char[]]$sch = "&$#%=/*-+,!?=()@:._"
    [int]$pwlen = (0..5 | Get-Random) + 21
    $pwa = @($lch | Get-Random -Count $pwlen)
    [int[]]$ppos = @([int]0..[int]($pwlen - 1))
    for($i = 0; $i -lt 3; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $uch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    [int]$ni = 1..2 | Get-Random -Count 1
    for($i = 0; $i -lt $ni; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $nch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    $ni = 1..2 | Get-Random -Count 1
    for($i = 0; $i -lt $ni; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $sch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    return -join $pwa
}

function Install-SQL {
    Set-Dirs
    Write-Host "Install-SQL..."

    if(!(Test-Path $installpath\sqlinstall))
    {
        Write-Host "Creating SQL installation directory $installpath\sqlinstall"
        New-Item -ItemType Directory -Force -Path $installpath\sqlinstall > $null
    }

    $sqlinstancename = "MSSQLSERVER"
    $sqlservice = Get-Service -Name $sqlinstancename -ErrorAction SilentlyContinue
    $sqlsapwd = Get-Password
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

Install-SQL