# Evidencia — Lab 1 Radio

**Estado:** Firmware compilado y OpenThread CLI arrancado en ambas placas; falta escaneo de canales y mediciones de red/radio
**Guía:** [`en/labs/lab1.md`](../guia.md)
**SOP opcional:** [`en/labs/sops/sop01_advanced_mac.md`](../sops/sop01_advanced_mac.md)
**Firmware:** [`firmware/`](../firmware/)

## Datos de la sesión

- Fecha y zona horaria:
- Integrantes:
- Placas y antenas:
- Equipo anfitrión / puerto serial:
- Ubicación y condiciones del entorno:
- Potencia TX configurada en cada placa (dBm):
- Commit del repositorio (`git rev-parse --short HEAD`):

## Escaneo de canales

### Compilación

- Comando: `west build -p always -b esp32c6_devkitc/esp32c6/hpcore -d build-iot-lab1 ~/IoT/lab1/firmware`
- Resultado: compilación exitosa (866 pasos).
- Evidencia: [`archivos/build-2026-10-02.txt`](archivos/build-2026-10-02.txt).
- Placa A (`/dev/ttyACM0`) y placa B (`/dev/ttyACM1`) arrancaron con el CLI y la radio IEEE 802.15.4 inicializada: [`archivos/boot-dual-boards-2026-10-02.txt`](archivos/boot-dual-boards-2026-10-02.txt).

| Canal 802.15.4 | RSSI/energía reportada (dBm) | Observaciones/interferencia |
|---:|---:|---|

- Canal seleccionado y motivo:
- Canales Wi-Fi cercanos conocidos:
- Comando y duración del escaneo:

## Medición de alcance

Mantener constantes canal, potencia TX, tamaño de paquete y configuración de ping. No ejecutar pings simultáneos salvo que se documente como experimento de contención.

| Distancia (m) | RSSI recibido A (dBm) | RSSI recibido B (dBm) | Ping A→B recibidos/total | PER A→B (%) | Ping B→A recibidos/total | PER B→A (%) | Entorno |
|---:|---:|---:|---:|---:|---:|---:|---|

- Tamaño y cantidad de pings:
- Intervalo:
- Umbral RSSI asociado con PER < 1% (si los datos lo permiten):
- Máximo alcance confiable observado:
- Separación recomendada y margen aplicado:

## Análisis y decisiones

- ADR-001: canal elegido y evidencia:
- Explicación de pérdida de señal con distancia:
- Ruido, fading y margen de enlace:
- Mapeo ISO/IEC 30141 (PED/SCD):
- Recomendación para operaciones:

## Archivos

Guardar capturas, logs y tablas originales en [`archivos/`](archivos/). Describirlos aquí:

| Archivo | Qué demuestra | Fecha |
|---|---|---|
| [`build-2026-10-02.txt`](archivos/build-2026-10-02.txt) | Compilación de OpenThread CLI para ESP32-C6 | 2026-10-02 |
| [`boot-dual-boards-2026-10-02.txt`](archivos/boot-dual-boards-2026-10-02.txt) | Arranque del firmware y radio 802.15.4 inicializada en ambas placas | 2026-10-02 |
