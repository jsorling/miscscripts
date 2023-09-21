#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/github/actions/buildinfo.ps1'))
if (-not (Test-Path env:GITHUB_RUN_NUMBER)) { $env:GITHUB_RUN_NUMBER = '0' }

foreach ($f in Get-ChildItem -Path ".\" -Recurse -Include *.csproj) {
    [xml]$proj = Get-Content $f
    $projver = $proj.SelectSingleNode("//Project/PropertyGroup/Version").InnerText
    if($projver.Length -gt 3) {
        $version = -split $projver.Replace('.', ' ')
        if($version.Count -gt 1) {
            Write-Host $f
            $newver = "$($version[0]).$($version[1]).$($version[2]).$env:GITHUB_RUN_NUMBER"
            Write-Host "$projver -> $newver"

            $proj.SelectSingleNode("//Project/PropertyGroup/Version").InnerText = $newver

            if($proj.SelectSingleNode("//Project/PropertyGroup/FileVersion").InnerText.Length -lt 1) {
                $null = $proj.SelectSingleNode("//Project/PropertyGroup/Version").ParentNode.AppendChild($proj.CreateElement("FileVersion"))
            }
            if($proj.SelectSingleNode("//Project/PropertyGroup/AssemblyVersion").InnerText.Length -lt 1) {
                $null = $proj.SelectSingleNode("//Project/PropertyGroup/Version").ParentNode.AppendChild($proj.CreateElement("AssemblyVersion"))
            }
                       
            $proj.SelectSingleNode("//Project/PropertyGroup/FileVersion").InnerText = $newver
            $proj.SelectSingleNode("//Project/PropertyGroup/AssemblyVersion").InnerText = $newver

            if($proj.SelectSingleNode("//Project/PropertyGroup/Copyright").InnerText.Length -gt 0) {
                Write-Host "$($proj.SelectSingleNode("//Project/PropertyGroup/Copyright").InnerText) -> $($proj.SelectSingleNode("//Project/PropertyGroup/Copyright").InnerText.Replace('@year', (Get-Date).Year.ToString()))"
                $proj.SelectSingleNode("//Project/PropertyGroup/Copyright").InnerText = $proj.SelectSingleNode("//Project/PropertyGroup/Copyright").InnerText.Replace('@year', (Get-Date).Year.ToString())
            }

            $proj.Save($f)

            $dir = Split-Path -Path $f
            foreach ($b in Get-ChildItem -Path $dir -Recurse -Include BuildInfo.cs,BuildInfo.cshtml) {
                Write-Host $b
                ((Get-Content -Path $b -Raw) -replace 'vv.vv.vv.vv', $newver) | Set-Content -Path $b -NoNewline
                ((Get-Content -Path $b -Raw) -replace 'dddd.dd.dd', (Get-Date -Format "yyyy-MM-dd").Trim()) | Set-Content -Path $b -NoNewline
            }
        }
    }
}