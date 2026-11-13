# Configuración de la EEPROM del FT2232HL

El FT2232HL es el chip que conecta la placa con la computadora por USB. Tiene al lado una memoria EEPROM (M93C66) donde se guarda su configuración: el nombre con el que aparece en la computadora, el número de serie y el modo de trabajo de cada uno de sus dos canales.

`template_azukar.xml` es esa configuración, en el formato de **FT_Prog**, el programa gratuito de FTDI para grabar la EEPROM en Windows.

## Qué configura

| Campo | Valor |
|---|---|
| Chip | FT2232H |
| VID / PID | 0403 / 6010 (los de fábrica de FTDI) |
| Fabricante | `UTN - FRT` |
| Descripción del producto | `--.. Azukar FPGA ..--` |
| Número de serie | `AZK00001` (genérico; ver más abajo) |
| Alimentación | Por el bus USB, 500 mA como máximo |
| Canal A | Modo 245 FIFO, driver D2XX. Es el canal que graba la FPGA y la flash |
| Canal B | Modo UART, driver VCP. Es el puerto serie (COM) entre la FPGA y la computadora |
| Pines de E/S | 4 mA, sin Schmitt, sin *slew* lento |

## Antes de grabar: el driver del canal A

FT_Prog solo ve la placa si el canal A usa el **driver de FTDI**, que es el que Windows instala solo al enchufarla por primera vez.

Para grabar la FPGA desde el navegador (WebUSB), el canal A se cambia al driver **WinUSB** con el instalador de la carpeta [`../driver-windows/`](../driver-windows/README.md) (o con Zadig). Si en esa computadora ya se hizo ese cambio, FT_Prog no encuentra la placa. Para volver atrás:

- **Si se instaló con `driver_azukar.exe`:** correr `desinstalar_driver.bat` de esa misma carpeta, y desenchufar y volver a enchufar la placa.
- **Si se usó Zadig:** en el **Administrador de dispositivos**, buscar el canal A (puede figurar como "USB Serial Converter A" o como "Dual RS232-HS"), clic derecho → **Desinstalar el dispositivo**, tildando **Intentar quitar el controlador de este dispositivo**. Después, desenchufar y volver a enchufar la placa.

Para saber qué driver tiene el canal A: en el Administrador de dispositivos, **Propiedades → Controlador → Detalles del controlador**. Si aparece `winusb.sys`, tiene WinUSB.

Después de grabar la EEPROM, para volver a usar el grabador web, instalar otra vez `driver_azukar.exe`.

## Cómo grabarla

1. Abrir FT_Prog con la placa enchufada.
2. **Devices → Scan and Parse**: lee la EEPROM actual.
3. **File → Open Template** y elegir `template_azukar.xml`.
4. **Devices → Program** y confirmar.
5. Desenchufar y volver a enchufar la placa.

## El número de serie

La plantilla trae el número de serie genérico `AZK00001`. Si se graban varias placas con la misma plantilla, todas quedan con el mismo número. Para que cada placa tenga el suyo, hay dos formas:

- **Cambiarlo a mano en cada placa:** en el XML, el valor de la clave `<SerialNumber>`. También se puede cambiar en FT_Prog después de abrir la plantilla, en *USB String Descriptors → Serial Number*, antes de grabar. Conviene usar 8 caracteres, letras mayúsculas y números, por ejemplo `AZK00002`.
- **Que FT_Prog lo genere solo:** poner `<SerialNumber_AutoGenerate>true</SerialNumber_AutoGenerate>`. FT_Prog arma un número con el prefijo de la clave `<SerialNumberPrefix>` (hoy `FT`) seguido de caracteres propios.

La clave `<SerialNumber_Enabled>` tiene que quedar en `true`: si no, la placa no informa ningún número de serie.
