# Lab 1 — caracterización de radio

**[DDR de esta práctica](DDR.md)** · [Índice de DDR](../DDR/README.md)

Guía detallada: [`guia.md`](guia.md) · SOP opcional: [`sops/sop01_advanced_mac.md`](sops/sop01_advanced_mac.md) · Firmware: [`firmware/`](firmware/) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Actividades y evidencia

- [x] Compilar el OpenThread CLI para ESP32-C6.
- [x] Flashear y confirmar el arranque del OpenThread CLI en ambas placas.
- [x] Escanear los canales 802.15.4; canal 25 seleccionado con energía de -104 dBm.
- [x] Formar la red Thread; placa A leader y placa B router.
- [x] Confirmar conectividad y medir PER por ping en ambas direcciones a ~1 m (0%).
- [x] Medir RSSI y PER en ambas direcciones a 1, 5, 10 y 15 m; la prueba se detuvo a 15 m por pérdida casi total.
- [x] Registrar las mediciones de alcance y la condición observada durante la prueba.
- [x] Guardar la evidencia de compilación en `evidencias/archivos/`.
- [x] Completar el análisis y ADR-001 en `evidencias/registro.md`, con limitaciones registradas.

La medición requiere dos placas. Mantén constantes canal, potencia TX y tamaño de paquete; no ejecutes los pings de ambas direcciones simultáneamente durante la medición base.

Durante las mediciones la línea de visión no estuvo completamente despejada; esto explica la variación anormal de los resultados.
