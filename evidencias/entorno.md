# Evidencia — entorno WSL2, Zephyr y ESP32-C6

**Estado:** Zephyr detectado y USB adjunto a WSL; falta compilar/flashear Hello World y validar consola
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
- [ ] Dependencias Python e integración de Zephyr (`west packages pip --install`, `west zephyr-export`).
- [ ] HAL Espressif descargado y toolchain RISC-V instalado.
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
| Hello World | | |

## Problemas y soluciones

| Fecha | Síntoma/error | Solución aplicada |
|---|---|---|

> No guardar contraseñas Wi-Fi, claves, tokens ni otros secretos en este registro.
