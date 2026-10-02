# Evidencia — Lab 0 MQTT

**Estado:** Lab MQTT completado: ESP32 conectado al broker, dashboard recibe telemetría y sus comandos controlan el LED
**Guía:** [`en/0_3_Minimal_IoT_Implementation_mqtt.md`](../guia.md)
**Firmware:** [`firmware/`](../firmware/)

## Datos de la sesión

- Fecha y zona horaria:
- Integrantes:
- Placa/revisión:
- Equipo anfitrión y sistema operativo:
- Broker y dirección (sin credenciales):
- Red Wi-Fi de prueba (nombre público o identificador; nunca contraseña):
- Commit del repositorio (`git rev-parse --short HEAD`):

## Procedimiento realizado

| Paso | Comando/configuración | Resultado observado | Evidencia |
|---|---|---|---|
| Mosquitto instalado/configurado | `mosquitto.exe -c "C:\Program Files\Mosquitto\mosquitto.conf" -v` | Mosquitto 2.1.2 queda ejecutándose; `netstat` confirma `0.0.0.0:1883` y `[::]:1883`. Se inició manualmente; la ventana debe permanecer abierta y el servicio permanente está pendiente | [`archivos/mosquitto-listener-2026-10-02.txt`](archivos/mosquitto-listener-2026-10-02.txt) |
| Conectividad desde WSL | `socket.create_connection(('192.168.1.4', 1883), timeout=4)` | Conexión TCP al broker confirmada | [`archivos/wsl-broker-connect-2026-10-02.txt`](archivos/wsl-broker-connect-2026-10-02.txt) |
| Flujo pub/sub ESP32→broker→dashboard | El ESP32 publica `iot/sensor`; dashboard suscrito al tópico | Telemetría visible en el gráfico con estado de recepción activa | [captura serial](../Imagenes/Imagen%201.png), [video del dashboard](../Imagenes/Video%201.mp4) |
| Compilación | `west build -p always -b esp32c6_devkitc/esp32c6/hpcore -d build-iot-lab-mqtt ~/IoT/lab_mqtt/firmware` | Build exitoso, 634 pasos; imagen ESP32-C6 generada | [`archivos/build-2026-10-02.txt`](archivos/build-2026-10-02.txt) |
| Flasheo | `west flash -d build-iot-lab-mqtt --esp-device /dev/ttyACM0` | 695,872 bytes escritos, hash verificado y reset completado. Aviso: chip de 4 MB frente a imagen configurada para 8 MB | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) |
| Conexión del ESP32 al broker | Wi-Fi y MQTT a `192.168.1.4:1883` | IPv4 del nodo `192.168.1.9`; conexión MQTT y suscripción `iot/control` confirmadas en serial | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) |
| Telemetría en `iot/sensor` | Publicación periódica cada 2 s | El ESP32 registra publicaciones JSON y el dashboard muestra el gráfico en vivo con estado “Receiving MQTT messages. Live data stream active.” | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt), [captura serial](../Imagenes/Imagen%201.png), [video del dashboard](../Imagenes/Video%201.mp4) |
| Comando en `iot/control` y LED | Botones Turn ON / Turn OFF del dashboard; QoS 1 | El monitor serial confirma múltiples comandos con estados 1 y 0 | [`archivos/dashboard-led-control-2026-10-02.txt`](archivos/dashboard-led-control-2026-10-02.txt) |
| Dashboard MQTT | `python lab_mqtt/tools/dashboard_mqtt.py` desde `.venv-dashboard` | Conectado a `192.168.1.4:1883`, suscrito a `iot/sensor` y recepción de telemetría visible en la página | [`archivos/dashboard-startup-2026-10-02.txt`](archivos/dashboard-startup-2026-10-02.txt), [video del dashboard](../Imagenes/Video%201.mp4) |

## Resultados

- Cliente ESP32 conectado: sí; conexión MQTT confirmada al broker `192.168.1.4:1883`.
- Telemetría observada: payload JSON `{"temperature": 22.9}` y otras muestras entre 20.0 y 29.9 °C; gráfico de dashboard activo.
- Comando y QoS usado: dashboard publica en `iot/control` con QoS 1; el ESP32 recibió estados 1 y 0.
- Resultado del control LED: comandos de encendido y apagado confirmados en la consola serial.
- Reconexión/pruebas de desconexión realizadas: no probadas.
- Errores o ajustes necesarios: advertencia no bloqueante de tamaño de flash configurado a 8 MB frente a 4 MB físicos; revisar antes de futuros flasheos.

## Comparación con HTTP

- Diferencias observadas en quién inicia la comunicación:
- Papel del broker:
- Facilidad de añadir consumidores:
- Latencia/comportamiento observado (indicar método de medición):
- Mapeo ISO/IEC 30141 (SCD, ASD y función del broker):

## Archivos

Guardar capturas, logs y otros artefactos en [`archivos/`](archivos/). Describirlos aquí:

| Archivo | Qué demuestra | Fecha |
|---|---|---|
| [`mosquitto-listener-2026-10-02.txt`](archivos/mosquitto-listener-2026-10-02.txt) | Broker Mosquitto escuchando en interfaces IPv4 e IPv6 | 2026-10-02 |
| [`wsl-broker-connect-2026-10-02.txt`](archivos/wsl-broker-connect-2026-10-02.txt) | Conectividad TCP desde WSL al broker Windows | 2026-10-02 |
| [`build-2026-10-02.txt`](archivos/build-2026-10-02.txt) | Compilación del firmware MQTT para ESP32-C6 y uso de memoria | 2026-10-02 |
| [`flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) | Flasheo verificado, conexión al broker y publicaciones registradas | 2026-10-02 |
| [`dashboard-startup-2026-10-02.txt`](archivos/dashboard-startup-2026-10-02.txt) | Dashboard MQTT conectado al broker y suscrito al tópico de telemetría | 2026-10-02 |
| [`dashboard-led-control-2026-10-02.txt`](archivos/dashboard-led-control-2026-10-02.txt) | Confirmación serial de comandos MQTT de encendido y apagado | 2026-10-02 |
| [`../Imagenes/Imagen 1.png`](../Imagenes/Imagen%201.png) | Consola serial con publicaciones periódicas en `iot/sensor` | 2026-10-02 |
| [`../Imagenes/Video 1.mp4`](../Imagenes/Video%201.mp4) | Dashboard MQTT con telemetría en vivo | 2026-10-02 |
