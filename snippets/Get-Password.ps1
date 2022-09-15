function Get-Password {
    [char[]]$lch = "abcdefghjkmnopqrstuvwxyz"
    [char[]]$uch = "ABCDEFGHJKMNPQRSTUVWXYZ"
    [char[]]$nch = "123456789"
    [char[]]$sch = "&$#%=/*-+,!?=()@:._"
    [int]$pwlen = (0..5 | Get-Random) + 12
    $pwa = @($lch | Get-Random -Count $pwlen)
    [int[]]$ppos = @([int]0..[int]($pwlen - 1))
    for($i = 0; $i -lt 3; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $uch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    [int]$ni = 1..2 | Get-Random -Count 1
    for($i = 0; $i -lt $ni; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $nch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    $ni = 1..2 | Get-Random -Count 1
    for($i = 0; $i -lt $ni; $i++){
        $pos = $ppos | Get-Random -Count 1
        $pwa[$pos] = $sch | Get-Random -Count 1
        $ppos = $ppos | Where-Object { $_ -ne $pos }
    }
    return -join $pwa
}
Clear-Host
Get-Password