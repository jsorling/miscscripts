#iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jsorling/miscscripts/main/build/buildinfo.ps1'))
if (-not (Test-Path env:BUILD_BUILDNUMBER)) { $env:BUILD_BUILDNUMBER = '0' }
$dpart = ((Get-Date).Year - 2020).ToString() + ((Get-Date).DayOfYear).ToString("000")

foreach ($f in Get-ChildItem -Path ".\" -Recurse -Include *.csproj) {
    Write-Host $f
    [xml]$proj = Get-Content $f
    $projver = $proj.SelectSingleNode("//Project/PropertyGroup/Version").InnerText
    if($projver.Length -gt 3){
        Write-Host $f
        $projver
        $version = -split $projver.Replace('.', ' ')
        if($version.Count -gt 1){
            $proj.SelectSingleNode("//Project/PropertyGroup/Version").InnerText = "$($version[0]).$($version[1]).$dpart.$env:BUILD_BUILDNUMBER"

            if($proj.SelectSingleNode("//Project/PropertyGroup/FileVersion").Length -lt 1){
                $null = $proj.SelectSingleNode("//Project/PropertyGroup/Version").ParentNode.AppendChild($proj.CreateElement("FileVersion"))
            }
            if($proj.SelectSingleNode("//Project/PropertyGroup/AssemblyVersion").Length -lt 1){
                $null = $proj.SelectSingleNode("//Project/PropertyGroup/Version").ParentNode.AppendChild($proj.CreateElement("AssemblyVersion"))                
            }            
            $proj.SelectSingleNode("//Project/PropertyGroup/FileVersion").InnerText = "$($version[0]).$($version[1]).$dpart.$env:BUILD_BUILDNUMBER"
            $proj.SelectSingleNode("//Project/PropertyGroup/AssemblyVersion").InnerText = "$($version[0]).$($version[1]).$dpart.$env:BUILD_BUILDNUMBER"

            $proj.Save($f)
        }
    }
}