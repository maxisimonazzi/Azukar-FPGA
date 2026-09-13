# Azukar: por qué `iceprog -S` (SRAM slave) no configura la FPGA

Documento de hardware + protocolo. El botón **Grabar en SRAM** se sacó de `/fpga-webusb` hasta que el cableado (o el software del GPIO extra) esté listo. La grabación por **flash** sigue siendo el camino que funciona.

No es un bug del `.bin`. Compilar y mandar 135 100 bytes a la flash + Reset deja `CDONE=1`. El mismo bitstream, clockeado como slave, deja `CDONE=0`.

---

## 1. Dos modos de configuración de la iCE40

La SRAM de configuración de la iCE40 (HX4K en Azukar) **siempre** se llena igual: un bitstream icepack entra a la CRAM. Cambia **quién** lo empuja.

### 1.1 Master SPI (lo que Azukar hace hoy y funciona)

Al soltar `CRESET_B`, la FPGA mira `SPI_SS_B`:

| `SPI_SS_B` en el flanco de CRESET | Modo | Quién mueve SCK |
|-----------------------------------|------|-----------------|
| **alto** (pull-up) | **SPI Master** | la FPGA |
| **bajo** | **SPI Slave** | el host (FTDI) |

En master:

1. FTDI (o el usuario) suelta CRESET y CS a high-Z.
2. Pull-ups llevan CS/SS a 3V3.
3. La FPGA maneja SCK, baja `SPI_SS_B` (= CS de la W25X40) y lee el bitstream desde la flash.
4. Cuando termina, `CDONE` sube. El LED DONE se enciende.

Por eso **Grabar en flash → Reset** funciona: no le hablamos a la FPGA; le escribimos la receta a la NOR y la FPGA se sirve sola.

### 1.2 Slave SPI (`iceprog -S`, SRAM volátil)

Secuencia Lattice / IceStorm (`iceprog.c`, GPIO `set_cs_creset`):

1. Bajar **CS y CRESET** (FPGA en reset, SS ya bajo).
2. Esperar (microsegundos a un par de ms).
3. **Soltar CRESET** (high-Z + pull-up) **dejando CS/SS bajo**.
4. En ese flanco la FPGA entra en slave: SCK/MOSI los pone el FTDI, `SPI_SS_B` es chip-select **hacia** la FPGA.
5. Clockear el `.bin` (icepack) por MOSI.
6. Unos clocks dummy (`0xFF`).
7. `CDONE` debería ponerse a 1. El diseño corre desde la CRAM. **No toca la flash.** Un Reset o un corte de luz recarga la flash (si hay bitstream) o deja DONE apagado (si la flash está vacía).

En software nuestro eso es `sramReset` → `sramSelect` → `sramSend`. El log de Azukar llega hasta `SRAM 135100/135100` y después `CDONE=0`. El fallback hace un reset de configuración: con flash vacía, `fallback flash CDONE=0`; con flash grabada, `CDONE=1` pero **eso es el diseño de la flash, no el de SRAM**.

---

## 2. Cableado actual de Azukar (medido / esquemático)

Un solo net de chip-select:

```text
FTDI Flash_CS  (ADBUS4, iceprog bit 4, máscara 0x10)
    │
    ├──────── pin 1  /CS     W25X40
    ├──────── pin 71 IOB_108_SS   iCE40HX4K-TQ144   (= SPI_SS_B de configuración)
    └──────── 10 kΩ a 3V3
```

SCK / MOSI / MISO del FTDI están compartidos con la flash y con los pines SPI de configuración de la FPGA (mismo bus que usa el master para leer la NOR). `CRESET_B` va a ADBUS7; `CDONE` a ADBUS6.

Eso es **el esquema Alhambra / iCEstick / `ice40_generic`**: un CS para los tres (FTDI, flash, SS de la FPGA).

Consecuencias:

- **Grabar flash funciona.** CRESET=0 → la FPGA suelta el bus → el FTDI habla solo con la W25X40.
- **Boot master funciona.** CS high-Z + pull-up → SS alto al soltar CRESET → la FPGA es master y selecciona la flash con el mismo pin 71.
- **Slave y flash se seleccionan juntos.** Cuando el FTDI baja ADBUS4 para poner a la FPGA en slave, **también** baja `/CS` de la W25X40. La flash escucha los 135 KiB como si fueran comandos SPI (basura). Puede contestar por MISO, entrar en un modo raro, o simplemente no importar. En Alhambra conviven igual; a veces `iceprog -S` se cuelga esperando CDONE ([apio#596](https://github.com/FPGAwars/apio/issues/596)).

El diagnóstico “falta atar SS al CS del FTDI” **está descartado**. El puente ya existe.

---

## 3. Qué hace el software hoy (y por qué no lo “arregla”)

GPIO iceprog (`frontend/src/fpga/iceprogPins.ts`):

| Función | CS (bit4) | CRESET (bit7) | Uso |
|---------|-----------|---------------|-----|
| `iceprogChipSelect` | salida 0 | salida 0 | dueño del SPI, FPGA en reset (flash) |
| `iceprogChipDeselect` | high-Z | salida 0 | FPGA en reset, flash idle |
| `iceprogReleaseBus` | high-Z | high-Z | boot master desde flash |
| `iceprogSramSelect` | salida 0 | high-Z | slave: SS bajo, CRESET suelto |

No hay un bit aparte para “SS de la FPGA”. Slave y flash CS son el mismo GPIO.

Cosas que **no** son la causa (ya se probaron o se descartaron):

- El `.bin` compilado (~135 KiB). El mismo archivo graba flash y bootea.
- Un dump de 512 KiB (chip entero). Eso era otro bug; ya se recorta. SRAM se probó con 135 100 bytes.
- `spiInit` a mitad de sesión (resetear el FTDI glitcheaba pines). Se sacó; CDONE sigue en 0.
- Permiso USB / placa equivocada.

Hipótesis que quedan, en orden:

1. **La flash en el bus durante el shift slave** (mismo CS). Experimento: aislar `/CS` de la W25X40 (levantar el pin, o un corte temporal) y repetir SRAM. Si ahí `CDONE=1`, el culpable es la NOR escuchando.
2. **Timing del flanco de CRESET.** Slave se decide cuando CRESET sube con SS ya bajo. CRESET se suelta a high-Z; depende del pull-up. Si el flanco es lento o SS rebota, puede muestrear master.
3. **Polaridad / clocks dummy** al final del bitstream. iceprog manda extras; nosotros también. Menos probable si el conteo de bytes es exacto.

Mientras SS y flash CS sean el mismo net, **no hay fix de software** que evite que la W25X40 vea el bitstream slave.

---

## 4. Revisión de hardware propuesta: ADBUS3 → SS “solito”

ADBUS3 del FT2232H (canal A, bit 3, máscara `0x08`) hoy no se usa en iceprog. La idea: cablearlo al `SPI_SS_B` de la FPGA y **no** a la flash.

### 4.1 Si se agrega ADBUS3 **sin cortar** el net actual

```text
ADBUS4 ──┐
ADBUS3 ──┼── /CS flash ── pin 71 SS ── 10k a 3V3
```

ADBUS3 y ADBUS4 quedan **en cortocircuito**. No aislás nada. Bajar ADBUS3 es lo mismo que bajar ADBUS4. **No arregla SRAM.** Solo duplicás un GPIO.

### 4.2 Si se **separan** los nets (lo que “solito” tiene que significar)

```text
ADBUS4 ──── /CS W25X40 ──── 10k a 3V3     (solo flash)

ADBUS3 ──── pin 71 SPI_SS_B ──── 10k a 3V3  (solo FPGA)
```

Hay que **cortar** el cable que hoy une flash `/CS` con IOB_108_SS.

Entonces el software puede:

- **Flash:** CRESET=0, ADBUS4=0, ADBUS3=high-Z (SS de la FPGA no importa: ella está en reset y no toca el bus). Igual que ahora.
- **SRAM slave:** ADBUS3=0, ADBUS4=**1 o high-Z** (flash *no* seleccionada), CRESET bajo y después suelto. La FPGA entra en slave; la W25X40 no come 135 KiB de basura.
- Hace falta **cambiar el programador**: `sramSelect` tiene que bajar el bit 3, no el bit 4. Hoy `PIN_CS = 0x10`.

**¿Arregla el slave?** Sí, esa es la arquitectura limpia. El host elige la FPGA sin elegir la flash.

**Costo: se rompe el boot master**, salvo que agregues un camino FPGA→flash.

En master, la iCE40 **tiene** que bajar `SPI_SS_B` para seleccionar la W25X40. Si pin 71 ya no está unido a `/CS` de la flash, la FPGA no puede leer la NOR. Después de un Reset o un power-on, `CDONE` se queda en 0 aunque la flash tenga un bitstream perfecto.

Tres salidas de diseño:

| Opción | SRAM slave | Boot desde flash | Complejidad |
|--------|------------|------------------|-------------|
| **A.** Dejar el triple net (hoy) | Flaky / no | Sí | Cero. Es Alhambra. |
| **B.** Separar nets, ADBUS3=SS, ADBUS4=flash CS | Sí (con software nuevo) | **No** | Un corte + un cable. La placa solo se programa por SRAM (o siempre re-grabás flash y nunca confiás en el boot). |
| **C.** Separar + FET / buffer / jumper | Sí | Sí | El FET une FPGA SS → flash CS cuando ADBUS3 está high-Z (master). O un jumper “SRAM vs boot”. |

La opción que vale la pena en una rev.2 es **C** (o B si aceptás “esta placa no bootea sola, siempre SRAM o siempre re-flash desde la PC”).

### 4.3 Pull-ups

Cada net separado necesita su 10 kΩ a 3V3:

- Flash `/CS` high si el FTDI no la toca (idle).
- `SPI_SS_B` high al soltar CRESET → master, **si** todavía existe el camino a la flash (opción C).

CRESET también necesita pull-up (ya debería tenerlo; no es el de 10 kΩ del CS).

### 4.4 Software el día que exista ADBUS3

En `iceprogPins.ts`:

```text
PIN_FLASH_CS = 0x10   // ADBUS4, W25X40
PIN_FPGA_SS  = 0x08   // ADBUS3, SPI_SS_B
```

- Flash program: direction incluye `PIN_FLASH_CS | PIN_CRESET`, no `PIN_FPGA_SS`.
- SRAM: direction incluye `PIN_FPGA_SS`, CRESET high-Z, `PIN_FLASH_CS` high-Z o 1.
- Release bus: ambos CS/SS high-Z.

Hasta que el cobre esté cortado **y** el JS conozca el bit 3, no reponer el botón en la UI.

---

## 5. Ejemplos de laboratorio

### 5.1 Qué ves hoy (flash vacía + SRAM del compilado)

```text
[mpsse] SRAM shifting 135100 bytes
[mpsse] SRAM 135100/135100
[mpsse] SRAM CDONE=0. …
[mpsse] fallback flash CDONE=0 — flash vacía, o este cableado no tiene slave SPI
```

Interpretación: el slave no tomó (o CDONE no subió). El fallback recarga flash; no hay bitstream → DONE apagado.

### 5.2 Qué ves hoy (flash con diseño + SRAM de *otro* diseño)

```text
[mpsse] SRAM CDONE=0. …
[mpsse] fallback flash CDONE=1 — lo que ves es el diseño de la flash, no SRAM
```

Los LEDs son el Verilog **viejo** de la NOR. No es que SRAM “haya andado a medias”.

### 5.3 Experimento para echarle la culpa a la W25X40

1. Flash vacía o da igual.
2. Aislar `/CS` de la flash (no desoldar el resto del SPI si no hace falta).
3. Compilar, Conectar, secuencia SRAM.
4. Si `CDONE=1` y los LEDs son el diseño nuevo: la flash en el CS compartido era el problema → ir a 4.2/4.3.
5. Si `CDONE=0` igual: mirar timing CRESET / pull-up / que SCK MOSI sean los pines de **configuración**, no GPIO de usuario.

### 5.4 Cómo se vería el slave con ADBUS3 separado (opción B o C)

```text
1. ADBUS3 = 0, ADBUS4 = 1, CRESET = 0     // FPGA reset, flash no seleccionada
2. wait
3. CRESET high-Z, ADBUS3 sigue 0          // flanco: slave ON
4. shift 135100 B por MOSI
5. dummy clocks
6. CDONE = 1
7. ADBUS3 high-Z
```

La flash no vio el bitstream. La CRAM sí.

---

## 6. Resumen en una frase

Azukar **ya** ata FTDI CS, flash `/CS` y `SPI_SS_B`. Por eso el boot desde flash funciona y el slave pelea con la NOR en el mismo CS. Cablear ADBUS3 al SS **sin separar** ese net no hace nada. Separarlo **sí** habilita SRAM fiable, y entonces hay que decidir cómo (o si) la FPGA sigue pudiendo elegir la flash en master.

Referencias: datasheet iCE40 (capítulo de configuración SPI master/slave), W25X40CL, FTDI FT2232H ADBUS, `iceprog.c` `set_cs_creset`, `frontend/src/fpga/iceprogPins.ts`.
