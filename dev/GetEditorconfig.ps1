#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/GetEditorconfig.ps1'))

[string]$ec = wget -UseBasicParsing -Uri "https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/.editorconfig"
$ec | Set-Content ".\.editorconfig" -NoNewline