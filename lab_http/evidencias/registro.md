# Evidencia — Lab 0 HTTP

**Estado:** Firmware implementado; compilación, flasheo y pruebas pendientes
**Guía:** [`en/0_2_Minimal_IoT_Implementation_http.md`](../guia.md)
**Firmware:** [`firmware/`](../firmware/)

## Datos de la sesión

- Fecha y zona horaria:
- Integrantes:
- Placa/revisión:
- Equipo anfitrión y sistema operativo:
- Red Wi-Fi de prueba (nombre público o identificador; nunca contraseña):
- Commit del repositorio (`git rev-parse --short HEAD`):

## Procedimiento realizado

| Paso | Comando/configuración | Resultado observado | Evidencia |
|---|---|---|---|
| Dependencias y configuración | | | |
| Compilación | | | |
| Flasheo y conexión Wi-Fi | | | |
| Dashboard HTTP | | | |
| Recepción de telemetría | | | |
| Comando de LED desde dashboard | | | |

## Resultados

- Dirección IP del ESP32 (si aplica):
- Ruta/método HTTP observado:
- Payload de telemetría observado (sin datos sensibles):
- Respuesta del dispositivo:
- Resultado físico del LED:
- Errores o ajustes necesarios:

## Conclusión y arquitectura

- ¿Qué función cumple el ESP32 y cuál el dashboard?
- ¿Cómo se cierra el ciclo de sensado y actuación?
- Mapeo ISO/IEC 30141 (SCD/ASD):
- Decisiones o cambios al firmware:

## Archivos

Guardar capturas, logs y otros artefactos en [`archivos/`](archivos/). Describirlos aquí:

| Archivo | Qué demuestra | Fecha |
|---|---|---|

## Implementación preparada

- `prj.conf`: habilitados Wi-Fi, servidor HTTP, parser JSON y LED strip.
- `src/main.c`: implementadas lectura simulada, actuación del WS2812 y manejo de `POST /api/control`.
- Validación de compilación: pendiente en un entorno Zephyr.
