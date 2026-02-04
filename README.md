# AZUKAR — Open FPGA Education Board

[English](#english) | [Español](#español)

---

![GitHub Repo stars](https://img.shields.io/github/stars/YOURUSER/AZUKAR?style=social)
![License](https://img.shields.io/github/license/YOURUSER/AZUKAR)
![Open Hardware](https://img.shields.io/badge/Open%20Hardware-OSHWA%20Compatible-success)
![KiCad](https://img.shields.io/badge/Designed%20with-KiCad%209-blue)
![FPGA](https://img.shields.io/badge/FPGA-Education-orange)
![Status](https://img.shields.io/badge/status-active%20development-yellow)

![Front Preview](images/board-front.png)
![Back Preview](images/board-back.png)

---

# English

## Overview

**AZUKAR** is an open-source FPGA development board designed for digital design education, laboratory training, and rapid prototyping.
It provides an accessible and reproducible hardware platform that enables students, makers, and engineers to explore HDL design, digital systems architecture, and FPGA-based applications using open toolchains.

The project follows open hardware principles and is optimized for academic environments, hands-on learning, and experimentation.

### Special Considerations

Assembly-first decisions were made to keep the board easy to build in a lab or at home: most parts use common, hand-solderable footprints (e.g., 1206, SOT-233-3, SOIC-8, 3528, SOT-23-6), and all components are placed on the TOP side of the PCB to simplify manual assembly and hot-plate reflow. The only parts that typically require extra precision or a different soldering technique are the FPGA (TQFP-144), the FTDI USB interface (LQFP-64), and the 3225 package crystals. As a trade-off, these assembly-friendly decisions make the routing denser and therefore increase via usage compared to a design that spreads parts across both PCB sides.

---

## Key Goals

- Facilitate FPGA learning and digital design education
- Support open-source FPGA toolchains
- Provide reproducible and transparent hardware design
- Enable laboratory use and academic training
- Encourage community contributions and experimentation

---

## Features

- FPGA-based digital logic platform
- Fully open hardware design files
- Designed with KiCad 9
- Compatible with open-source synthesis and programming tools
- Educational-oriented I/O and peripherals
- Modular and extensible architecture

---

## Repository Structure

/docs -> Documentation of the board, pinout, datasheets, etc

/images -> Images

/project -> Kicad project

---

## Toolchain Compatibility

AZUKAR is designed to work with open-source FPGA workflows, including:

- Yosys (synthesis)
- NextPNR / Place & Route tools
- Open FPGA programming tools
- Vendor-independent HDL flows

---

## Educational Use

This board is intended for:

- University courses
- Digital electronics laboratories
- FPGA introduction workshops
- Self-learning and experimentation
- Research prototypes

---

## Open Hardware

AZUKAR follows open hardware principles:

- Schematics and PCB files available
- Reproducible fabrication workflow
- Community-driven development

License details are available in the repository.

---

## Contributing

Contributions are welcome:

- Hardware improvements
- Documentation updates
- Example designs
- Testing and validation
- Educational material

Please open issues or pull requests.

---

## License

This project is released under an open-source hardware compatible license.  
See the LICENSE file for details.

---

# Español

## Descripción general

**AZUKAR** es una placa de desarrollo FPGA de código abierto diseñada para la educación en diseño digital, la capacitación de laboratorio y el prototipado rápido.
Proporciona una plataforma de hardware accesible y reproducible que permite a estudiantes, makers e ingenieros explorar el diseño en HDL, la arquitectura de sistemas digitales y aplicaciones basadas en FPGA usando toolchains abiertas.

El proyecto sigue principios de hardware abierto y está optimizado para entornos académicos, aprendizaje práctico y experimentación.

### Consideraciones especiales

Se tomaron decisiones orientadas al montaje para que la placa sea más fácil de construir en laboratorio o en casa: la mayoría de los componentes usan encapsulados comunes y soldables a mano (por ejemplo 1206, SOT-233-3, SOIC-8, 3528, SOT-23-6), y todos los componentes están ubicados en la cara TOP de la PCB para facilitar el armado manual y el soldado por reflow con cama caliente. Los únicos componentes que suelen requerir más precisión o una técnica de soldado diferente son la FPGA (TQFP-144), la interfaz FTDI del puerto USB (LQFP-64) y los cristales en encapsulado 3225. Como contrapartida, estas decisiones orientadas al ensamblado vuelven el ruteo más complejo y, por lo tanto, aumentan la cantidad de vías respecto de un diseño que distribuye componentes en ambas caras de la PCB.

---

## Objetivos principales

- Facilitar el aprendizaje de FPGA y la educación en diseño digital
- Soportar toolchains de FPGA de código abierto
- Proporcionar un diseño de hardware reproducible y transparente
- Habilitar el uso en laboratorio y la formación académica
- Fomentar las contribuciones de la comunidad y la experimentación

---

## Características

- Plataforma de lógica digital basada en FPGA
- Archivos de diseño de hardware totalmente abiertos
- Diseñada con KiCad 9
- Compatible con herramientas de síntesis y programación de código abierto
- E/S y periféricos orientados a educación
- Arquitectura modular y extensible

---

## Estructura del repositorio

/docs -> Documentación de la placa, pinout, hojas de datos, etc.

/images -> Imágenes

/project -> Proyecto de KiCad

---

## Compatibilidad con toolchains

AZUKAR está diseñada para funcionar con flujos de trabajo de FPGA de código abierto, incluyendo:

- Yosys (síntesis)
- NextPNR / herramientas de Place & Route
- Herramientas abiertas de programación de FPGA
- Flujos HDL independientes del proveedor

---

## Uso educativo

Esta placa está pensada para:

- Cursos universitarios
- Laboratorios de electrónica digital
- Talleres introductorios de FPGA
- Autoaprendizaje y experimentación
- Prototipos de investigación

---

## Hardware abierto

AZUKAR sigue principios de hardware abierto:

- Esquemáticos y archivos de PCB disponibles
- Flujo de fabricación reproducible
- Desarrollo impulsado por la comunidad

Los detalles de la licencia están disponibles en el repositorio.

---

## Contribuciones

Las contribuciones son bienvenidas:

- Mejoras de hardware
- Actualizaciones de documentación
- Diseños de ejemplo
- Pruebas y validación
- Material educativo

Por favor, abrir issues o pull requests.

---

## Licencia

Este proyecto se publica bajo una licencia compatible con hardware abierto y de código abierto.  
Ver el archivo LICENSE para más detalles.

---
