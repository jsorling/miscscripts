#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/UpdateEditorConfigFile.ps1'))

[string]$ec = wget -UseBasicParsing -Uri "https://raw.githubusercontent.com/jsorling/miscscripts/main/dev/.editorconfig"

foreach ($f in Get-ChildItem -Path ".\" -Recurse -Include *.sln) {
    $ec | Set-Content "$($f.Directory)\.editorconfig" -NoNewline 
}