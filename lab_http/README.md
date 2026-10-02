# Lab HTTP — IoT mínimo con Zephyr

Guía detallada: [`guia.md`](guia.md) · Firmware: [`firmware/`](firmware/) · Dashboard: [`tools/dashboard_http.py`](tools/dashboard_http.py) · Evidencias: [`evidencias/registro.md`](evidencias/registro.md)

## Tareas

- [x] Activar Wi-Fi, HTTP server, JSON y LED strip en `firmware/prj.conf`.
- [x] Implementar control del LED WS2812 en `firmware/src/main.c`.
- [x] Implementar `GET /api/sensor` con temperatura simulada.
- [x] Implementar `POST /api/control` para controlar el LED.
- [x] Compilar con valores de ejemplo de Kconfig (validación inicial; no flashear este build).
- [x] Recompilar con credenciales locales y flashear la imagen.
- [x] Confirmar arranque, asociación Wi-Fi y servidor HTTP escuchando en puerto 80.
- [x] Consultar telemetría desde `curl` (HTTP 200 y JSON válido).
- [x] Confirmar el encendido del LED por `POST /api/control` desde `curl`.
- [ ] Validar apagado del LED y dashboard HTTP.
- [x] Guardar logs disponibles y completar el registro en `evidencias/`.
- [x] Archivar las capturas originales en `Imagenes/` y enlazarlas desde el registro.

## Compilación

Con el entorno Zephyr activo, compila desde la raíz del workspace Zephyr. El primer build usa las credenciales de ejemplo de Kconfig y solo sirve para validar la compilación:

```bash
cd ~/zephyrproject
west build -p always -b esp32c6_devkitc/esp32c6/hpcore \
  -d build-iot-lab-http ~/IoT/lab_http/firmware
```

Antes de flashear, recompila pasando tus credenciales localmente con `-DCONFIG_LAB_WIFI_SSID='"..."' -DCONFIG_LAB_WIFI_PSK='"..."'`. No las compartas ni las registres. Sigue la sección de integración de `guia.md` para el monitor serial y las pruebas.
