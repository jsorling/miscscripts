#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/github/actions/helloworld.ps1'))
Write-Host "Hello world"
Write-Host $env:GITHUB_RUN_NUMBER
Write-Host "Good bye"
