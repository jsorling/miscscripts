#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/nuget/GetNugetconfig.ps1'))

[string]$ec = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/nuget/nuget.config_"
$ec | Set-Content ".\nuget.config" -NoNewline
