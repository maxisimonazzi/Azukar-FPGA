# Hojas de datos

Una hoja de datos por componente o serie de la placa Azukar. Las referencias salen de la lista de materiales del esquemático.

| Archivo | Componente | Referencias |
|---|---|---|
| `ICE40HX4K-TQ144.pdf` | FPGA Lattice iCE40HX4K-TQ144 | U6 |
| `FT2232HL.pdf` | Puente USB FTDI FT2232HL | U4 |
| `M93C66-WMN6P.pdf` | EEPROM ST M93C66 | U5 |
| `W25X40CLSNIG.pdf` | Memoria flash Winbond W25X40CL | U7 |
| `TLV761.pdf` | Reguladores TI TLV76133 (3,3 V) y TLV76112 (1,2 V) | U1, U2 |
| `USBLC6-2SC6.pdf` | Protección ESD ST USBLC6-2SC6 | U3 |
| `MMBZ5231BLT3G.PDF` | Diodo Zener onsemi de 5,1 V | Z1 |
| `SD1206S040S1R0.pdf` | Diodo Schottky Kyocera AVX | D2 |
| `GSB1C41110SSHR.pdf` | Conector USB-C Amphenol | J1 |
| `ECS-3225MV-120-CN-TR.pdf` | Oscilador ECS de 12 MHz | Y1 |
| `ECS-3225MVQ-1000-CN-TR.pdf` | Oscilador ECS de 100 MHz | Y2 |
| `742792141.pdf` | Ferrita Würth Elektronik | FB1–FB5 |
| `150141RS73100.pdf` | LED rojo Würth Elektronik | D1, D3 |
| `150141GS73100.pdf` | LED verde Würth Elektronik | D4–D11 |
| `TS04-66-75-BK-100-SMT.pdf` | Pulsador Same Sky | SW1–SW8 |
| `CL31B103KHFNFNE.pdf` | Capacitor Samsung de 10 nF | C1, C25, C27 |
| `CL31B104KBCNFNC.pdf` | Capacitor Samsung de 100 nF | C2, C5, C8, C10, C13–C19, C21, C22, C24, C29–C33, C35, C36, C38, C39, C41, C42, C44, C45 |
| `CL31B105KAHNFNE.pdf` | Capacitor Samsung de 1 µF | C26, C28, C34, C37, C40, C43 |
| `CL31B335KOHNNNE.pdf` | Capacitor Samsung de 3,3 µF | C12 |
| `CL31B475KAHNNNE.pdf` | Capacitor Samsung de 4,7 µF | C9, C11 |
| `CL31B106KAHNNNE.pdf` | Capacitor Samsung de 10 µF | C3, C4, C6, C7, C20, C23, C46–C53 |
| `Yageo_AC_series.pdf` | Resistencias Yageo serie AC: AC1206FR-075K1L (5,1 kΩ), AC1206FR-0712KL (12 kΩ), AC1206FR-0710KL (10 kΩ), AC1206FR-07100RL (100 Ω) | R1, R2, R10, R12, R13, R14, R16, R17–R20, R41–R48 |
| `Yageo_RC_L_series.pdf` | Resistencias Yageo serie RC_L: RC1206FR-101KL (1 kΩ), RC1206FR-07120RL (120 Ω), RC1206FR-13220RL (220 Ω), RC1206FR-072K2L (2,2 kΩ) | R3, R4, R5–R9, R11, R15, R21–R40 |

Los conectores P1–P4 (tira hembra 2×10 de 2,54 mm), los fiduciales y TP1 no tienen hoja de datos.

## Carpetas

- `old/`: reguladores que ya no se usan en la placa (LD1117, LM1117, MIC5355/6).
- `incoming/`: conectores USB-C candidatos a reemplazar al actual (JAE DX07B024ZJ1 y DX07B048ZJ1).
