# IoT Labs — ESP32-C6, Zephyr y OpenThread

Este repositorio concentra las tareas, firmware y evidencias de las prácticas.

**[Informe unificado de laboratorios — DDR](INFORME_LABORATORIOS.md)**: HTTP, MQTT
y Labs 1–5, siguiendo las diez secciones de la plantilla del curso.

**[DDR individual de cada práctica](DDR/README.md)** ·
**[Resumen general copiado de IoT-Labs-DHR](Resumen_General/README.md)**
([fuente y diferencias](Resumen_General/ORIGEN.md)).

Estado documentado por práctica:

| Laboratorio | Contenido | Estado documentado |
|---|---|---|
| [`lab_http/`](lab_http/README.md) | HTTP, telemetría y control de LED | GET/POST y LED validados; dashboard con telemetría y salvedad de actuación UI |
| [`lab_mqtt/`](lab_mqtt/README.md) | MQTT, broker, telemetría y control de LED | Telemetría y control desde dashboard validados |
| [`lab1/`](lab1/README.md) | Radio 802.15.4, OpenThread, RSSI y PER | Escaneo y mediciones a 1/5/10/15 m documentados |
| [`lab2/`](lab2/README.md) | Thread con dos placas A/B, direccionamiento, RTT y reconexión | Adaptación preparada; pruebas de dos saltos y rutas alternativas requieren una tercera placa |
| [`lab3/`](lab3/README.md) | CoAP/CBOR con C/S, Observe, válvula y sleepy end device | Finalizado; firmware, pruebas C/S, evidencias e informe disponibles |
| [`lab4/`](lab4/README.md) | DS18B20, CoAP con frescura, fallas y Trustworthiness | Finalizado por decisión del usuario; firmware, evidencias e informe con limitaciones documentadas |
| [`lab5/`](lab5/README.md) | Border Router S3 N16R8 + C6 RCP, nodos C/S y acceso PC/teléfono | Finalizado por el equipo; CoAP, NAT64, dashboard móvil y continuidad documentados |

Cada carpeta contiene su guía, firmware, herramientas y un registro de evidencia. El entorno común se documenta en [`evidencias/entorno.md`](evidencias/entorno.md).

## Repositorio en WSL

```bash
git clone https://github.com/sillHD/IoT.git
cd IoT
```

Activa el entorno Zephyr antes de compilar:

```bash
source ~/zephyrproject/.venv/bin/activate
```

No guardes contraseñas Wi-Fi, claves Thread ni tokens en Git. Pasa los valores secretos localmente durante la compilación.
