# Evidencia — Lab 0 MQTT

**Estado:** Broker accesible, firmware compilado y flasheado; ESP32 conectado y suscrito/publicando; falta validar recepción en dashboard y comandos MQTT
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
| Prueba local pub/sub | | | |
| Compilación | `west build -p always -b esp32c6_devkitc/esp32c6/hpcore -d build-iot-lab-mqtt ~/IoT/lab_mqtt/firmware` | Build exitoso, 634 pasos; imagen ESP32-C6 generada | [`archivos/build-2026-10-02.txt`](archivos/build-2026-10-02.txt) |
| Flasheo | `west flash -d build-iot-lab-mqtt --esp-device /dev/ttyACM0` | 695,872 bytes escritos, hash verificado y reset completado. Aviso: chip de 4 MB frente a imagen configurada para 8 MB | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) |
| Conexión del ESP32 al broker | Wi-Fi y MQTT a `192.168.1.4:1883` | IPv4 del nodo `192.168.1.9`; conexión MQTT y suscripción `iot/control` confirmadas en serial | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) |
| Telemetría en `iot/sensor` | Publicación periódica cada 2 s | El firmware registra publicaciones con payload JSON; falta confirmar recepción desde un suscriptor | [`archivos/flash-runtime-2026-10-02.txt`](archivos/flash-runtime-2026-10-02.txt) |
| Comando en `iot/control` y LED | | | |
| Dashboard MQTT | | | |

## Resultados

- Cliente ESP32 conectado: sí/no; observación:
- Telemetría observada (payload sin datos sensibles):
- Comando y QoS usado:
- Resultado físico del LED:
- Reconexión/pruebas de desconexión realizadas:
- Errores o ajustes necesarios:

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
