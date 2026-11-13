# Driver de la placa para Windows

## Para qué sirve

El grabador web de Azukar le habla a la placa desde el navegador (Chrome o Edge) usando **WebUSB**. En Windows, WebUSB solo puede usar un dispositivo USB si tiene el driver **WinUSB** de Microsoft. El chip USB de la placa (FT2232HL) tiene dos canales y Windows les pone el driver de FTDI a los dos, así que el navegador no los puede usar.

Este instalador le pone WinUSB **solo al canal A**, el que graba la FPGA y la flash. El canal B, el puerto serie (COM), queda con el driver de FTDI. Hace lo mismo que Zadig, pero sin que el usuario tenga que elegir el dispositivo en una lista, y por eso no le puede cambiar el driver por error al mouse, a la placa de red o al canal B.

Se instala una sola vez por computadora. En Linux y macOS no hace falta.

## Archivos

| Archivo | Para qué |
|---|---|
| `driver_azukar.exe` | Instalador. Es lo único que necesita el usuario |
| `desinstalar_driver.bat` y `desinstalar.ps1` | Deshacen la instalación (útil en el laboratorio) |
| `UTN-FRT-AzukarWinUSB.cer` | Certificado público del driver. Lo usa el desinstalador para encontrarlo y quitarlo |

## Instalar

1. Enchufar la placa por USB.
2. Doble clic en `driver_azukar.exe`.
3. Windows muestra dos avisos:
   - SmartScreen: **Más información → Ejecutar de todas formas**;
   - el permiso de administrador: **Sí**.
4. Esperar a que la consola diga **`servicio: WinUSB`**.

## Desinstalar

1. Doble clic en `desinstalar_driver.bat` (pide permiso de administrador).
2. Desenchufar y volver a enchufar la placa. El canal A vuelve al driver de FTDI.

Hace falta, por ejemplo, para grabar la EEPROM con FT_Prog (ver `../ftdi-eeprom/`).

## Qué hace por dentro

El instalador agrega el certificado a los almacenes de confianza de Windows, carga el driver en Windows y lo asigna al canal A de la placa (`VID_0403&PID_6010&MI_00`). No trae ningún driver propio: usa `winusb.sys`, que ya viene firmado por Microsoft. El certificado solo sirve para firmar código.

El código fuente del paquete y los scripts para regenerarlo están en el repositorio del grabador web: https://github.com/maxisimonazzi/azukar-webusb-flasher
