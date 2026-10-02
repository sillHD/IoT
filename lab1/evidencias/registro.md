# Evidencia — Lab 1 Radio

**Estado:** Firmware listo, escaneo completado y red Thread formada (A leader, B router); falta ping y mediciones de alcance/RSSI/PER
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

## Compilación

- Comando: `west build -p always -b esp32c6_devkitc/esp32c6/hpcore -d build-iot-lab1 ~/IoT/lab1/firmware`
- Resultado: compilación exitosa (866 pasos).
- Evidencia: [`archivos/build-2026-10-02.txt`](archivos/build-2026-10-02.txt).
- Placa A (`/dev/ttyACM0`) y placa B (`/dev/ttyACM1`) arrancaron con el CLI y la radio IEEE 802.15.4 inicializada: [`archivos/boot-dual-boards-2026-10-02.txt`](archivos/boot-dual-boards-2026-10-02.txt).

## Escaneo de canales

### Resultado de la medición

| Canal 802.15.4 | RSSI/energía (dBm) | Observaciones |
|---:|---:|---|
| 11 | -102 | |
| 12 | -101 | |
| 13 | -102 | |
| 14 | -102 | |
| 15 | -103 | |
| 16 | -103 | |
| 17 | -99 | |
| 18 | -96 | |
| 19 | -103 | |
| 20 | -101 | |
| 21 | -104 | Empate de menor energía |
| 22 | -103 | |
| 23 | -103 | |
| 24 | -104 | Empate de menor energía; solapa Wi-Fi 11 |
| 25 | -104 | Empate de menor energía; canal seleccionado, espacio entre Wi-Fi |
| 26 | -96 | |

- Canal seleccionado y motivo: canal 25; comparte el menor nivel observado (-104 dBm) con 21 y 24, pero 25 queda fuera de los canales Wi-Fi solapados indicados en la guía.
- Comando y duración: `ot ifconfig up`; `ot scan energy 500` (500 ms por canal).
- Evidencia completa: [`archivos/channel-scan-2026-10-02.txt`](archivos/channel-scan-2026-10-02.txt).

## Medición de alcance

### Alcance de esta sesión

Con el equipo actual, se medirán distancias hasta 5 m. Los puntos de 10 m en adelante quedan pendientes hasta contar con otro PC que mantenga acceso serial a la placa B; por tanto, no se concluirá el alcance máximo confiable hasta completar esas mediciones.

### Red formada

- Canal: 25.
- Potencia TX configurada: 0 dBm en ambas placas.
- Placa A (`/dev/ttyACM0`): `leader`, RLOC `fd49:3d9e:654d:a680:0:ff:fe00:5c00`.
- Placa B (`/dev/ttyACM1`): `router`, RLOC `fd49:3d9e:654d:a680:0:ff:fe00:c00`.
- Evidencia: [`archivos/thread-network-2026-10-02.txt`](archivos/thread-network-2026-10-02.txt). El dataset y su clave no se guardan.

Mantener constantes canal, potencia TX, tamaño de paquete y configuración de ping. No ejecutar pings simultáneos salvo que se documente como experimento de contención.

| Distancia (m) | RSSI recibido A (dBm) | RSSI recibido B (dBm) | Ping A→B recibidos/total | PER A→B (%) | Ping B→A recibidos/total | PER B→A (%) | Entorno |
|---:|---:|---:|---:|---:|---:|---:|---|
| ≈1 | -66 | -67 | 100/100 | 0.0 | 100/100 | 0.0 | Distancia objetivo de referencia; entorno no especificado |

- Tamaño y cantidad de pings: payload de 64 bytes, 100 por dirección.
- Intervalo: 0.2 s; pings A→B y B→A se hicieron secuencialmente.
- Evidencia de la referencia bidireccional a ≈1 m: [`archivos/ping-1m-2026-10-02.txt`](archivos/ping-1m-2026-10-02.txt).
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
| [`channel-scan-2026-10-02.txt`](archivos/channel-scan-2026-10-02.txt) | Escaneo de energía de los canales 11–26 y selección del canal 25 | 2026-10-02 |
| [`thread-network-2026-10-02.txt`](archivos/thread-network-2026-10-02.txt) | Red Thread formada con A como líder y B como router | 2026-10-02 |
| [`ping-1m-2026-10-02.txt`](archivos/ping-1m-2026-10-02.txt) | Referencia A↔B a ≈1 m: 0% PER y RSSI promedio de −66/−67 dBm | 2026-10-02 |
