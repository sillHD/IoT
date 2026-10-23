# Registro — Lab 4, DS18B20

**Estado:** ejecución iniciada; DS18B20 reconocido y lectura reciente confirmada en S.
Disponibles según el usuario: DS18B20, protoboards y termómetro.
Firmware C/S y guía preparados; ejecución física de S confirmada por stats.
Logs posteriores confirman ejecución de Lab 4 en C/S y roles iniciales C child,
S leader; ajuste posterior a C leader y S child confirmado. Primer GET CoAP real validado en C/S.

## Sesión y montaje

Fecha/integrantes/lugar: por registrar para este laboratorio.
C/S: ESP32-C6, consola prevista UART/CH343. Sensor S: DS18B20, GPIO18,
alimentación 3V3, 12 bits configurados. Longitud de cable, pull-up, puertos,
versión compilada, distancia y obstáculos: por confirmar con el montaje real.
Referencia disponible: termómetro de cocina de pincho; modelo, exactitud y
resolución no informados. Su idoneidad como referencia no está establecida.

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

## Red ajustada y sensor operativo

[Consolas recibidas](archivos/02-red-C-leader-S-child-y-stats.txt): C confirma
leader y S child. S reporta ML-EID `fd2c:525a:8ff2:2258:a81c:f3d:1e07:2a8b`.
La asignación actual se toma de estas salidas; no se reutilizan etiquetas de
placa/direcciones del Lab 3.

Stats S: 23.94 °C, edad 1 s; 251 lecturas en 501 s, 0 fallidas y 0 rechazadas;
tiempo de adquisición min/promedio/máximo 760660/760764/779901 µs.
Estos contadores acumulados no sustituyen los ensayos controlados de 120 s.
El bloque actual confirma sensor operativo en S; no permite identificar cuál
placa originó la incidencia 1-Wire anterior. GET posterior validado; faltan canal/potencia actuales.

## Primer GET CoAP con sensor real

[Evidencia C/S](archivos/03-GET-inicial-C-S.txt). C solicitó GET CON a la ML-EID
actual de S; la respuesta coincide con el log S: 2.05, 23.94 °C, edad 1 s y
Max-Age 59. El payload `a16174f94dfc` decodifica {t:23.9375 °C} (float16).
El prefijo visual `uart` antes del hex no pertenece a CBOR.

S pasó a router a 00:08:38.173; el GET se atendió a 00:09:39.113 de su reloj.
El origen del GET identifica la ML-EID de C como
`fd2c:525a:8ff2:2258:9966:43d2:59a9:c435`.
Esta muestra verifica frescura en operación normal; no prueba aún el vencimiento
tras desconectar DATA. No contiene un cronometraje del RTT.

## Contrato previsto

`GET /env/temp`, GET+Observe, CBOR {t:float16}, Content-Format 60.
Exactitud declarada del DS18B20 ±0.5 °C entre −10 y 85 °C según fabricante;
el filtro local solo admite −40 ≤ T < 85 y salto ≤5 °C contra lectura menor de
10 s de edad. Lecturas cada 2 s, último valor aceptado conservado ante falla.
Frescura de 60 s desde la lectura; Max-Age disminuye. Sin dato fresco: 5.03,
Max-Age 10 y texto `no fresh reading`; notificación final de error termina Observe.
No se afirma validación experimental de este contrato hasta recibir logs.

## Referencia y offset: discrepancia sin resolver

[Observaciones comunicadas](archivos/referencia-termometro-cocina-observaciones.txt):
termómetro de cocina ≈32 °C frente a DS18B20 ≈24 °C en la comparación inicial;
en otra comprobación el refrigerador indicaba 3 °C y el termómetro de cocina 10 °C.
La diferencia de +7 °C corresponde únicamente a esa observación del refrigerador.
No se conocen igualdad térmica, estabilización, ubicación del sensor interno ni
si el indicador mostraba consigna o temperatura medida. No se atribuye el error
a ninguno de los instrumentos ni se interpreta la discrepancia como calibración.

**No se aplica corrección.** Offset del DS18B20 pendiente de referencia confiable.
Por decisión del usuario se conservan los datos y se continúa con el ruido y los
restantes ensayos. No se realizó aún el minuto controlado de ruido.

## Tabla de clase — nuestra fila, pendiente

| Sensor | Resolución observada | Ruido 60 s | Offset | Subida / mitad de subida | Notificaciones | Tiempo lectura | Fallas reposo / tráfico | Recuperación |
|---|---|---|---|---|---|---|---|---|
| DS18B20 | pendiente | pendiente | pendiente: referencia no validada | pendiente | pendiente | pendiente | pendiente | pendiente |

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
