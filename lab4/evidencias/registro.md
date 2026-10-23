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
restantes ensayos. El registro de ruido posterior está documentado a continuación.

## Ruido y paso observado — registro de aproximadamente un minuto

[Log original](archivos/04-ruido-S-log-original.txt), [muestras CSV](ruido-S-muestras.csv)
y [resumen calculado](ruido-S-resumen.json).

| Métrica | Resultado |
|---|---|
| Muestras impresas | 30, cada 2 s |
| Primera / última | 00:30:21.224 / 00:31:19.224 del reloj S |
| Separación entre primera y última | 58 s; 30 muestras a 2 s en un registro de aproximadamente un minuto |
| Mínimo / máximo | 21.50 / 21.62 °C |
| Ruido pico a pico | 0.12 °C |
| Promedio de valores impresos | 21.542 °C |
| Desviación estándar muestral de valores impresos | 0.0321 °C |
| Menor cambio no nulo impreso | 0.06 °C |
| Adquisición min/promedio/máximo | 760664 / 760692 / 760770 µs |
| Contadores de stats | 32 lecturas en 64 s; 0 fallidas (0.0 %), 0 rechazadas |

El paso impreso de 0.06 °C es compatible con el paso nominal de 0.0625 °C a
12 bits y el log a dos decimales; no demuestra esa exactitud. Los estadísticos
se calculan sobre los valores impresos, sin reconstruir decimales originales.
El comando reset previo no aparece en el fragmento, por lo que no se reconstruye
su instante. Stats abarca 32 lecturas y 64 s, frente a 30 muestras visibles;
no se inventan las dos muestras adicionales. La última línea aparece después
del comando log off, compatible con salida concurrente/diferida; se conserva.
No se aplica corrección de offset ni se supone calibrada la referencia.
Esta muestra no sustituye la prueba específica de 120 s en reposo/tráfico.

## Respuesta térmica y Observe — dos subidas observadas

[Log original S](archivos/05-estimulo-S-original.txt),
[consola C](archivos/05-estimulo-C-original.txt),
[77 muestras CSV](estimulo-S-muestras.csv),
[correspondencia Observe C/S](estimulo-observe-C-S.csv).

![Curva medida y notificaciones](../Imagen/estimulo-DS18B20.png)

Las 77 lecturas van de 00:34:41.224 a 00:37:13.224 de S, separadas por 2 s
(152 s entre primera y última). Observe se acepta a 00:34:46.542 con 21.69 °C
impresos (21.6875 °C codificados), edad 1 s y Max-Age 59.

| Resultado | Observación |
|---|---|
| Referencia inicial de la primera subida | 21.69 °C en el registro Observe; valores próximos durante la base previa |
| Primer pico | 22.81 °C a 00:35:17.224 |
| Subida respecto al registro inicial | ≈1.12 °C en valores impresos (1.125 °C entre valores float16 de registro/pico) |
| Media subida con esa referencia | 22.25 °C, primera muestra que la alcanza a 00:35:09.224; la anterior, a 00:35:07.224, es 22.00 °C |
| Tiempo desde inicio del soplido a media subida | No determinado: no se adjuntó marca de inicio/fin del estímulo |
| Recuperación y segunda subida | Tras el primer pico baja a 21.62 °C a 00:36:05.224; después vuelve a subir hasta 22.50 °C a 00:36:17.224 |
| Final de lecturas | 21.88 °C a 00:37:13.224; no se fuerza retorno exacto a la base inicial |
| Notificaciones completas posteriores al registro | 6 recibidas en C: 5 threshold/NON y 1 heartbeat/CON |

La base de 21.69 °C es una referencia de análisis explícita, no una medición
sincronizada con el inicio del soplido. El último mínimo antes de la primera
subida es 21.56 °C a 00:35:03.224, por lo que otros criterios de base cambiarían
la amplitud y el cruce de mitad. No se presenta un tiempo de respuesta físico
a partir de una marca de inicio inferida. El usuario confirmó posteriormente que hubo dos soplidos, sin indicar cuándo
comenzaron/terminaron. [Aclaración](archivos/05-estimulo-aclaracion-usuario.txt).
Se documentan dos soplidos y dos subidas observadas, sin atribuir tiempos
de inicio físicos inferidos de la curva.

| OBS C | Temperatura CBOR °C | Tiempo S | Tipo |
|---|---:|---|---|
| 2 | 21.6875 | 00:34:46.542 | Respuesta inicial al registro; no es notificación posterior |
| 3 | 22.2500 | 00:35:09.571 | NON, threshold 1 |
| 4 | 22.8125 | 00:35:17.580 | NON, threshold 2 |
| 5 | 22.1875 | 00:35:29.593 | NON, threshold 3 |
| 6 | 21.6250 | 00:36:05.630 | NON, threshold 4 |
| 7 | 22.3125 | 00:36:11.637 | NON, threshold 5 |
| 8 | 21.8750 | 00:36:56.683 | CON, heartbeat 1 |

El heartbeat sigue unos 45 s después de la última notificación por umbral.
Cada una de estas seis notificaciones registra 19 B CoAP en S: 114 B en total,
excluidos registro, ACK, retransmisiones y capas inferiores. Son bytes de
aplicación, no una captura de paquetes RF. No hay saltos en OBS=3..8.
El último renglón de S, a 00:37:41.729, es un heartbeat truncado y no tiene
respuesta correspondiente en el bloque C; se conserva, pero no se suma a las
seis notificaciones completas y emparejadas. No se aportó cancelación Observe.

## Plausibilidad — salto rechazado y dato plausible aceptado

[Log original S](archivos/06-inject-S-original.txt).

| Acción | Resultado registrado |
|---|---|
| inject 90 | Rejected a 00:48:19.240 por estar fuera de rango; [evidencia posterior](archivos/06-inject90-S-original.txt) |
| inject 31.5 | Rejected a 00:45:25.984: salto +9.6 °C frente a lectura reciente de 21.94 °C |
| inject 23 | Aceptado a 00:45:34.536 como `inject: 23.00 C` |
| Observe tras inyección | S registra NON con 23.00 °C a 00:45:35.213, threshold 6 |
| Nueva lectura física | 21.88 °C a 00:45:35.225, 689 ms después de la inyección |
| Observe tras lectura real | S registra NON con 21.88 °C a 00:45:36.215, threshold 7 |
| Stats final | 469 lecturas en 938 s; 0 fallidas, 2 rechazadas; última buena 21.88 °C, edad 1 s |
| Adquisición min/promedio/máximo | 760272 / 760686 / 761385 µs |

El filtro de salto funcionó en la muestra. Un valor artificial plausible pasó
los controles y llegó a la notificación del servidor; no hay bloque C de esta
secuencia para confirmar su recepción. No es una lectura física de 23 °C.
La plausibilidad no demuestra veracidad: una referencia independiente o
redundancia puede detectar discrepancias; autenticación protege procedencia,
pero no vuelve exacto un sensor defectuoso. Seguridad frente a atacantes se
aborda en Lab 6.

El primer fragmento muestra dos rechazos acumulados, pero identifica uno
(31.5); no se asigna causa al rechazo previo no visible. Un bloque posterior
confirma `Rejected 90.00 C from inject: outside -40..85 C` a 00:48:19.240 y
stats de 540 lecturas en 1080 s, 0 fallidas y 3 rechazadas, con última buena
21.94 °C de edad 0 s. Adquisición min/promedio/máximo: 760272/760685/761385 µs.
Se conserva el orden recibido: el mensaje aparece después de stats y no tiene
instante de ejecución del comando para reconstruir exactamente esa secuencia.
Las tres acciones exigidas quedan documentadas: rango rechazado, salto rechazado
y valor plausible aceptado. Los contadores no son el ensayo controlado de
fallas de 120 s; las inyecciones se analizan por separado.

## Tabla de clase — nuestra fila, parcial

| Sensor | Resolución observada | Ruido 60 s | Offset | Subida / mitad de subida | Notificaciones | Tiempo lectura | Fallas reposo / tráfico | Recuperación |
|---|---|---|---|---|---|---|---|---|
| DS18B20 | 0.06 °C impreso (nominal 0.0625 °C) | 0.12 °C pico a pico; 30 muestras visibles | pendiente: referencia no validada | ≈1.12 °C primer pico; tiempo desde soplido pendiente | 6 (5 NON + 1 CON), dos subidas observadas | 760664/760692/760770 µs min/avg/max | pendiente | pendiente |

Paso nominal a 12 bits: 0.0625 °C, distinto de paso observado y exactitud.
La tabla compartida de clase aún no se ha recibido.

## Sensor perdido: disponibilidad, caducidad y recuperación visibles en video

[Video, transcripción normalizada y método](archivos/07-desconexion-DATA-video-transcripcion.md),
[CSV de eventos](desconexion-DATA-tiempos.csv). Video original conservado junto
con capturas; no hay marca inequívoca del instante físico de retiro de DATA.

En el episodio principal S lee por última vez 22.00 °C a 00:55:09.224.
Primer error a 00:55:10.465 y tercer fallo/Sensor lost a 00:55:14.465:
4.000 s entre primer y tercer fallo (5.241 s desde la última lectura).

| GET en S | Edad impresa | Max-Age | Código / valor |
|---|---:|---:|---|
| 00:55:25.607 | 16 s | 44 s | 2.05 / 22.00 °C |
| 00:55:40.580 | 31 s | 29 s | 2.05 / 22.00 °C |
| 00:55:55.815 | 46 s | 14 s | 2.05 / 22.00 °C |
| 00:56:10.801 | sin dato fresco | 10 s, reintento | 5.03 / no fresh reading |

El trabajo policy anuncia caducidad a 00:56:09.860, 60.636 s desde la última
lectura; el GET 5.03 documentado llega a 61.577 s desde esa lectura. El nodo
permanece accesible, por lo que no es un timeout. El texto de C decodifica desde
hex ASCII `6e6f2066726573682072656164696e67`, no desde un mapa CBOR.
La meta de detección ≤60 s desde desconexión no puede certificarse en esta
muestra: no hay instante físico marcado y el cliente consulta cada ≈15 s.
Se conserva el resultado medido, sin redondearlo a un cumplimiento exacto.

El historial previo visible al comienzo del video muestra fin de **2 observaciones**
a 00:54:05.736 y `Sensor back after 32 failed reads` a 00:54:11.224. El anuncio
`Fresh readings again: GET answers 2.05; observers must register again` ocurre
0.518 s después, a 00:54:11.742. Es evidencia de recuperación de lectura sin
arranque nuevo visible, pero no mide el tiempo desde reinsertar el cable.
En C hay dos respuestas `no fresh reading` en ese historial. No se atribuye
la multiplicidad de respuestas a una causa RF.

En la desconexión principal el log dice **0 observation(s) ended**: ya no había
observadores activos. Se distinguen las dos secuencias; el final de Observe
proviene del episodio previo y la tabla de edad/Max-Age del episodio principal.
La reconexión posterior a la desconexión principal se documenta en el video
siguiente, descrito a continuación.

## Recuperación de la desconexión principal y nuevo Observe

[Video, capturas y transcripción](archivos/08-recuperacion-DATA-video-transcripcion.md),
[CSV de tiempos](recuperacion-DATA-tiempos.csv).

S registra `Sensor back after 193 failed reads` y 22.00 °C a **01:01:37.224**, sin
arranque nuevo visible y con continuidad del uptime. El trabajo policy anuncia
dato fresco/GET 2.05 a **01:01:38.188**, **0.964 s** después de la lectura.
La reconexión física no aparece marcada, de modo que no se estima su tiempo.

El GET de C se atiende a **01:01:48.927** con 2.05, edad 1 s y Max-Age 59;
CBOR `a16174f94d88` = {t:22.125 °C}, impreso como 22.12 °C en S.
C registra Observe de nuevo a **01:01:58.841** y recibe **OBS=33** con ese mismo
valor. Es la respuesta de registro inicial, no una notificación posterior.

Quedan verificados recuperación de lectura sin reinicio visible, retorno real
de GET 2.05 y registro Observe explícito posterior. Los 11.703 s entre primera
lectura y GET incluyen la intervención del usuario y no son RTT ni tiempo de
reconexión. No se muestra aún notificación posterior a OBS=33.

## Disponibilidad y recuperación

| Condición | Evidencia en C | Evidencia en S | Tiempo |
|---|---|---|---|
| Sensor desconectado | Recibe 22.00 °C y después texto no fresh reading | Edad 16/31/46 s con Max-Age 44/29/14; luego 5.03 | GET 5.03 a 61.577 s desde última lectura; instante de retiro no marcado |
| Sensor reconectado | GET 2.05 y nuevo Observe OBS=33, CBOR 22.125 °C | Sensor back tras 193 fallas, lectura 22.00 °C y policy fresca | 0.964 s de lectura recuperada a policy; reinserción física sin marca temporal |
| Nodo fuera de red | pendiente | pendiente | pendiente |
| Reinicio de S | pendiente | pendiente | pendiente |

## Auditoría Trustworthiness — DDR §9

| Característica | Evidencia por obtener | Estado |
|---|---|---|
| Integridad ante fallas | referencia, ruido, inyecciones, edad y filtros | pendiente |
| Disponibilidad | GET fresco y vencimiento 5.03 en video; fin de Observe en historial previo | Sensor perdido documentado; falta nodo fuera de red y tiempo desde retiro físico |
| Fiabilidad | failed/reads en reposo y bajo tráfico; meta <5 % ocupado | pendiente |
| Resiliencia | Sensor back sin reinicio visible; GET 2.05 y nuevo Observe OBS=33 verificados | Reconexión manual sin marca temporal; faltan reset y nodo fuera de red |
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
- [x] Ruido y paso impreso documentados con 30 muestras visibles y stats.
- [x] Curva térmica y seis notificaciones emparejadas en C/S documentadas.
- [x] Dos soplidos confirmados por el usuario.
- [ ] Inicio/fin de los soplidos no medidos; tiempo de media subida desde el estímulo no determinado.
- [x] Inyección 31.5 rechazada por salto y 23 aceptada/notificada en S.
- [x] Rechazo por rango de inject 90 documentado.
- [ ] Offset pendiente de referencia confiable.
- [x] Sensor lost, GET con edad/Max-Age y 5.03 documentados con reloj S.
- [x] Fin de Observe documentado en historial previo; recuperación posterior de S con GET 2.05 y nuevo Observe OBS=33 confirmada.
- [ ] Cronometraje desde desconexión/reconexión física no disponible; falta nodo inaccesible.
- [ ] Reposo/tráfico, recuperación y reset documentados.
- [ ] Comparación de clase e informe completados.
- [ ] Cierre físico de la sesión confirmado.
