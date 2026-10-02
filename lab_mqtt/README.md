# Lab MQTT — telemetría publish/subscribe

Guía detallada: [`guia.md`](guia.md) · Firmware: [`firmware/`](firmware/) · Dashboard: [`tools/dashboard_mqtt.py`](tools/dashboard_mqtt.py) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Tareas de desarrollo

- [ ] Activar los subsistemas MQTT/Wi-Fi/JSON/LED indicados por la guía en `firmware/prj.conf`.
- [ ] Declarar dirección y puerto del broker en `firmware/Kconfig`.
- [ ] Implementar control WS2812 y suscripción al tópico de comandos en `firmware/src/main.c`.
- [ ] Implementar publicación de telemetría en el tópico del sensor.
- [ ] Configurar y verificar Mosquitto; compilar y flashear el ESP32-C6.
- [ ] Verificar dashboard, tópicos y actuación del LED.
- [ ] Registrar resultados, logs y capturas en `evidencias/`.

Empieza después de completar Lab HTTP. No registres contraseñas, claves ni tokens en el repo.
