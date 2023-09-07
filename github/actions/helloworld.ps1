#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/github/actions/helloworld.ps1'))
Write-Host "Hello world"
#https://docs.github.com/en/actions/learn-github-actions/variables
Write-Host $env:GITHUB_RUN_NUMBER
Write-Host $env:PS_SOURCE_URL
Write-Host $env:IN_ONE
Write-Host "Good bye"
