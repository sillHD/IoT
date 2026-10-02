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

Con el entorno Zephyr activo, compila desde la raíz del workspace Zephyr. El primer build usa las credenciales de ejemplo de Kconfig y solo sirve para validar la compilación:

```bash
cd ~/zephyrproject
west build -p always -b esp32c6_devkitc/esp32c6/hpcore \
  -d build-iot-lab-http ~/IoT/lab_http/firmware
```

Antes de flashear, recompila pasando tus credenciales localmente con `-DCONFIG_LAB_WIFI_SSID='"..."' -DCONFIG_LAB_WIFI_PSK='"..."'`. No las compartas ni las registres. Sigue la sección de integración de `guia.md` para el monitor serial y las pruebas.
