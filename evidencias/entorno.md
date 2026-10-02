# Evidencia — entorno WSL2, Zephyr y ESP32-C6

**Estado:** Zephyr y toolchain operativos; Lab HTTP compiló. Falta flashear y validar la consola.
**Propósito:** Registrar el entorno compartido por `lab_http`, `lab_mqtt` y `lab1`.

## Plataforma

- Windows versión/build:
- Distribución WSL2:
- Repositorio objetivo: `https://github.com/sillHD/IoT`
- Fecha:
- Modelo/revisión de la placa:
- Puerto USB de la placa (UART suele aparecer como `/dev/ttyUSB0`):

## Lista de preparación

- [ ] WSL2 disponible y distribución Linux abre correctamente.
- [ ] Paquetes de compilación instalados según [`SETUP.md`](../SETUP.md).
- [x] Entorno virtual creado en `~/zephyrproject/.venv` con `west`.
- [x] Workspace inicializado; `west list zephyr` reconoce el proyecto.
- [x] Dependencias Python e integración de Zephyr (confirmado por build exitoso).
- [x] HAL Espressif y toolchain RISC-V disponibles (confirmado por build exitoso).
- [x] Placa conectada a WSL2 por `usbipd` y dispositivo serial visible.
- [ ] Hello World compilado, flasheado y observado por consola.

## Versiones y verificaciones

| Elemento | Versión/resultado | Evidencia (log/captura) |
|---|---|---|
| `west --version` | v1.5.0 | Salida compartida en el chat |
| WSL2 / distribución | | |
| Zephyr (`west list zephyr`) | | |
| SDK / toolchain | | |
| Puerto serial | `/dev/ttyACM0` visible | Salida compartida en el chat |
| Lab HTTP | Imagen ESP32-C6 generada exitosamente | [`../lab_http/evidencias/archivos/build-2026-10-01.log`](../lab_http/evidencias/archivos/build-2026-10-01.log) |

## Problemas y soluciones

| Fecha | Síntoma/error | Solución aplicada |
|---|---|---|

> No guardar contraseñas Wi-Fi, claves, tokens ni otros secretos en este registro.
