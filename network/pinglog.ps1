$target = "192.168.1.1"
$errorfile = "C:\pingerror.txt"
$sleepsec = 15
$timestamp = (Get-Date).ToString("yyMMdd HH:mm:ss")

Write-Output "$timestamp Starting pinglog target $target." | Out-File -FilePath $errorfile -Append

while($true){
    $timestamp = (Get-Date).ToString("yyMMdd HH:mm:ss")
    Write-Host "$timestamp Pinging target $target..."

    try{
        Test-Connection $target  -ErrorAction "Stop" #-Quiet
    }
    catch {
        Write-Host "$timestamp Pinging target $target failed."
        Write-Output "$timestamp Pinging target $target failed." | Out-File -FilePath $errorfile -Append
    }
    
    sleep $sleepsec
}