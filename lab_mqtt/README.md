# Lab MQTT — telemetría publish/subscribe

Guía detallada: [`guia.md`](guia.md) · Firmware: [`firmware/`](firmware/) · Dashboard: [`tools/dashboard_mqtt.py`](tools/dashboard_mqtt.py) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Tareas de desarrollo

- [x] Activar los subsistemas MQTT/Wi-Fi/JSON/LED indicados por la guía en `firmware/prj.conf`.
- [x] Declarar dirección y puerto del broker en `firmware/Kconfig`.
- [x] Implementar control WS2812 y suscripción al tópico de comandos en `firmware/src/main.c`.
- [x] Implementar publicación de telemetría en el tópico del sensor.
- [x] Compilar el firmware MQTT para ESP32-C6.
- [x] Mantener Mosquitto accesible, compilar y flashear el ESP32-C6.
- [x] Confirmar telemetría MQTT de `iot/sensor` en el dashboard.
- [ ] Validar comando `iot/control` desde el dashboard y observar el cambio del LED.
- [x] Registrar configuración del broker, compilación, flasheo y pruebas de telemetría en `evidencias/`.

Empieza después de completar Lab HTTP. No registres contraseñas, claves ni tokens en el repo.
