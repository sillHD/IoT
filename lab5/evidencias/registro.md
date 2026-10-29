# Registro — Lab 5 Border Router

**Estado:** preparación lista; ejecución física y mediciones pendientes.
S3 **N16R8 confirmada** por el usuario. Se necesitan S/C más una tercera C6 RCP;
la disponibilidad y asignación física de esta última aún no quedaron documentadas.
No se usan cifras del curso como resultados experimentales.

## Sesión

- Integrantes, fecha y lugar: por registrar para Lab 5.
- BR: ESP32-S3 N16R8, 8 MB PSRAM octal; puerto UART y detección real en boot pendientes.
- RCP: tercera ESP32-C6; modelo/puerto/cableado pendientes.
- S: ESP32-C6 + DS18B20 GPIO18, 3V3; nueva compilación con SLAAC.
- C: ESP32-C6 sin sensor; nueva compilación con SLAAC.
- Workspace previsto: ~/zephyrproject-lab5; Zephyr fijado a 2f0bc11264a8e72e214f3db0a3fa221eb022453a.
- Canal previsto: 25 o asignación del docente; potencia de firmware C6: 20 dBm. Lecturas reales pendientes.
- PC: Windows/WSL anterior; conectividad IPv6 de host por comprobar.
- Distancia, obstáculos, tamaño de pings y condiciones: por registrar.
- Dataset y credenciales solo locales, excluidos de Git.

## Carga y montaje

| Placa | Imagen | Evidencia build/flash | Arranque/verificación |
|---|---|---|---|
| S | nodes + ds18b20, UART | pendiente | stats real pendiente |
| C | nodes sin sensor, UART | pendiente | CLI pendiente |
| RCP | rcp, Spinel UART1 | pendiente | ot rcp version desde BR pendiente |
| BR | border_router, N16R8 UART | pendiente | PSRAM detectada y versiones pendientes |

## Predicciones previas y mediciones

| Magnitud | Predicción antes de probar | Resultado | Objetivo del curso |
|---|---|---|---|
| RTT C→S, dentro de Thread | por completar | no medido | baseline propio |
| PC→BR IPv4, power save inicial | por completar | no medido | comparar |
| PC→BR IPv4, power save off | por completar | no medido | comparar |
| PC→S IPv6 ping | por completar | no medido | registrar |
| PC→S GET CoAP, 10 | por completar | no medido | mediana <200 ms |
| Latencia añadida, RTT PC→S menos PC→BR | por completar | no calculado | <100 ms; indicador entre recorridos distintos |
| NAT64, S→8.8.8.8 | por completar | no medido | RTT <200 ms |
| BR apagado: PUT interno C→S | por completar | no probado | funciona |

Promedio para ping y mediana para CoAP, muestras de diez según la guía. La
comparación debe documentar tamaños/condiciones y no restar RTT incompatibles
sin explicar los límites. No se sustituyen con datos de Labs 3/4.

## Direcciones y límites de red

Prefijo OMR, NAT64 /96, IPv4/link-local Wi-Fi BR, ML-EID/OMR de S y C: pendientes.
Ruta RIO en el PC o ruta manual documentada: pendiente.
Un prefijo ULA OMR puede ser válido; no se declara global público por estar en
la lista de direcciones. OTBR es gateway de comunicación SCD; no activa por sí
solo autenticación/autorización de RAID.

## Dashboard, fallo y retorno

Teléfono con dashboard, OPEN/CLOSE y GET final: pendientes.
Fallo de BR: instante, rol C/S, acceso interno y externo: pendientes.
Retorno BR con mismo dataset, prefijos/rutas y nueva respuesta GET: pendiente.
Persistencia: este BR usa ajustes RAM; no afirmar autostart tras corte.

## Seguimiento

- [x] Analizar guía/SOP actual y fijar versiones.
- [x] Confirmar modelo S3 N16R8.
- [x] Preparar imágenes, scripts, guía y herramientas PC.
- [ ] Confirmar tercera C6, cableado y puertos reales.
- [ ] Preparar SDK y compilar/cargar cuatro imágenes en WSL.
- [ ] Verificar PSRAM, Spinel y radio desde BR.
- [ ] Configurar y verificar Wi-Fi/Thread/BR/NAT64 y direcciones OMR.
- [ ] Registrar rutas y mediciones PC/malla.
- [ ] Validar dashboard en teléfono y actuación/cierre.
- [ ] Probar NAT64, falla y restauración BR.
- [ ] Actualizar DDR con datos propios, sin sobrescribir ADR existentes.
- [ ] Confirmar cierre de la sesión.
