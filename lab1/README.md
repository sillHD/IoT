# Lab 1 — caracterización de radio

Guía detallada: [`guia.md`](guia.md) · SOP opcional: [`sops/sop01_advanced_mac.md`](sops/sop01_advanced_mac.md) · Firmware: [`firmware/`](firmware/) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Actividades y evidencia

- [x] Compilar el OpenThread CLI para ESP32-C6.
- [ ] Flashear el firmware en ambas placas.
- [ ] Escanear los canales 802.15.4 y registrar el nivel de energía.
- [ ] Formar la red con ambas placas y confirmar conectividad por ping.
- [ ] Medir RSSI y PER en ambas direcciones a distancias crecientes.
- [ ] Estimar alcance confiable, canal preferido y separación recomendada.
- [x] Guardar la evidencia de compilación en `evidencias/archivos/`.
- [ ] Completar el análisis y ADR-001 en `evidencias/registro.md`.

La medición requiere dos placas. Mantén constantes canal, potencia TX y tamaño de paquete; no ejecutes los pings de ambas direcciones simultáneamente durante la medición base.
