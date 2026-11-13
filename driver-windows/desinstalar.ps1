<#
    Deshace todo lo que hizo instalar_driver.ps1:
      1. saca el paquete del Driver Store (y desata el driver de la placa)
      2. saca el certificado de los almacenes Root y TrustedPublisher

    Despues de esto el Canal A vuelve al driver que Windows elija solo
    (normalmente el de FTDI). Sirve para probar el instalador desde cero.

    Lo lanza desinstalar_driver.bat, que se encarga del UAC.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

# ---------------------------------------------------------------- QuickEdit
# La consola de Windows viene con "QuickEdit" prendido: si el usuario hace clic
# adentro de la ventana (o la arrastra sin querer), entra en modo seleccion y
# CONGELA toda la salida hasta que se aprieta una tecla. Parece que el
# instalador se colgo, pero esta esperando. Lo apagamos para esta ventana.
function Disable-QuickEdit {
    try {
        if (-not ('ConsolaWin.Nativo' -as [type])) {
            Add-Type -Namespace ConsolaWin -Name Nativo -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true)]
public static extern System.IntPtr GetStdHandle(int nStdHandle);
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true)]
public static extern bool GetConsoleMode(System.IntPtr hConsoleHandle, out uint lpMode);
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true)]
public static extern bool SetConsoleMode(System.IntPtr hConsoleHandle, uint dwMode);
'@
        }
        $h = [ConsolaWin.Nativo]::GetStdHandle(-10)   # STD_INPUT_HANDLE
        [uint32]$modo = 0
        if ([ConsolaWin.Nativo]::GetConsoleMode($h, [ref]$modo)) {
            $QUICK_EDIT = 0x0040
            $INSERT_MODE = 0x0020
            $EXTENDED_FLAGS = 0x0080
            $nuevo = ($modo -band -bnot ($QUICK_EDIT -bor $INSERT_MODE)) -bor $EXTENDED_FLAGS
            [void][ConsolaWin.Nativo]::SetConsoleMode($h, $nuevo)
        }
    } catch {
        # Si no hay consola real, seguimos igual.
    }
}
Disable-QuickEdit

$Cer = Join-Path $PSScriptRoot 'UTN-FRT-AzukarWinUSB.cer'

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
         ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host '[ERROR] Hay que correrlo como Administrador. Usa desinstalar_driver.bat.' -ForegroundColor Red
    exit 1
}

Write-Host '=========================================================='
Write-Host '   DESINSTALADOR DE CONTROLADOR WINUSB - Canal A'
Write-Host '=========================================================='
Write-Host ''

# ---------------------------------------------------------------- 1. driver store
# Los paquetes publicados se copian a C:\Windows\INF\oemNN.inf. Buscamos por
# contenido y no por el listado de pnputil, que esta traducido y cambia de idioma.
Write-Host '[1/2] Buscando el paquete en el Driver Store...'
$found = @()
Get-ChildItem 'C:\Windows\INF\oem*.inf' -ErrorAction SilentlyContinue | ForEach-Object {
    if (Select-String -Path $_.FullName -Pattern 'UTN-FRT|azukar_winusb' -Quiet -ErrorAction SilentlyContinue) {
        $found += $_.Name
    }
}
if ($found.Count -eq 0) {
    Write-Host '      No hay nada instalado. Nada que borrar.'
} else {
    foreach ($oem in $found) {
        Write-Host "      borrando $oem ..."
        & pnputil.exe /delete-driver $oem /uninstall /force | ForEach-Object { "        $_" }
        if ($LASTEXITCODE -ne 0) {
            Write-Host "      pnputil devolvio $LASTEXITCODE en $oem" -ForegroundColor Yellow
        }
    }
}

# ---------------------------------------------------------------- 2. certificados
Write-Host ''
Write-Host '[2/2] Sacando el certificado de los almacenes...'
$thumb = $null
if (Test-Path $Cer) {
    $thumb = (New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $Cer).Thumbprint
}
foreach ($store in @('Root', 'TrustedPublisher')) {
    $path = "Cert:\LocalMachine\$store"
    $hits = Get-ChildItem $path -ErrorAction SilentlyContinue | Where-Object {
        ($thumb -and $_.Thumbprint -eq $thumb) -or $_.Subject -like '*OU=UTN-FRT*'
    }
    if (-not $hits) { Write-Host "      $store  (no habia nada)"; continue }
    foreach ($h in $hits) {
        Remove-Item -Path (Join-Path $path $h.Thumbprint) -Force
        Write-Host "      $store  quitado $($h.Thumbprint)"
    }
}

Write-Host ''
Write-Host 'Listo. Desenchufa y volve a enchufar la placa para que Windows la re-detecte.' -ForegroundColor Green
Write-Host ''
