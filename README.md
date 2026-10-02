# IoT Labs — ESP32-C6, Zephyr y OpenThread

Este repositorio concentra las tareas, firmware y evidencias de tres prácticas:

| Laboratorio | Contenido | Estado inicial |
|---|---|---|
| [`lab_http/`](lab_http/README.md) | HTTP, telemetría y control de LED | Firmware implementado; falta compilar y validar con la placa |
| [`lab_mqtt/`](lab_mqtt/README.md) | MQTT, broker, telemetría y control de LED | Pendiente de desarrollo |
| [`lab1/`](lab1/README.md) | Radio 802.15.4, OpenThread, RSSI y PER | Firmware disponible; mediciones pendientes |

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
