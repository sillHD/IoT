# Evidencia — Lab 0 HTTP

**Estado:** Build inicial exitoso; consola serial confirmada; flasheo HTTP y pruebas funcionales pendientes
**Guía:** [`guia.md`](../guia.md)
**Firmware:** [`firmware/`](../firmware/)

## Datos de la sesión

- Fecha y zona horaria: 2026-10-01 (America/Bogota)
- Integrantes:
- Placa/revisión:
- Equipo anfitrión y sistema operativo:
- Red Wi-Fi de prueba (nombre público o identificador; nunca contraseña):
- Commit del repositorio al iniciar la prueba: `e1d2a74`

## Procedimiento realizado

| Paso | Comando/configuración | Resultado observado | Evidencia |
|---|---|---|---|
| Dependencias y configuración | | | |
| Compilación | `west build -p always -b esp32c6_devkitc/esp32c6/hpcore -d build-iot-lab-http ~/IoT/lab_http/firmware` desde `~/zephyrproject` | Éxito; se generó la imagen ESP32-C6 | [`archivos/build-2026-10-01.log`](archivos/build-2026-10-01.log) |
| Consola serial previa al flasheo HTTP | `west espressif monitor -p /dev/ttyACM0` | Puerto abierto; se observa firmware previo `SoilSense Control` | [`archivos/serial-before-lab-http-flash-2026-10-01.log`](archivos/serial-before-lab-http-flash-2026-10-01.log) |
| Flasheo y conexión Wi-Fi | | | |
| Dashboard HTTP | | | |
| Recepción de telemetría | | | |
| Comando de LED desde dashboard | | | |

## Resultados

- Dirección IP del ESP32 (si aplica):
- Resultado del build: Zephyr 4.4.99; SDK 1.0.1; compilador RISC-V GCC 14.3.0.
- Memoria reportada: Flash 668,324 B (7.97%); SRAM 239,472 B (47.01%).
- Configuración Wi-Fi: valores de ejemplo `changeme`; este build es solo para validar compilación, no para operar en la red.
- Aviso no bloqueante: Ccache 4.9.1 instalado, versión 4.12 o superior recomendada por el build.
- La consola del ESP32 está en `/dev/ttyACM0` en esta placa; `/dev/ttyUSB0` no existe en la sesión.
- El firmware previo informa flash física de 4 MB y una cabecera de imagen de 8 MB. El `.config` del build Lab HTTP usa cabecera `2MB`; la región linker `CONFIG_FLASH_SIZE=8192` es 8 MB y el binario generado ocupa 668 KB. La discrepancia del mensaje serial pertenece al firmware anterior; Lab HTTP aún no se ha flasheado.
- Ruta/método HTTP observado:
- Payload de telemetría observado (sin datos sensibles):
- Respuesta del dispositivo:
- Resultado físico del LED:
- Errores o ajustes necesarios:

## Conclusión y arquitectura

- ¿Qué función cumple el ESP32 y cuál el dashboard?
- ¿Cómo se cierra el ciclo de sensado y actuación?
- Mapeo ISO/IEC 30141 (SCD/ASD):
- Decisiones o cambios al firmware:

## Archivos

Guardar capturas, logs y otros artefactos en [`archivos/`](archivos/). Describirlos aquí:

| Archivo | Qué demuestra | Fecha |
|---|---|---|
| [`build-2026-10-01.log`](archivos/build-2026-10-01.log) | Compilación completa, toolchain y uso de memoria | 2026-10-01 |
| [`serial-before-lab-http-flash-2026-10-01.log`](archivos/serial-before-lab-http-flash-2026-10-01.log) | Consola serial y firmware que ya estaba en la placa antes de Lab HTTP | 2026-10-01 |
| [`flash-config-2026-10-01.txt`](archivos/flash-config-2026-10-01.txt) | Configuración de flash del build Lab HTTP | 2026-10-01 |

## Implementación preparada

- `prj.conf`: habilitados Wi-Fi, servidor HTTP, parser JSON y LED strip.
- `src/main.c`: implementadas lectura simulada, actuación del WS2812 y manejo de `POST /api/control`.
- Validación de compilación: exitosa en WSL2 con Zephyr 4.4.99.
