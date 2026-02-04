# Contributing to AZUKAR

[English](#english) | [Español](#español)

---

# English

Thank you for your interest in contributing to AZUKAR.

This project follows open hardware and open collaboration principles. Contributions from students, educators, engineers and makers are welcome.

---

## Ways to Contribute

You can contribute by:

- Improving schematics or PCB layout
- Adding FPGA example designs
- Writing documentation or tutorials
- Testing hardware revisions
- Reporting bugs or issues
- Improving educational material

---

## Hardware Contributions

If you modify hardware files:

- Keep designs compatible with KiCad 9
- Use clear net naming and labeling
- Avoid vendor-locked components when possible
- Document design decisions in commit messages
- Update revision notes if layout changes affect compatibility

---

## Firmware / FPGA Code

When contributing HDL or examples:

- Use readable signal names
- Comment complex logic blocks
- Avoid hard-coded magic numbers
- Prefer parameterized modules
- Provide test benches when possible

---

## Commit Guidelines

Recommended format:

Example:
feat(fpga): add pwm example project
fix(pcb): correct usb connector footprint
fix(schematic): correct component name
docs(readme): improve toolchain section

---

## Pull Requests

Before submitting:

- Test your changes if applicable
- Ensure files open correctly in KiCad
- Verify synthesis builds if HDL is modified
- Update documentation if behavior changes

---

## Licensing

By contributing, you agree that your work will be released under the same open-source license as this repository.

---

Thank you for helping improve AZUKAR.

---

# Español

Gracias por tu interés en contribuir a AZUKAR.

Este proyecto sigue principios de hardware abierto y colaboración abierta. Se agradecen contribuciones de estudiantes, docentes, ingenieros y makers.

---

## Formas de contribuir

Podés contribuir mediante:

- Mejorar los esquemáticos o el ruteo del PCB
- Agregar diseños de ejemplo para FPGA
- Escribir documentación o tutoriales
- Probar revisiones de hardware
- Reportar bugs o issues
- Mejorar material educativo

---

## Contribuciones de hardware

Si modificás archivos de hardware:

- Mantener los diseños compatibles con KiCad 9
- Usar nombres de redes (nets) y etiquetas claros
- Evitar componentes “vendor-locked” cuando sea posible
- Documentar decisiones de diseño en los mensajes de commit
- Actualizar notas de revisión si los cambios de layout afectan la compatibilidad

---

## Firmware / Código FPGA

Al contribuir HDL o ejemplos:

- Usar nombres de señales legibles
- Comentar bloques de lógica complejos
- Evitar “magic numbers” hardcodeados
- Preferir módulos parametrizados
- Incluir testbenches cuando sea posible

---

## Guía de commits

Formato recomendado:

Ejemplos:
feat(fpga): add pwm example project  
fix(pcb): correct usb connector footprint  
fix(schematic): correct component name  
docs(readme): improve toolchain section  

---

## Pull Requests

Antes de enviar:

- Probar tus cambios si aplica
- Asegurarte de que los archivos abran correctamente en KiCad
- Verificar que la síntesis compile si se modifica HDL
- Actualizar la documentación si cambia el comportamiento

---

## Licencia

Al contribuir, aceptás que tu trabajo se publicará bajo la misma licencia open-source que este repositorio.

---

Gracias por ayudar a mejorar AZUKAR.

