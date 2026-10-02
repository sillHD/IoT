# Evidencia — Lab 0 MQTT

**Estado:** Mosquitto escucha en todas las interfaces y WSL alcanza el puerto TCP; pub/sub MQTT y conexión del ESP32 pendientes
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
| Compilación y flasheo | | | |
| Conexión del ESP32 al broker | | | |
| Telemetría en `iot/sensor` | | | |
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
