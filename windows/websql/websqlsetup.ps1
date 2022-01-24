Add-Type -AssemblyName 'System.Web'

$installpath = "C:\websql"
If(!(Test-Path $installpath))
{
      New-Item -ItemType Directory -Force -Path $installpath
}

##start sqlexpress
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
    & $installpath\$sqlsetup /Q /x:$installpath\sqlinstall | Out-Null

    Write-Host "Creating $installpath\sqlinstall\sql.ini"
    $ini = @"
[OPTIONS]
ACTION = "INSTALL"
UPDATEENABLED = "True"
USEMICROSOFTUPDATE = "True"
FEATURES = SQLENGINE,TOOLS
INSTANCEDIR = "$installpath\sql\$sqlinstancename"
INSTALLSHAREDDIR = "$installpath\sql"
SQLBACKUPDIR = "$installpath\sqlbackup\"
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
    & $installpath\sqlinstall\SETUP.EXE /ConfigurationFile=$installpath\sqlinstall\sql.ini -Wait

    Write-Host "Open firewall  SQL port 1433"
    New-NetFirewallRule -DisplayName "SQLServer1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
}
##end sqlexpress

## start dotnet core sdk
$dotnetsdkversionfile = "$installpath\dotnetsdkversion.txt"
If(!(Test-Path $dotnetsdkversionfile))
{
    $dotnet = "dotnetsdk.exe"
    $url = "https://aka.ms/dotnet/6.0/dotnet-sdk-win-x64.exe"
    Invoke-WebRequest -Uri $url -OutFile $installpath\$dotnet
    Start-Process -Filepath $installpath\$dotnet /passive -Wait
    & dotnet --version >> $dotnetsdkversionfile
}
## end dotnet core sdk
