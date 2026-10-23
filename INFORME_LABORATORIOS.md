# Design & Decision Record (DDR)

**GreenField Technologies | IoT Systems Design — SoilSense**
**Informe consolidado: Lab 0 HTTP, Lab 0 MQTT y Labs 1–4**

**Team Members:**

1. Ismael Cortes Ramirez.
2. David Henao Rojas.

**Fecha de consolidación:** 23 de octubre de 2026.
**Repositorio de trabajo y evidencias:** [sillHD/IoT](https://github.com/sillHD/IoT).

Estructura tomada de [en/3_deliverables_template.md](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ae16e74895e1375ad0ff54ef7f691c8c94ae58d1/en/3_deliverables_template.md),
commit `ae16e74895e1375ad0ff54ef7f691c8c94ae58d1`; el contenido de esa plantilla
coincide con la versión consultada en la rama principal al preparar este informe
(blob `07fcd2c3c9738ef40b3a33b2e7f2edcb2ad2864f`). Se conservan sus diez secciones;
las respuestas están en español. Labs 5–8 se identifican como trabajo futuro.

Este Markdown reúne los resultados y decisiones. Los enlaces llevan a logs,
capturas, videos, firmware y cálculos del repositorio. **Cerrar un laboratorio
por decisión del equipo no convierte sus limitaciones en pruebas realizadas.**
El Lab 2 dispone de una adaptación preparada, pero no tiene resultados
experimentales propios registrados. Los resultados de Labs 1, 3 y 4 no lo sustituyen.

---

## 1. System Overview

**System Type:** [ ] Component (Lab 1–2) | [x] System (Lab 3–6) | [ ] Environment (Lab 7–8).

**Description:** Prototipo SoilSense sobre ESP32-C6 y Zephyr para publicar
mediciones y recibir órdenes de actuación. Evolucionó desde temperatura simulada
y LED por HTTP/MQTT sobre Wi-Fi hasta dos nodos Thread con CoAP/CBOR y un DS18B20
real, añadiendo frescura, detección de fallas y recuperación.

La actuación física validada corresponde al LED RGB; representa una válvula,
pero no demuestra movimiento ni seguridad de una válvula de riego real.
Los firmwares de cada práctica son etapas independientes: no se ha implementado
un gateway que una automáticamente Thread, MQTT y los dashboards anteriores.

| Etapa | Componentes y comunicación | Alcance documentado |
|---|---|---|
| Lab 0 HTTP | ESP32-C6 ↔ Wi-Fi/IPv4/HTTP ↔ dashboard Flask | Telemetría simulada, POST de encendido/apagado y visualización |
| Lab 0 MQTT | ESP32-C6 ↔ Mosquitto ↔ dashboard Flask | Publicación/suscripción, telemetría y órdenes de LED |
| Lab 1 | Dos radios 802.15.4 y OpenThread CLI | Escaneo, formación de red, RSSI y pérdida a distintas distancias |
| Lab 2 | Adaptación A/B del firmware de malla | Preparada; mediciones de esta práctica no registradas |
| Lab 3 | C cliente ↔ Thread/IPv6/UDP/CoAP ↔ S servidor | Temperatura simulada, Observe, válvula software y SED |
| Lab 4 | DS18B20 → S ↔ Thread/CoAP ↔ C | Temperatura real, caducidad, fallas, tráfico y reinicio |

En Lab 4, el DS18B20 se configuró en GPIO18, alimentado a 3V3, con 12 bits y
adquisición cada 2 s. El LED RGB está en GPIO8. La consola usada en las últimas
prácticas fue UART mediante CH343; USB nativo requiere su propia configuración.
La flash del firmware posterior se limitó a 4 MB, tras detectar discrepancias
entre tamaño configurado y físico en las primeras cargas.

Entorno registrado: Windows/WSL2, workspace `~/zephyrproject`, west 1.5.0;
logs posteriores identifican Zephyr `v4.4.0-13610-g4564d775ab0b`.
Los nombres de puertos y las asignaciones A/B/C/S cambiaron entre sesiones:
no se deducen identidades físicas permanentes de `/dev/ttyACM0` o de una letra.

### Trazabilidad del alcance

| Práctica | Estado y fuente principal |
|---|---|
| HTTP | GET/POST directos validados; video con telemetría de dashboard y salvedad de actuación UI: [registro](lab_http/evidencias/registro.md) |
| MQTT | Flujo de telemetría y control por dashboard validados: [registro](lab_mqtt/evidencias/registro.md) |
| Lab 1 | Mediciones a 1/5/10/15 m; serie detenida a 15 m: [registro](lab1/evidencias/registro.md) |
| Lab 2 | Firmware, guía y plantilla A/B; sin resultados propios: [registro](lab2/evidencias/registro.md) |
| Lab 3 | Finalizado por decisión del equipo, con tiempos visuales y estimaciones identificadas: [informe](lab3/INFORME.md) |
| Lab 4 | Finalizado por decisión del equipo, con brechas de referencia, sincronización y apagado final: [informe](lab4/INFORME.md) |

Para Lab 3 el equipo indicó fecha 15 de octubre de 2026 y distancia aproximada
2 m sin obstáculos. Su video de temporización tiene nombre de origen del 22 de
octubre; ambas procedencias se distinguen. Los videos de Lab 4 también llevan
2026-10-22; no se trasladan automáticamente a esa práctica la fecha o condiciones
indicadas para Lab 3. Faltan algunos metadatos específicos de sesión y commits
exactos cargados en las placas.

---

## 2. Lab Log & Stakeholder Summaries

### Lab 0: HTTP

**Trabajo realizado:** se implementaron subsistemas Wi-Fi, servidor HTTP, JSON y
LED. `GET /api/sensor` devolvió HTTP 200 y `{"temperature": 29.8}` simulado;
`POST /api/control` con estados 1 y 0 devolvió éxito y fue confirmado en serial.
La fotografía también muestra el LED encendido.

**Para el equipo de operación:** la API directa de lectura/control funcionó.
El dashboard mostró telemetría; su video también contiene un aviso de fallo al
apagar. El equipo lo atribuyó a pulsar OFF con el LED ya apagado, pero no hay
una nueva secuencia UI ON→OFF documentada que cierre esa verificación. No se
presenta la explicación como causa técnica demostrada.

[Evidencia GET](lab_http/evidencias/archivos/http-get-2026-10-01.txt),
[POST ON](lab_http/evidencias/archivos/http-post-led-2026-10-02.txt),
[POST OFF](lab_http/evidencias/archivos/http-post-led-off-2026-10-02.txt).

### Lab 0: MQTT

**Trabajo realizado:** Mosquitto escuchó en interfaces de red y WSL confirmó acceso
TCP al broker `192.168.1.4:1883`. ESP32 publicó temperatura simulada cada 2 s en
`iot/sensor` y recibió estados 1/0 por `iot/control`; el dashboard mostró datos
y sus órdenes se registraron en el nodo.

**Para operación:** MQTT desacopla productor y consumidores mediante el broker.
La telemetría se publica con QoS 0; las órdenes usan QoS 1 en el código preparado.
Ese QoS confirma entrega en el tramo MQTT correspondiente, no el movimiento de
un actuador real. El broker se ejecutó manualmente; servicio permanente y
reconexión ante fallas no quedaron validados.

[Conexión y publicaciones](lab_mqtt/evidencias/archivos/flash-runtime-2026-10-02.txt),
[órdenes desde dashboard](lab_mqtt/evidencias/archivos/dashboard-led-control-2026-10-02.txt).

### Lab 1: RF Characterization

**To Samuel (Architect):** el escaneo de energía encontró −104 dBm en 21, 24 y 25;
se seleccionó 25. Se documentaron pings bidireccionales hasta 15 m; allí la pérdida
fue 98 % A→B y 96 % B→A. No se midieron distancias superiores.

**To Edwin (Ops):** durante las mediciones hubo problemas con la línea de visión,
a los que se atribuyó la variación anormal de RSSI y pérdida. Antes de comparar
resultados deben comprobarse canal, potencia, unión y dirección del vecino. No
se establece una separación de despliegue a partir de esta serie.

[Escaneo](lab1/evidencias/archivos/channel-scan-2026-10-02.txt),
[tabla y capturas](lab1/evidencias/registro.md).

### Lab 2: 6LoWPAN

**To Samuel:** quedó preparada una adaptación de dos nodos para direcciones,
pings de un salto y contadores de extremos. No se registraron ensayos propios;
no existen números de costo por salto o recuperación de rutas para reportar.
La comparación de uno/dos saltos y los ensayos de ruta alternativa requieren
el tercer nodo de la guía original.

**To Edwin:** los retornos manuales a Thread observados en Labs 3–4 demuestran
reincorporación de esos nodos, no la recuperación por otra ruta del Lab 2.
No se afirma cumplimiento de su meta de healing <120 s.

[Alcance de la adaptación](lab2/ORIGEN.md), [registro sin mediciones](lab2/evidencias/registro.md).

### Lab 3: Thread & CoAP

**To Daniela (Customer):** se leyeron datos y se fijó el estado de la válvula
simulada con mensajes pequeños. Observe produjo 29 notificaciones en 300 s,
frente a 300 consultas de un lector hipotético a 1 Hz. Esto compara mensajes,
no consumo medido ni ahorro frente a consultar cada 60 s.

**Para Samuel:** GET usa 15/17 B CoAP, Observe NON 19 B y PUT CLI 18/13 B.
Dormir S elevó el RTT: promedios 0.466/2.119/8.489 s con sondeos de 1/5/15 s.
La propuesta de sondeo de 5 s debe acordarse con la latencia operativa requerida.

**Para Edwin:** PUT/GET confirmó estado software; al retirar S de Thread,
CON terminó en timeout de ≈92 s reportado por el equipo y NON solo mostró Done.
Un actuador real necesita realimentación física para confirmar movimiento.

[Registro](lab3/evidencias/registro.md), [informe](lab3/INFORME.md).

### Lab 4: Real Sensors

**To Edwin:**

1. Con sensor perdido y nodo accesible, el dato envejeció y GET pasó a 5.03; se documentó a 61.577 s desde la última lectura, sin marca de retirada física.
2. Con nodo fuera de Thread, hubo silencio y timeout GET CON tras ≈74.1 s; S siguió leyendo localmente.
3. Reconectar recuperó el sensor; después de RESET hubo que activar Thread y registrar Observe nuevamente. El offset no se determinó por falta de referencia confiable.

El sensor no tuvo fallas en las ventanas de reposo y tráfico reportadas. El
ensayo de inyección mostró que un valor falso plausible puede ser aceptado.
[Informe y auditoría](lab4/INFORME.md), [registro](lab4/evidencias/registro.md).

### Lab 5: Border Router

**To Daniela:** no iniciado. No se ha validado acceso entre Thread y redes externas.

### Lab 6: Security

**To Edward (Security):** no iniciado. No se atribuye DTLS o autenticación de
aplicación a las pruebas actuales.

### Lab 7: Dashboard

**To Gustavo (Product):** no iniciado. Los dashboards de Lab 0 son antecedentes;
no equivalen al dashboard integrado del Lab 7.

### Lab 8: Final Integration

**To All:** no iniciado. Falta integración y validación final del sistema completo.

---

## 3. Architecture Decision Records (ADRs)

### ADR-001: Canal 25 para las pruebas de radio

- **Context:** seleccionar un canal para la serie 802.15.4 sin introducir interferencia deliberada.
- **Decision:** usar canal 25 en Lab 1 a partir del escaneo de energía.
- **Rationale:** registró −104 dBm, empatado con 21 y 24; permite fijar una condición de comparación. Es una decisión local basada en ese escaneo, no prueba de ausencia de Wi-Fi ni de idoneidad universal.
- **Status:** [ ] Proposed | [x] Accepted | [ ] Deprecated.
- **Evidence:** [escaneo original](lab1/evidencias/archivos/channel-scan-2026-10-02.txt).

### ADR-002: Topología Thread y límite de la adaptación A/B

- **Context:** el proyecto necesita comunicaciones IPv6 y analizar recuperación de malla; solo se dispuso de dos placas para la adaptación de Lab 2.
- **Decision:** preparar A/B para ensayos de un salto y reservar la comparación multisalto/ruta alternativa para una configuración con tercer nodo.
- **Rationale:** dos extremos no demuestran reenvío por un intermediario ni camino de respaldo. Thread se usó después en Labs 3–4, pero la selección de una topología redundante frente a una estrella no tiene aún evidencia propia de Lab 2.
- **Status:** [x] Proposed | [ ] Accepted | [ ] Deprecated, para la decisión de topología de despliegue; adaptación A/B ya preparada.
- **Evidence:** [registro Lab 2](lab2/evidencias/registro.md).

### ADR-003: CoAP/UDP y CBOR para los recursos Thread

- **Context:** conservar operaciones de lectura/control con mensajes pequeños y confirmación elegible por mensaje.
- **Decision:** GET/Observe para temperatura y PUT CON/GET para estado de válvula, con contratos CBOR.
- **Rationale:** GET 15/17 B, Observe 19 B, PUT CLI 18/13 B; se verificaron lectura, respuesta, rechazo e idempotencia. MQTT sigue siendo útil entre servicios, pero añade un broker y la conexión TCP del prototipo anterior; su confirmación no prueba ejecución física de la válvula.
- **Status:** [ ] Proposed | [x] Accepted | [ ] Deprecated, para el prototipo de laboratorio.
- **Evidence:** [presupuesto y pruebas Lab 3](lab3/INFORME.md).

### ADR-004: Sondeo de 5 s como compromiso propuesto

- **Context:** reducir escucha de radio sin repetir esperas de minutos para órdenes.
- **Decision:** proponer 5 s para la válvula SED, con órdenes idempotentes y verificación de estado.
- **Rationale:** RTT ICMP promedio 2.119 s y máximo 4.039 s en diez pings; fracción ideal de sondeo 0.2 %. El modelo estima 0.328 mA, pero no mide corriente real. El objetivo operativo de aproximadamente 5 s es una hipótesis pendiente de acuerdo, no requisito ya aprobado por Edwin.
- **Status:** [x] Proposed | [ ] Accepted | [ ] Deprecated.
- **Evidence:** [SED y energía](lab3/INFORME.md), [cálculo](lab3/evidencias/energia-estimada.csv).

### ADR-005: Frescura explícita y error cuando falta una lectura actual

- **Context:** un nodo podría seguir contestando un valor antiguo y ocultar un sensor desconectado.
- **Decision:** conservar la última lectura aceptada con edad, servir Max-Age restante y responder 5.03 cuando deja de estar fresca; terminar Observe con error y exigir nuevo registro.
- **Rationale:** en Lab 4 se observaron edades 16/31/46 s, Max-Age 44/29/14 y después 5.03. Se distingue dato ausente de nodo incomunicado. El contrato mantiene el payload normal del Lab 3, pero cambia su promesa temporal.
- **Status:** [ ] Proposed | [x] Accepted | [ ] Deprecated, implementado y ensayado en Lab 4 con límites de temporización documentados.
- **Evidence:** [video y transcripción de caducidad](lab4/evidencias/archivos/07-desconexion-DATA-video-transcripcion.md).

### ADR-006: Estado cerrado ante datos ausentes y cierre local

- **Context:** una decisión de riego no debe depender indefinidamente de una lectura vencida o de que CLOSE atraviese una red fallida.
- **Decision:** proponer no autorizar apertura con dato inválido, retirar autorización al recibir 5.03, plazo operativo de silencio y cierre local temporizado.
- **Rationale:** el nodo puede responder error o permanecer inaccesible; una orden remota no garantiza cierre si la red cae. Se detallan plazos y limitaciones en la sección 7.
- **Status:** [x] Proposed | [ ] Accepted | [ ] Deprecated; no implementado ni validado en actuador real.
- **Evidence:** [diseño Lab 4](lab4/INFORME.md).

---

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

Se sigue el mapeo funcional del material del curso; una función de comunicación
embebida no equivale por sí sola a todo un dominio de gestión o acceso.

| Component | ISO Domain | Justification |
|---|---|---|
| Aire/suelo y temperatura; medio de propagación RF | PED — Physical Entity Domain | Entidades y fenómenos físicos observados; temperatura simulada de Lab 0/3 no es medición física del ambiente |
| ESP32-C6, DS18B20, GPIO18 y filtros locales | SCD — Sensing & Controlling Domain | Adquisición y validación local del sensor |
| LED RGB y representación de válvula | SCD | Actuación física del LED; válvula real no instalada |
| Radio 802.15.4, Thread, IPv6/UDP y sondeo al padre | SCD, subsistema de comunicación | Conectividad de los dispositivos; no cambia el significado de los recursos |
| Recursos HTTP/CoAP, contratos y lógica Flask | ASD — Application & Service Domain | Servicios de lectura/control y presentación de aplicación |
| Mosquitto y su operación; configuración, logs y diagnóstico | OMD — Operation & Management Domain, conforme a guía MQTT | Enrutamiento pub/sub en el prototipo y soporte de operación; no constituye gestión integral desplegada |
| Integrantes y operadores usando web/CLI | UD — User Domain | Actores humanos que consultan y mandan órdenes; la interfaz técnica sirve su interacción |
| Acceso autenticado/intercambio con sistemas externos | RAID — Resource Access & Interchange Domain | Aún no implementado como subsistema; publicar una URI no demuestra autenticación/autorización |

La aplicación CoAP ocupa el plano funcional; MLE mantiene red/parentesco en el
plano de gestión. Los seis dominios pertenecen a la perspectiva funcional;
Trustworthiness se aplica transversalmente.

### Component Capabilities

“Activa” significa habilitada/observada en la etapa indicada, no que todos los
firmwares se ejecuten simultáneamente. Una generación simulada es capacidad de
datos, aunque la práctica inicial la use para representar el sensado.

| Capability Category | Subcategory | Component/Feature | Active/Latent | Lab Introduced |
|---|---|---|---|---|
| Transducer | Sensing | DS18B20 real, adquisición cada 2 s | Activa; lecturas documentadas | Lab 4 |
| Transducer | Actuating | WS2812 GPIO8, estado 1/0 y válvula software | Activa para LED; válvula física no validada | Lab 0 |
| Data | Processing | Generación simulada, parser JSON/CBOR, plausibilidad y edad | Activa en sus etapas; simulación no mide el PED | Lab 0; ampliada Labs 3–4 |
| Data | Storage | Última lectura y contadores RAM; ajustes Thread mediante NVS | Activa; contadores/observadores se pierden al reset | Labs 1, 3–4 |
| Data | Transferring | Telemetría, órdenes, Observe y respuestas | Activa por cada protocolo ensayado | Lab 0; ampliada Lab 3 |
| Interface | Network | Wi-Fi en HTTP/MQTT; 802.15.4/Thread en prácticas siguientes | Activa según firmware; Wi-Fi no usado en Lab 4 | Labs 0–1 |
| Interface | Application | HTTP/JSON, MQTT/tópicos, CoAP/CBOR | Activa en sus etapas | Labs 0 y 3 |
| Interface | Human user | Dashboards Flask, shell y monitor serial | Activa; actuación UI HTTP con salvedad | Lab 0 |
| Supporting | Management/identity | Consulta de roles, ML-EID, stats, arranque manual | Activa localmente; sin plataforma central de gestión | Lab 1; ampliada Lab 4 |
| Supporting | Security | Aceleradores y mecanismos de seguridad disponibles | Capacidad potencial; DTLS/autorización de aplicación no ensayados | Futuro Lab 6 |
| Latent | Unused functions | BLE y funciones no habilitadas en la imagen actual | Latentes para estos ensayos | Identificadas desde Lab 1 |

Correspondencia de la tarea HTTP: `CONFIG_WIFI` habilita interfaz de red;
`CONFIG_HTTP_SERVER`, interfaz de aplicación; `CONFIG_JSON_LIBRARY`, procesamiento
de datos; `CONFIG_LED_STRIP`, actuación. Habilitar un subsistema no prueba por
sí solo su comportamiento: las respuestas y logs aportan la evidencia de ejecución.

### Contratos de aplicación

| Interfaz | Entrada / operación | Salida | Alcance |
|---|---|---|---|
| HTTP `/api/sensor` | GET | JSON {temperature:número}, HTTP 200 | Temperatura simulada |
| HTTP `/api/control` | POST JSON {state:0/1} | HTTP 200; {status:"ok"} documentado al apagar | LED; serial confirma estado |
| MQTT `iot/sensor` | Publicación periódica QoS 0 | JSON {temperature:número} | Productor ESP32, consumidor dashboard |
| MQTT `iot/control` | Publicación de orden QoS 1 | JSON {state:0/1}; recepción serial | No hay prueba de posición física de válvula |
| CoAP `/env/temp`, Lab 3 | GET / GET+Observe | 2.05, Content-Format 60, {t:float16}, 6 B | Simulada; Max-Age 60 |
| CoAP `/env/temp`, Lab 4 | GET / GET+Observe | Mismo CBOR normal; Max-Age restante; 5.03 con texto si no hay dato fresco | Sensor real; exactitud nominal y filtros descritos abajo |
| CoAP `/act/valve` | PUT para fijar, GET para leer | {v:0/1}, 4 B; 2.04 PUT, 2.05 GET, 4.00 inválido | Válvula simulada mediante LED |

```cddl
env-reading = { t: float16 } ; grados Celsius
valve-state = { v: 0 / 1 }   ; 0 cerrado, 1 abierto
```

La CLI envió el texto 0/1 para PUT sin Content-Format; el servicio también acepta
el mapa CBOR con Content-Format 60. El presupuesto de bytes medido corresponde
a esa solicitud de texto, no a una solicitud CBOR de 4 B.

En Lab 4, especificación nominal DS18B20: ±0.5 °C entre −10 y 85 °C, paso de
0.0625 °C a 12 bits. El filtro de la aplicación admite −40 ≤ T < 85 y rechaza
saltos >5 °C frente a lectura aceptada de edad <10 s. Lectura cada 2 s;
ninguna aceptada de edad <60 s implica 5.03, Max-Age 10 para reintento y texto
`no fresh reading`, terminando Observe. La exactitud es de fabricante, no una
calibración propia. [Contrato y código Lab 4](lab4/INFORME.md).

---

## 5. First Principles Reflections

### Lab 0 HTTP/MQTT

1. **Solicitud/respuesta y pub/sub.** En HTTP el cliente solicita un recurso al servidor. En MQTT productor y consumidor se relacionan a través del broker/tópico; añadir consumidores no requiere que el ESP32 mantenga una lista de dashboards.
2. **Confirmación y actuación.** HTTP 200 o un ACK MQTT no prueban por sí solos movimiento físico. Los logs muestran procesamiento del estado y la foto de HTTP confirma LED encendido; un actuador real necesita sensor de posición o caudal.
3. **Simulación y sensado.** Un JSON correcto no demuestra medición ambiental. En Labs 0/3 la temperatura fue generada; solo Lab 4 conecta el sensor físico y permite discutir exactitud, envejecimiento y falla de adquisición.

### Lab 1

1. **RSSI y distancia.** En espacio libre la energía se reparte sobre un área que crece con el cuadrado de la distancia; la potencia recibida cae y la pérdida de trayecto aumenta aproximadamente 20 log10(d). Obstáculos, reflexiones, orientación y ruido cambian ese comportamiento. La serie observada no siguió un patrón monótono al tener problemas de línea de visión.
2. **Sensibilidad y margen.** Detectar una señal cerca de la sensibilidad no implica entregar todos los paquetes. Ruido, interferencia y desvanecimientos reducen SNR y margen; RSSI promedio de paquetes recibidos no describe los que se perdieron. Por eso el RSSI más alto en algunos puntos no contradice una pérdida grande ni permite derivar una separación de despliegue.
3. **DSSS e interferencia, reflexión opcional.** El ensanchamiento de espectro permite recuperar señales con cierta interferencia mediante correlación. No elimina colisiones ni saturación y no equivale a inmunidad a Wi-Fi. El escaneo informa energía en un momento, no disponibilidad permanente del canal.

### Lab 2 — análisis conceptual, sin validación propia

1. **IPv6 en 802.15.4.** 6LoWPAN/IPHC comprime campos y prefijos conocidos; determinados IID pueden reconstruirse a partir de direcciones MAC/cortas y contexto. El IID del RLOC se relaciona con RLOC16; la ML-EID aleatoria no se deduce en general del MAC. Cabeceras y tamaño real dependen del contexto: no se afirma un tamaño comprimido medido sin captura.
2. **Detección de una ruta fallida.** Enlaces activos pueden detectar falta de ACK MAC antes de expirar un vecino silencioso, y MLE distribuye información. El tiempo depende del tráfico y del estado; no medimos healing aquí. Los segundos de reingreso manual del Lab 4 no prueban recuperación automática por camino alternativo.
3. **Enlace de respaldo pobre frente a inexistente.** Si desaparece el único intermediario y los extremos no tienen ningún camino físico restante, no hay ruta que el protocolo pueda recuperar. Una deny-list puede eliminar ese respaldo en lugar de degradarlo. Hace falta probar enlaces y rutas reales con el tercer nodo.
4. **ML-EID frente a RLOC.** RLOC localiza topológicamente y puede cambiar al volver a unirse; ML-EID sirve de identidad mesh-local más estable. En Lab 4 la ML-EID persistió tras reset, pero eso no valida por sí solo el experimento de relocalización del Lab 2.

### Lab 3

1. **UDP, CON y NON.** CoAP agrega a datagramas UDP correlación y confirmaciones/reintentos acotados en CON. NON prescinde de ese mecanismo, aunque pueda recibir respuesta. Done de la CLI solo acepta el envío. TCP proporciona un flujo fiable, pero tampoco garantiza ejecución física. La comparación de HTTP aquí es con HTTP/TCP de Lab 0, no con todos los transportes de todas sus versiones.
2. **Observe y batería.** S conoce el cambio y puede evitar consultas frecuentes de C. Hubo 29 notificaciones frente a 300 consultas hipotéticas a 1 Hz en cinco minutos. Frente a GET cada 60 s serían unas cinco consultas; estos datos no demuestran ahorro frente a esa alternativa. Tampoco una razón de mensajes equivale a razón de energía o de tramas RF.
3. **PUT repetido.** Con sondeo de 5 s puede vencer una espera CON inicial de 2–3 s antes de que S consulte al padre. S registró OPEN y OPEN, no change, separados 131 ms. Es compatible con reintentos, sin captura de Message ID para reconstruirlos. Fijar OPEN es idempotente; un toggle duplicado podría deshacer la orden.
4. **CBOR y evolución.** Codifica tipos sin depender de padding/alineación de una estructura C; CDDL explicita el esquema. Compatibilidad con nuevos campos requiere diseñar reglas o versiones: el parser actual no acepta automáticamente cualquier ampliación. Float16 cuantiza y no mejora la exactitud física del sensor.

### Lab 4

1. **Frescura.** Servir un valor antiguo como actual oculta la falla y puede alterar decisiones de riego. Max-Age permite uso acotado; después 5.03 hace explícita la ausencia del dato.
2. **Dos fallas distintas.** Sensor ausente con nodo accesible devuelve error de aplicación. Nodo inaccesible produce silencio y timeout; eso no distingue por sí solo pérdida de radio de placa apagada. La prueba detuvo Thread y mantuvo la adquisición funcionando.
3. **Falso pero plausible.** Inject 23 pasó y se notificó; los filtros carecen de una verdad independiente. Una referencia o redundancia ayuda a contrastar. Una firma puede comprobar procedencia sin asegurar que el sensor mida correctamente.
4. **Sensor y radio ocupada.** Protocolos temporizados por CPU pueden verse afectados por interrupciones. Aquí 1-Wire es por GPIO, pero DS18B20 convierte internamente y el driver espera durante gran parte de los ≈760 ms; no son ≈760 ms de CPU necesariamente ocupada. La ausencia de fallas en nuestra muestra no prueba igualdad con DHT o I²C sin datos comparativos.

---

## 6. Performance Baselines

Los objetivos de esta primera tabla provienen de la plantilla. “Cumple en la
muestra” no es garantía de todos los escenarios. No se mezclan cronómetros:
GET visual, RTT ICMP, detección desde última lectura y reingreso a Thread son
mediciones diferentes.

| Metric | Target | Measured | Status |
|---|---|---|---|
| Lab 1: Max Range | >20 m | Se midió hasta 15 m; allí pérdida 98/96 %. Más distancia no medida | Objetivo no demostrado; no se declara alcance máximo físico |
| Lab 2: Healing Time | <120 s | Sin medición propia ni ruta alternativa ensayada | Pendiente |
| Lab 3: CoAP Latency | <200 ms | GET visible ≈50/17/67 ms, promedio ≈44 ms | Menor al objetivo en la muestra visual; no RTT instrumental |
| Lab 3: Poll Latency, 5 s | <5 s | RTT ICMP min/avg/max 0.196/2.119/4.039 s, 10/10 respuestas | Cumple en muestra ICMP; no es tiempo de mando físico |
| Lab 4: Time to see a lost sensor | ≤60 s | Primer GET 5.03 a 61.577 s desde última lectura; retiro físico sin marca | Cumplimiento desde desconexión no acreditado |
| Lab 4: Read failures, radio busy | <5 % | 0/93 = 0 % en ventana de 186 s; ping 1199/1200 | Inferior al objetivo en ventana reportada; carga/contadores no sincronizados exactamente |
| Lab 6: DTLS Time | <3 s | No medido | Lab futuro |

### Lab 1 — escaneo y distancia

Escaneo de 500 ms por canal:

| Canal | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Energía/RSSI dBm | −102 | −101 | −102 | −102 | −103 | −103 | −99 | −96 | −103 | −101 | −104 | −103 | −103 | −104 | −104 | −96 |

RSSI de A→B se lee en B; RSSI de B→A se lee en A. Pings secuenciales, payload
64 B, 100 por dirección e intervalo 0.2 s.

| Distancia | TX | RSSI A→B / B→A dBm | Pérdida A→B / B→A | LQ In A→B / B→A |
|---|---|---|---|---|
| ≈1 m | 0 dBm, sesión inicial | −67 / −66 | 0 / 0 % | 3 / 3 según resumen de sesión |
| 5 m | 20 dBm, confirmado por el equipo | −78 / −80 | 1 / 0 % | 3 / 2 |
| 10 m | 20 dBm, confirmado por el equipo | −91 / −91 | 0 / 3 % | 1 / 1 |
| 15 m | 20 dBm, confirmado por el equipo | −80 / −86 | 98 / 96 % | 2 / 2 |

Para ≈1 m se prioriza el [registro por receptor](lab1/evidencias/archivos/ping-1m-2026-10-02.txt),
que indica −67 dBm en B y −66 dBm en A. Se corrige la inversión direccional de
ese punto en la tabla previa. El punto inicial de 0 dBm y la serie 5–15 m a
20 dBm no constituyen una sola serie a potencia constante. Durante las
mediciones hubo problemas con la línea de visión, circunstancia a la que se
atribuyó la variación anormal. No se extrapolan medidas a 20–50 m.

La pérdida indicada es de solicitudes ping sin respuesta, dependiente de ida y
vuelta; no es PER de una dirección MAC aislada. RSSI corresponde a recepción en
el extremo indicado. Tampoco se ha medido presupuesto de enlace absoluto o
interferencia causada a terceros.

### Lab 2 — tablas experimentales aún no disponibles

| Ensayo | Resultado |
|---|---|
| Direcciones y contadores de la adaptación A/B | No registrado para Lab 2 |
| RTT uno frente a dos saltos | No medido |
| Tres ensayos de retiro de intermediario con respaldo | No realizados/documentados |

### Lab 3 — presupuesto de bytes, Observe y SED

| Intercambio | Solicitud CoAP B | Respuesta/notificación CoAP B | Total básico CoAP+UDP B |
|---|---:|---:|---:|
| GET temperatura | 15 | 17 | 48 |
| Registro Observe | 16 | 19 | 51 |
| Notificación NON | — | 19 | 27 |
| PUT válvula, texto CLI | 18 | 13 | 47 |
| GET válvula | 16 | 13 | 45 |

CoAP incluye CBOR; no se suma dos veces. UDP añade 8 B por datagrama. El cálculo
básico excluye IPv6/6LoWPAN, MAC, ACK separados, reintentos y gestión de red.
La guía usa referencias HTTP ≈150/120 B más TCP y MQTT ≈40 B en una conexión
establecida; no se midieron esos tamaños de red localmente.

Como presupuesto ilustrativo de trama, 127 B menos 25 B MAC y 21 B de seguridad
deja 81 B. El mensaje CoAP más grande observado, 19 B, más UDP 8 B e IPv6/dispatch
40+1 B sería 68 B, menor que 81 B bajo esas hipótesis. Cabeceras reales y ausencia
de fragmentación no fueron capturadas por radio. [Análisis](lab3/INFORME.md).

En 300 s hubo **29 threshold/NON y 0 heartbeat**, razón **300/29 ≈10.34** respecto
a consultas hipotéticas a 1 Hz. Las notificaciones suman 551 B CoAP sin registro.
Contando registro y notificaciones: 16+19+29×19 = 586 B, frente a
300×(15+17) = 9600 B de polling básico. Son cálculos con alcance limitado, no
consumo eléctrico. La cancelación se documentó después de la ventana.

| Sondeo SED | RTT min/avg/max ms | Ping enviados/recibidos | Fracción supuesta 10 ms/T |
|---|---|---|---|
| 1 s | 16 / 465.600 / 916 | 10 / 10 | 1 % |
| 5 s | 196 / 2119.000 / 4039 | 10 / 10 | 0.2 % |
| 15 s | 757 / 8488.900 / 14461 | 10 / 10 | ≈0.0667 % |

Los tres ensayos tuvieron padre con LQ 3/3. Con S detenida, CON produjo timeout
≈92 s reportado por el equipo; NON no mostró mensaje adicional, sin temporización
propia de su ventana. Un PUT a SED de 5 s se entregó dos veces a la aplicación,
con segunda entrega sin cambio de estado.

El GET visual se midió con video 60 fps: intervalos de 3/1/4 fotogramas, ≈50/17/67 ms.
El margen de lectura conservador es ±2 fotogramas (≈33 ms), más efectos sistemáticos
no cuantificados de consola/USB/captura. El salto de línea sustituye al Enter
físico no visible. [Video, fotogramas y método](lab3/evidencias/archivos/GET-video-metodo-y-transcripcion.md).

### Lab 3 — energía estimada, no medida

Modelo: RX 74 mA y reposo light-sleep 0.180 mA, tablas 5-9 y 5-11 del
[datasheet ESP32-C6 v1.5](https://documentation.espressif.com/esp32-c6_datasheet_en.html);
10 ms activos por sondeo y capacidad útil ideal supuesta de 3000 mAh en dos AA
en serie. En serie no se suman mAh. Se idealiza la conversión de alimentación.

```text
f = 0.010 / T_s
I_media_mA = f × 74 + (1 − f) × 0.180
vida_h = 3000 / I_media_mA
```

| Sondeo | Corriente estimada mA | Autonomía ideal días |
|---|---:|---:|
| 1 s | 0.918200 | 136.14 |
| 5 s | 0.327640 | 381.52 |
| 15 s | 0.229213 | 545.34 |

`ot mode -` no demuestra que el SoC alcance light-sleep. El modelo omite actuador,
sensor real, CPU, TX, LED, USB, reintentos y pérdidas de alimentación. No predice
la autonomía de la DevKit. [Cálculo reproducible](lab3/tools/estimate_energy.py),
[CSV](lab3/evidencias/energia-estimada.csv).

### Lab 4 — sensor, fallas y reinicio

| Métrica | Resultado | Fuente |
|---|---|---|
| Ruido | 30 muestras visibles; 21.50–21.62 °C; amplitud 0.12 °C; media 21.542 °C; s=0.0321 °C | [CSV](lab4/evidencias/ruido-S-muestras.csv), [resumen](lab4/evidencias/ruido-S-resumen.json) |
| Paso impreso | 0.06 °C; nominal a 12 bits 0.0625 °C | Mismo log; no es exactitud |
| Respuesta al estímulo | Primer pico 22.81 °C; subida ≈1.12 °C desde base de referencia 21.69 °C; segundo pico 22.50 °C | [Curva](lab4/Imagen/estimulo-DS18B20.png) |
| Observe durante respuesta | Seis notificaciones emparejadas: 5 NON y 1 CON; dos soplidos confirmados | [C/S](lab4/evidencias/estimulo-observe-C-S.csv) |
| Offset / media subida | Offset no determinado; no se midió inicio físico de soplidos | No se corrige con termómetro de cocina |
| Plausibilidad | 90 rechazado por rango; 31.5 por salto +9.6 °C; 23 aceptado y notificado | [Inyección](lab4/evidencias/archivos/06-inject-S-original.txt), [rango](lab4/evidencias/archivos/06-inject90-S-original.txt) |
| Detección local de sensor perdido | Tercer fallo 4.000 s tras el primero; 5.241 s desde última lectura | [Transcripción](lab4/evidencias/archivos/07-desconexion-DATA-video-transcripcion.md) |
| Caducidad | Policy a 60.636 s y GET 5.03 a 61.577 s desde última lectura | [CSV](lab4/evidencias/desconexion-DATA-tiempos.csv) |
| Recuperación del sensor | Sensor back tras 193 fallas; policy fresca 0.964 s tras la lectura; GET y nuevo Observe correctos | [Transcripción](lab4/evidencias/archivos/08-recuperacion-DATA-video-transcripcion.md) |
| Nodo fuera de Thread | GET CON timeout ≈74.1 s; sensor sigue leyendo; retorno detached→router 1.012 s | [Video y método](lab4/evidencias/archivos/09-nodo-fuera-red-video-transcripcion.md) |
| Reposo | 0/78 fallidas, 0 rechazadas, 155 s; adquisición min/avg/max 760659/760679/760756 µs | [Log](lab4/evidencias/archivos/10-GET-retorno-y-reposo-C-S-original.txt) |
| Tráfico | 0/93 fallidas, 0 rechazadas, 186 s; adquisición 760500/760815/764273 µs | [Stats](lab4/evidencias/archivos/11-trafico-S-stats.txt) |
| Ping con tráfico | 1200 enviados, 1199 recibidos; pérdida calculada 0.08333 %; RTT 15/16.098/41 ms | [Original](lab4/evidencias/archivos/11-trafico-C-ping-original.txt) |
| RESET | Contadores 259→8→15; nuevas lecturas; Thread disabled por arranque manual | [Video y stats](lab4/evidencias/archivos/12-reinicio-S-video-transcripcion.md) |
| Unión después de RESET | Sin copiar dataset, misma ML-EID, child; detached→child 15.048 s | [Log](lab4/evidencias/archivos/13-union-Thread-tras-reset-S.txt) |
| API después de RESET | GET 22.3125 °C y nuevo Observe OBS=2, 22.375 °C, recibidos en C | [Log C](lab4/evidencias/archivos/14-GET-Observe-tras-reset-C.txt) |

La pérdida impresa por ping fue 0.0 %; 1/1200 implica 0.08333 %, por lo que se
preservan original y cálculo. No equivale a fallo del sensor. Los 186 s de stats
superan los ≈120 s previstos de pings; no se afirma que todas las 93 lecturas
ocurrieran bajo tráfico activo ni una ventana perfectamente sincronizada.

El primer video incluye un episodio anterior con dos observaciones terminadas
y recuperación; la desconexión principal tenía cero observadores activos.
Ambos se distinguen, sin fusionarlos para aparentar Observe continuo.
La recuperación manual de DATA no tiene marca física de reconexión: 0.964 s es
de lectura a policy, no de insertar cable a recuperación. OBS=2 tras reset es
respuesta inicial al nuevo registro, no una notificación periódica posterior.

---

## 7. Ethics & Sustainability Checklist

- [ ] **Lab 1:** verificado que la interferencia no afecta vecinos. Hay escaneo de energía documentado, pero no una medición de impacto en terceros; no se marca verificado por ausencia de quejas.
- [x] **Lab 4:** definido un estado por defecto ante datos ausentes, como diseño de seguridad; no implementado ni probado en actuador real.
- [ ] **Lab 5:** sistema integrado local sin nube. Las pruebas actuales usan redes/servicios locales, pero la validación del Lab 5 y su arquitectura completa están pendientes.
- [ ] **Lab 6:** cifrado/autenticación de aplicación validados. No se equiparan claves Thread o capacidades hardware con un ensayo DTLS completado.
- [ ] **Lab 8:** plan de fin de vida. No realizado.

Se excluyeron datasets Thread, claves y credenciales Wi-Fi de las evidencias.
No se utilizaron temperatura corporal o indicador de refrigerador como patrón
de calibración. Offset y tiempo de media subida no medidos se conservan como
no determinados. No se incorporan mediciones ficticias de Labs 2 y 5–8.

### Diseño de seguridad ante OPEN sin CLOSE o temperatura ausente

**Propuesta no implementada.** Estado por defecto: cerrado/no autorizar una
apertura basada en un dato inválido. Con 5.03, retirar inmediatamente esa
autorización y avisar. No convertir ausencia de dato en 0 °C ni prolongar un
Max-Age vencido.

Con silencio, se propone un plazo operativo de 5 s desde consulta sin respuesta
para declarar estado no confirmado, sin esperar 74–92 s del timeout CoAP. Ese
plazo debe acordarse con operación y no se ha validado como requisito real.
Una orden CLOSE enviada a una red fallida puede no llegar: si la válvula ya
está abierta, se propone una concesión local inicial máxima de 60 s desde la
primera apertura, sin renovarla por duplicados. Una ampliación debe ser explícita,
autenticada y sustentada en datos frescos. El plazo debe ajustarse con caudal,
volumen seguro y cultivo; no es un tiempo agronómico demostrado.

Un actuador real requiere realimentación y comportamiento seguro ante reinicio
y falla eléctrica. El ensayo futuro debe abrir, perder datos/red y comprobar
cierre físico en su plazo. La simulación de LED no valida ese mecanismo.

### Sostenibilidad y cierre de sesiones

Los cálculos de sondeo motivan ensayar bajo consumo, pero no sustituyen medir
corriente de la placa y del actuador. Reducir mensajes no implica automáticamente
reducir energía si se mantiene CPU/radio activos. Lab 3 documentó cierre de
válvula y Thread/interfaz apagados en ambas placas. Lab 4 se cerró documentalmente
por instrucción del equipo, sin recibir confirmación del apagado final.

---

## 8. Viewpoint Analysis

| Viewpoint | Labs Addressed | Key Concerns Documented |
|---|---|---|
| Foundational | Labs 0–4; Lab 2 conceptual/preparado | Evolución componente→sistema; magnitud física, lectura simulada/real y límites de evidencia |
| Business | Labs 1, 3 y 4 | Necesidades de Daniela/Edwin/Samuel: frescura, resultado de órdenes, autonomía y recuperación; sin análisis de costos de despliegue validado |
| Usage | Labs 0, 3 y 4 | Consulta, orden, Observe, error, reconexión y acciones manuales después de reset |
| Functional | Labs 0–4; Lab 2 sin ensayos | PED/SCD/ASD, broker/operación, interacción humana y acceso aún no implementado |
| Trustworthiness | Lab 4; antecedentes Labs 1 y 3 | Integridad, disponibilidad, fiabilidad y resiliencia con medidas y brechas; seguridad propuesta; confidencialidad frente a atacantes pendiente |
| Construction | Preparación Labs 0–4; síntesis provisional | ESP32-C6, Zephyr, DS18B20, cableado, USB/UART, firmware y scripts; patrón final reservado a Lab 8 |

La auditoría comienza en **Lab 4**, como indica la plantilla actual. No se
traslada a este informe la indicación anterior del tutorial que la posponía a Lab 6.

---

## 9. Trustworthiness Audit (Lab 4+)

| Characteristic | Addressed? | How | Gaps |
|---|---|---|---|
| Availability | Parcial, con ensayos | GET normal, 5.03 ante dato vencido, timeout ≈74.1 s con S fuera de red y respuesta al retornar | Marca física de retiro ausente; detección ≤60 s no certificada; acceso externo futuro |
| Confidentiality | No validada a nivel aplicación | Credenciales y datasets excluidos de Git; uso de red configurada no equivale a prueba de confidencialidad extremo a extremo | → Lab 6; DTLS y control de acceso no ensayados |
| Integrity | Parcial frente a fallas/ambiente | Ruido, plausibilidad, CBOR, edad y rechazo de dato vencido; inject 23 evidencia límite del filtro | Offset no calibrado; un valor plausible falso pasa; integridad frente a atacantes → Lab 6 |
| Reliability | Muestras documentadas | Reposo 0/78 y ensayo tráfico 0/93; ping 1199/1200 | Ventanas distintas y solapamiento no delimitado; no garantía estadística de fallas nulas |
| Resilience | Parcial | Reintentos recuperan sensor; reset reinicia contadores, conserva configuración operativa y permite unión; GET y nuevo Observe funcionan | Arranque Thread y registro Observe manuales; sin histórico persistente; Lab 2 multi-hop no ensayado |
| Safety | Diseño documentado | Estado cerrado, rechazo de dato inválido y propuesta de plazo/cierre local | No implementado/validado en válvula física; faltan caudal y restricciones agronómicas |
| Compliance | Documentación y trazabilidad parciales | Contratos, CDDL, origen, plantilla, evidencias y límites identificados | No constituye certificación ISO; faltan metadatos y tabla de clase; criterios sin medición siguen abiertos |

---

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

**Síntesis provisional del prototipo observado.** Se mantiene la sección del
template, pero **Lab 8 no se ha realizado**. Esta tabla no afirma integración
final, seguridad desplegada ni conexión Thread↔Internet.

| Pattern Element | Category | Your System |
|---|---|---|
| IoT System | Conjunto del prototipo | SoilSense de laboratorio: observación de temperatura y representación de control de riego |
| IoT Components | Hardware/software | ESP32-C6 y firmware Zephyr; DS18B20; LED; clientes y servicios por etapa |
| Digital Network | Red | Wi-Fi/IPv4 en Lab 0; Thread/6LoWPAN/IPv6 en Labs 1, 3 y 4; sin Border Router validado |
| IoT Devices | Dispositivos | S con sensor/LED y C como cliente; roles A/B usados en prácticas anteriores |
| Primary Capability (observation) | Transducer / sensing | Temperatura real DS18B20 desde Lab 4; simulada antes |
| Primary Capability (control) | Transducer / actuating | LED representa válvula; sin válvula física instalada |
| Secondary Capability (processing) | Data | JSON/CBOR, plausibilidad, edad, contadores y decisiones de respuesta |
| Secondary Capability (transferring) | Data | HTTP, pub/sub MQTT o GET/Observe/PUT CoAP según etapa |
| Secondary Capability (storage) | Data | NVS de ajustes; lectura/contadores/observadores en RAM; evidencias en Git |
| Interface (network) | Interface | Wi-Fi o 802.15.4/Thread según firmware |
| Interface (human UI) | Interface | CLI/serial y dashboards del Lab 0; dashboard integrado pendiente |
| Interface (application) | Interface | Contratos HTTP/MQTT y recursos CoAP/CBOR descritos en sección 4 |
| Supplemental (security) | Supporting | Protección de secretos en documentación; seguridad de aplicación pendiente de Lab 6 |
| Supplemental (orchestration) | Supporting | Operación manual mediante scripts/CLI; sin orquestación de sistema final |
| Supplemental (management) | Supporting | Configuración, roles, stats, logs y repositorio; sin plataforma de gestión completa |

### Documentos y fuentes

- [Plantilla DDR utilizada](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ae16e74895e1375ad0ff54ef7f691c8c94ae58d1/en/3_deliverables_template.md) y [arquitectura explicada por el curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ae16e74895e1375ad0ff54ef7f691c8c94ae58d1/en/2_iso_architecture.md).
- Registros locales: [HTTP](lab_http/evidencias/registro.md), [MQTT](lab_mqtt/evidencias/registro.md), [Lab 1](lab1/evidencias/registro.md), [Lab 2](lab2/evidencias/registro.md), [Lab 3](lab3/evidencias/registro.md), [Lab 4](lab4/evidencias/registro.md).
- Informes detallados: [Lab 3](lab3/INFORME.md) y [Lab 4](lab4/INFORME.md).
- [RFC 7252](https://www.rfc-editor.org/rfc/rfc7252), [RFC 7641](https://www.rfc-editor.org/rfc/rfc7641), [RFC 8949](https://www.rfc-editor.org/rfc/rfc8949), [RFC 8610](https://www.rfc-editor.org/rfc/rfc8610) y [RFC 6282](https://www.rfc-editor.org/rfc/rfc6282): CoAP, Observe, CBOR, CDDL y compresión 6LoWPAN.
- [ESP32-C6 datasheet](https://documentation.espressif.com/esp32-c6_datasheet_en.html) y [DS18B20 datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ds18b20.pdf): parámetros nominales y del modelo, distinguidos de mediciones locales.
