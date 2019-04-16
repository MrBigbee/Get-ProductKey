#Définition de la fonction
function Get-ProductKey {
	#Obtention de la clé de regsitre contenant la clé Windows dans une variable
    $rpk = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DigitalProductId
    $i = 28
    $rpkOffset = 52
    $PossibleChars = "BCDFGHJKMPQRTVWXY2346789"
    do {
        $Accumulator = 0
        $j = 14
        do {
            $Accumulator = $Accumulator * 256
            $Accumulator = $rpk[$j + $rpkOffset] + $Accumulator
            $Accumulator / 24 -match "^\d*" | Out-Null
            $rpk[$j + $rpkOffset] = $matches[0] -band 255
            $Accumulator = $Accumulator % 24
            $j--
            } while ($j -ge 0)
        $i--
        $ProductKey = $PossibleChars.Substring($Accumulator, 1) + $ProductKey
        if ((29 - $i) % 6 -eq 0 -and $i -ne -1) {
            $i--
            $ProductKey = "-" + $ProductKey
        }
    } while ($i -ge 0)
$ProductKey
}

#Appel de la fonction
Get-ProductKey

pause