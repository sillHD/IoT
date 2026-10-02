# Lab HTTP — IoT mínimo con Zephyr

Guía detallada: [`guia.md`](guia.md) · Firmware: [`firmware/`](firmware/) · Dashboard: [`tools/dashboard_http.py`](tools/dashboard_http.py) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Tareas

- [x] Activar Wi-Fi, HTTP server, JSON y LED strip en `firmware/prj.conf`.
- [x] Implementar control del LED WS2812 en `firmware/src/main.c`.
- [x] Implementar `GET /api/sensor` con temperatura simulada.
- [x] Implementar `POST /api/control` para controlar el LED.
- [ ] Compilar, flashear y comprobar la telemetría desde `curl`.
- [ ] Validar encendido/apagado del LED y dashboard HTTP.
- [ ] Guardar logs y capturas en `evidencias/archivos/` y completar el registro.

## Compilación

Desde la raíz de este repo, con el entorno Zephyr activo:

```bash
cd lab_http/firmware
west build -p always -b esp32c6_devkitc/esp32c6/hpcore . \
  -- -DCONFIG_LAB_WIFI_SSID='"TU_SSID"' -DCONFIG_LAB_WIFI_PSK='"TU_CLAVE"'
west flash
```

No compartas ni registres las credenciales. Sigue la sección de integración de `guia.md` para el monitor serial y las pruebas.
