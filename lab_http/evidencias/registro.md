# Evidencia — Lab 0 HTTP

**Estado:** Build, flasheo, Wi-Fi, GET y POST con LED encendido confirmados; dashboard y prueba de apagado pendientes
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
| Recompilación y flasheo | Credenciales Wi-Fi ingresadas localmente; `west flash -d build-iot-lab-http --esp-device /dev/ttyACM0` | Éxito; 715,536 bytes escritos, hash verificado y reset solicitado. Aviso: herramienta configurada para 8 MB, chip detectado de 4 MB | [`archivos/flash-2026-10-01.log`](archivos/flash-2026-10-01.log) |
| Arranque y Wi-Fi | `west espressif monitor -p /dev/ttyACM0` | Lab HTTP arrancó, se asoció al AP, obtuvo `192.168.1.9` y escucha HTTP en puerto 80 | [`archivos/runtime-2026-10-01.log`](archivos/runtime-2026-10-01.log) |
| Consulta de telemetría | `curl -i --max-time 5 http://192.168.1.9/api/sensor` | `HTTP/1.1 200`, JSON `{"temperature": 29.8}`; serial confirma la solicitud | [`archivos/http-get-2026-10-01.txt`](archivos/http-get-2026-10-01.txt) |
| Comando de control | `curl -i --max-time 5 -X POST http://192.168.1.9/api/control -H 'Content-Type: application/json' -d '{"state": 1}'` | `HTTP/1.1 200`; la consola serial confirma `LED state: 1` y la fotografía muestra el LED encendido | [`archivos/http-post-led-2026-10-02.txt`](archivos/http-post-led-2026-10-02.txt), [captura de consola serial](../Imagenes/Imagen%201.png), [captura de solicitudes HTTP](../Imagenes/Imagen%202.png), [foto de la placa](../Imagenes/Imagen%203.jpeg) |
| Comando para apagar el LED | `curl -i --max-time 5 -X POST http://192.168.1.9/api/control -H 'Content-Type: application/json' -d '{"state": 0}'` | `HTTP/1.1 200`, `{"status": "ok"}`; consola serial confirma `LED state: 0` | [`archivos/http-post-led-off-2026-10-02.txt`](archivos/http-post-led-off-2026-10-02.txt) |
| Consola serial previa al flasheo HTTP | `west espressif monitor -p /dev/ttyACM0` | Puerto abierto; se observa firmware previo `SoilSense Control` | [`archivos/serial-before-lab-http-flash-2026-10-01.log`](archivos/serial-before-lab-http-flash-2026-10-01.log) |
| Flasheo y conexión Wi-Fi | | | |
| Dashboard HTTP | | | |
| Recepción de telemetría | | | |
| Comando de LED desde dashboard | Pendiente; el POST se envió con `curl` | El LED se encendió con el comando directo; no se ha validado el dashboard | [`archivos/http-post-led-2026-10-02.txt`](archivos/http-post-led-2026-10-02.txt) |

## Resultados

- Dirección IP del ESP32: `192.168.1.9` (DHCP).
- SSID: registrado en la terminal del usuario; se omite del repo.
- Resultado del build: Zephyr 4.4.99; SDK 1.0.1; compilador RISC-V GCC 14.3.0.
- Memoria reportada: Flash 668,324 B (7.97%); SRAM 239,472 B (47.01%).
- Primer build: valores de ejemplo `changeme`; luego se recompiló usando credenciales ingresadas localmente. No se registran SSID ni contraseña.
- Aviso no bloqueante: Ccache 4.9.1 instalado, versión 4.12 o superior recomendada por el build.
- La consola del ESP32 está en `/dev/ttyACM0` en esta placa; `/dev/ttyUSB0` no existe en la sesión.
- La placa reporta 4 MB de flash física. El `.config` lista `CONFIG_ESPTOOLPY_FLASHSIZE="2MB"`, pero `west flash` informa que intenta configurar la imagen para 8 MB. La escritura actual de 715,536 bytes terminó y pasó la verificación hash; revisar/alinear el parámetro antes de siguientes flasheos.
- Ruta/método HTTP observado: `GET /api/sensor`.
- Payload de telemetría observado: `{"temperature": 29.8}` (valor simulado).
- Respuesta del dispositivo: `HTTP/1.1 200` con `Content-Type: application/json`.
- Resultado del control del LED: la consola serial confirma los estados `1` y `0`; el estado `1` también aparece encendido en la fotografía.
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
| [`flash-2026-10-01.log`](archivos/flash-2026-10-01.log) | Flasheo verificado con aviso de tamaño de flash | 2026-10-01 |
| [`runtime-2026-10-01.log`](archivos/runtime-2026-10-01.log) | Arranque, conexión Wi-Fi, dirección DHCP y servidor HTTP activo | 2026-10-01 |
| [`http-get-2026-10-01.txt`](archivos/http-get-2026-10-01.txt) | GET exitoso y confirmación serial | 2026-10-01 |
| [`http-post-led-2026-10-02.txt`](archivos/http-post-led-2026-10-02.txt) | POST HTTP exitoso, confirmación serial del estado 1 y observación de LED encendido | 2026-10-02 |
| [`http-post-led-off-2026-10-02.txt`](archivos/http-post-led-off-2026-10-02.txt) | Respuesta HTTP 200 al solicitar el estado 0 | 2026-10-02 |

Las capturas originales están guardadas en [`Imagenes/`](../Imagenes/).

## Implementación preparada

- `prj.conf`: habilitados Wi-Fi, servidor HTTP, parser JSON y LED strip.
- `src/main.c`: implementadas lectura simulada, actuación del WS2812 y manejo de `POST /api/control`.
- Validación de compilación: exitosa en WSL2 con Zephyr 4.4.99.
