# Registro — Lab 4, DS18B20

**Estado:** preparación; no se han recibido mediciones del Lab 4.
Disponibles según el usuario: DS18B20, protoboards y termómetro.
Firmware C/S y guía preparados; compilación/carga física pendientes.

## Sesión y montaje

Fecha/integrantes/lugar: por registrar para este laboratorio.
C/S: ESP32-C6, consola prevista UART/CH343. Sensor S: DS18B20, GPIO18,
alimentación 3V3, 12 bits configurados. Longitud de cable, pull-up, puertos,
versión compilada, distancia y obstáculos: por confirmar con el montaje real.
Referencia: termómetro disponible; modelo, exactitud y resolución no informados.

## Contrato previsto

`GET /env/temp`, GET+Observe, CBOR {t:float16}, Content-Format 60.
Exactitud declarada del DS18B20 ±0.5 °C entre −10 y 85 °C según fabricante;
el filtro local solo admite −40 ≤ T < 85 y salto ≤5 °C contra lectura menor de
10 s de edad. Lecturas cada 2 s, último valor aceptado conservado ante falla.
Frescura de 60 s desde la lectura; Max-Age disminuye. Sin dato fresco: 5.03,
Max-Age 10 y texto `no fresh reading`; notificación final de error termina Observe.
No se afirma validación experimental de este contrato hasta recibir logs.

## Tabla de clase — nuestra fila, pendiente

| Sensor | Resolución observada | Ruido 60 s | Offset | Subida / mitad de subida | Notificaciones | Tiempo lectura | Fallas reposo / tráfico | Recuperación |
|---|---|---|---|---|---|---|---|---|
| DS18B20 | pendiente | pendiente | pendiente | pendiente | pendiente | pendiente | pendiente | pendiente |

Paso nominal a 12 bits: 0.0625 °C, distinto de paso observado y exactitud.
La tabla compartida de clase aún no se ha recibido.

## Disponibilidad y recuperación

| Condición | Evidencia en C | Evidencia en S | Tiempo |
|---|---|---|---|
| Sensor desconectado | pendiente | pendiente | pendiente |
| Sensor reconectado | pendiente | pendiente | pendiente |
| Nodo fuera de red | pendiente | pendiente | pendiente |
| Reinicio de S | pendiente | pendiente | pendiente |

## Auditoría Trustworthiness — DDR §9

| Característica | Evidencia por obtener | Estado |
|---|---|---|
| Integridad ante fallas | referencia, ruido, inyecciones, edad y filtros | pendiente |
| Disponibilidad | GET fresco, vencimiento 5.03, timeout con nodo ausente | pendiente |
| Fiabilidad | failed/reads en reposo y bajo tráfico; meta <5 % ocupado | pendiente |
| Resiliencia | reconexión sensor, unión y recuperación tras reset | pendiente |
| Seguridad operativa | diseño ante 5.03/silencio con plazo y estado por defecto | por documentar |
| Confidencialidad e integridad frente a atacantes | controles de seguridad | → Lab 6 |
| Cumplimiento | contratos y trazabilidad; sin afirmar certificación | por documentar |

DDR §4: PED magnitud física, SCD sensor/filtros, ASD servicio/frescura.
DDR §5: respuestas; §6: detección sensor ≤60 s y fallas ocupadas <5 %,
contrastadas con resultados reales; §7 seguridad; §8 fila Trustworthiness,
Labs Addressed = Lab 4; §9 auditoría con evidencia y brechas.
Resumen para Edwin: se redactará al medir ambos modos de falla.

## Progreso

- [x] Analizar guía y SOP del curso; fijar origen y adaptaciones.
- [x] Preparar firmware DS18B20 S y cliente C, herramientas y guía.
- [ ] Cableado y lectura real verificados.
- [ ] Ruido, referencia, respuesta e inyecciones documentados.
- [ ] Sensor perdido y nodo inaccesible cronometrados.
- [ ] Reposo/tráfico, recuperación y reset documentados.
- [ ] Comparación de clase e informe completados.
- [ ] Cierre físico de la sesión confirmado.
