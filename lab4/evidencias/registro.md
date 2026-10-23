# Registro — Lab 4, DS18B20

**Estado:** ejecución iniciada; DS18B20 reconocido y lectura reciente confirmada en S.
Disponibles según el usuario: DS18B20, protoboards y termómetro.
Firmware C/S y guía preparados; ejecución física de S confirmada por stats.
Logs posteriores confirman ejecución de Lab 4 en C/S y roles iniciales C child,
S leader; ajuste a C leader y prueba CoAP pendientes.

## Sesión y montaje

Fecha/integrantes/lugar: por registrar para este laboratorio.
C/S: ESP32-C6, consola prevista UART/CH343. Sensor S: DS18B20, GPIO18,
alimentación 3V3, 12 bits configurados. Longitud de cable, pull-up, puertos,
versión compilada, distancia y obstáculos: por confirmar con el montaje real.
Referencia: termómetro disponible; modelo, exactitud y resolución no informados.

## Primera lectura real en S

[Evidencia original de stats](archivos/01-stats-inicial-S.txt).

| Dato | Resultado |
|---|---|
| Sensor identificado | ds18b20 |
| Última lectura aceptada | 24.00 °C, edad 1 s |
| Contadores | 9 lecturas en 18 s, 0 fallidas (0.0 %), 0 rechazadas |
| Duración de adquisición min/promedio/máximo | 760665 / 762805 / 779901 µs |

La muestra confirma lectura real y funcionamiento inicial. No sustituye los
ensayos de ruido de 60 s ni reposo/tráfico de 120 s. El usuario confirmó montaje
conectado; no se aportó foto para verificar visualmente las conexiones.

## Incidencia posterior: sensor no detectado

Un nuevo bloque, sin identificar C/S, muestra `No 1-Wire slaves connected` desde
arranque, error -19 y Sensor lost a los tres intentos. [Fragmento recibido](archivos/incidencia-1wire-placa-no-identificada.txt).
La lectura inicial correcta de S se mantiene como evidencia de su sesión.
Pendiente identificar si este bloque es C con imagen de sensor o S con pérdida
de conexión; no se asigna causa ni se cuenta como ensayo controlado de desconexión.

## Red: roles iniciales

[Logs C/S](archivos/02-red-roles-iniciales-C-S.txt): C pasa de detached a child
(a 00:00:24.684 de su reloj); S pasa de detached a leader (00:02:26.902 de su
reloj). Estos roles son válidos en Thread; para seguir la guía se propone detener
Thread en ambas y arrancar primero C hasta leader, luego S. No se ha confirmado
aún el resultado de ese ajuste ni la comunicación CoAP. No se restan timestamps
entre placas ni se da por resuelta la incidencia anterior de sensor sin verificar.

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
- [x] Montaje conectado según el usuario; DS18B20 reconocido y lectura real confirmada en S.
- [ ] Ruido, referencia, respuesta e inyecciones documentados.
- [ ] Sensor perdido y nodo inaccesible cronometrados.
- [ ] Reposo/tráfico, recuperación y reset documentados.
- [ ] Comparación de clase e informe completados.
- [ ] Cierre físico de la sesión confirmado.
