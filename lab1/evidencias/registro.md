# Evidencia — Lab 1 Radio

**Estado:** Firmware listo, escaneo completado y red Thread formada; mediciones de alcance/RSSI/PER registradas hasta 15 m
**Guía:** [`en/labs/lab1.md`](../guia.md)
**SOP opcional:** [`en/labs/sops/sop01_advanced_mac.md`](../sops/sop01_advanced_mac.md)
**Firmware:** [`firmware/`](../firmware/)

## Datos de la sesión

- Fecha y zona horaria:
- Integrantes:
- Placas y antenas:
- Equipo anfitrión / puerto serial:
- Ubicación y condiciones del entorno:
- Potencia TX configurada: 20 dBm en ambas placas para la serie de 5–15 m (confirmado por el usuario); 0 dBm en la referencia inicial de ≈1 m.
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

Se registraron resultados a 1, 5, 10 y 15 m. La prueba se detuvo en 15 m al observar pérdida casi total de paquetes; no se incluyen mediciones para distancias mayores.

### Red formada

- Canal: 25.
- Potencia TX en la serie repetida: 20 dBm en ambas placas; el usuario confirmó que `ot txpower` mostró ese valor.
- Las placas se unieron a la misma red Thread; las RLOC se consultaron antes de cada prueba y no se conservan aquí porque pueden cambiar al volver a unirse.
- La evidencia de la red inicial (0 dBm) está en [`archivos/thread-network-2026-10-02.txt`](archivos/thread-network-2026-10-02.txt). El dataset y su clave no se guardan.

Mantener constantes canal, potencia TX, tamaño de paquete y configuración de ping. No ejecutar pings simultáneos salvo que se documente como experimento de contención.

| Distancia (m) | RSSI A→B (dBm) | RSSI B→A (dBm) | PER A→B (%) | PER B→A (%) | Link Quality (LQ In: A→B / B→A) | Estado del enlace |
|---:|---:|---:|---:|---:|---:|---|
| 1 (medido) | -66 | -67 | 0.0 | 0.0 | 3 | Enlace perfecto |
| 5 | -78 | -80 | 1.0 | 0.0 | 3 / 2 | Límite confiable (PER ≤ 1 %) |
| 10 | -91 | -91 | 0.0 | 3.0 | 1 / 1 | Degradación leve |
| 15 | -80 | -86 | 98.0 | 96.0 | 2 / 2 | Pérdida crítica |

- Tamaño y cantidad de pings: payload de 64 bytes, 100 por dirección.
- Intervalo: 0.2 s; pings A→B y B→A se hicieron secuencialmente.
- Evidencia de la referencia bidireccional a ≈1 m: [`archivos/ping-1m-2026-10-02.txt`](archivos/ping-1m-2026-10-02.txt).
- La referencia a ≈1 m pertenece a la sesión inicial (0 dBm); los puntos repetidos de 5–15 m se midieron con TX a 20 dBm. Son sesiones distintas y sus resultados no forman una única serie con potencia constante.
- Datos de 10 y 15 m suministrados por el usuario; TX a 20 dBm, confirmado por el usuario.
- Medición actualizada a 10 m: A→B 100/100 (0.0 % PER), B→A 97/100 (3.0 % PER). RSSI promedio recibido: -91 dBm en B para A→B y -91 dBm en A para B→A. Último RSSI: -90 dBm en B y -94 dBm en A; LQ In: 1 en ambas placas.
- Medición actualizada a 15 m: A→B 2/100 (98.0 % PER), B→A 4/100 (96.0 % PER). RSSI promedio recibido: -80 dBm en B para A→B y -86 dBm en A para B→A. Último RSSI: -60 dBm en B y -71 dBm en A; LQ In: 2 en ambas placas.
- Medición repetida a 5 m: A→B 99/100 (1.0 % PER), B→A 100/100 (0.0 % PER). RSSI promedio recibido: -78 dBm en B para A→B y -80 dBm en A para B→A. Último RSSI: -80 dBm en B y -82 dBm en A; LQ In: 3 en B y 2 en A.

## Análisis y decisiones

- **ADR-001 — Selección de canal:** se eligió el canal 25 porque el escaneo registró -104 dBm, empatado con los canales 21 y 24, y el 25 queda en un espacio entre los canales Wi-Fi solapados indicados en la guía. Ver [`channel-scan-2026-10-02.txt`](archivos/channel-scan-2026-10-02.txt).
- **Condición de medición:** durante las pruebas la línea de visión no estuvo completamente despejada; esto explica la variación anormal observada en RSSI y PER.
- **Mapeo ISO/IEC 30141 (PED/SCD):** el ESP32-C6 con radio 802.15.4/OpenThread es un dispositivo de sensado y control (SCD); el aire y la propagación electromagnética entre nodos representan el dominio de entidad física (PED).

## Archivos

Guardar capturas, logs y tablas originales en [`archivos/`](archivos/). Describirlos aquí:

| Archivo | Qué demuestra | Fecha |
|---|---|---|
| [`build-2026-10-02.txt`](archivos/build-2026-10-02.txt) | Compilación de OpenThread CLI para ESP32-C6 | 2026-10-02 |
| [`boot-dual-boards-2026-10-02.txt`](archivos/boot-dual-boards-2026-10-02.txt) | Arranque del firmware y radio 802.15.4 inicializada en ambas placas | 2026-10-02 |
| [`channel-scan-2026-10-02.txt`](archivos/channel-scan-2026-10-02.txt) | Escaneo de energía de los canales 11–26 y selección del canal 25 | 2026-10-02 |
| [`thread-network-2026-10-02.txt`](archivos/thread-network-2026-10-02.txt) | Red Thread formada con A como líder y B como router | 2026-10-02 |
| [`ping-1m-2026-10-02.txt`](archivos/ping-1m-2026-10-02.txt) | Referencia A↔B a ≈1 m: 0% PER y RSSI promedio de −66/−67 dBm | 2026-10-02 |
| [`Prueba 1.jpeg`](../Imagen/Prueba%201.jpeg) | Resultado a 15 m en B→A: 96 % PER; tabla de vecinos de B | 2026-10-13 |
| [`Prueba 2.jpeg`](../Imagen/Prueba%202.jpeg) | Resultado A→B a 10 m: 0 % PER; tabla de vecinos de A | 2026-10-13 |
| [`Prueba 3.jpeg`](../Imagen/Prueba%203.jpeg) | Resultado A→B a 15 m: 98 % PER; tabla de vecinos de A | 2026-10-13 |
| [`Prueba 4.jpeg`](../Imagen/Prueba%204.jpeg) | Resultado A→B a 5 m: 1 % PER; tabla de vecinos de A | 2026-10-13 |
