$target = "192.168.1.150"
$errorfile = "C:\pingerror.txt"

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
    
    sleep 15
}