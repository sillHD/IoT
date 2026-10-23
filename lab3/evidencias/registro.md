# Evidencia — Lab 3 CoAP, C/S

**Estado:** C y S operativos con consola UART/CH343; red formada y GET de
temperatura/CBOR validados. Ventana Observe de 300 s registrada en S y recepción
contrastada en C y cancelación confirmada. Válvula funcional y timeout CON
confirmados; tiempo CON, NON y SED siguen pendientes.

## Sesión

- Fecha/lugar/integrantes: pendiente.
- C: modelo, capacidad flash, puerto y conector: pendiente.
- S: modelo, capacidad flash, puerto y conector: pendiente.
- Zephyr y commit IoT usados: pendiente.
- Potencia/canal reales C/S: 0 dBm / canal 25, confirmados por las consolas.
- Entorno, obstáculos/orientación: pendiente.
- Dataset compartido solo localmente y excluido de evidencias.

## Build, carga y red

| Actividad | Archivo | Resultado |
|---|---|---|
| Build USB | [Registro recibido](archivos/flash-C-usb-arranque-pendiente.txt) | Imagen disponible y cargada; CONFIG_FLASH_SIZE=4096, consola y shell en usb_serial |
| Flash C USB | [Carga y arranque](archivos/flash-C-usb-arranque-pendiente.txt) | 602352 bytes en 0x00000000, hash de escritura verificado; sin salida Zephyr después de entry 0x40800294 |
| Flash S | archivos/flash-S-usb.log o uart | Pendiente |

### Incidencia de arranque en C

El registro confirma escritura y verificación por esptool 5.3.1. Al reiniciar,
la ROM muestra un aviso SHA-256 y continúa hasta entry 0x40800294, sin salida
posterior de Zephyr. Este aviso también estuvo presente en arranques anteriores
que funcionaron; por sí solo no establece la causa del problema actual.
El usuario confirmó que observaba por CH343 mientras la imagen estaba configurada
para USB nativo. La versión UART posterior arrancó en C con Zephyr
v4.4.0-13610-g4564d775ab0b y los recursos CoAP listos. La comunicación C/S se
validó posteriormente con el [GET correcto](archivos/get-env-temp-C-S.txt).
El registro de la primera carga USB se conserva como historial de la incidencia.

| Placa | Rol inicial | ML-EID | Canal | TX (dBm) | Evidencia |
|---|---|---|---|---|---|
| C | leader | fd2c:525a:8ff2:2258:a81c:f3d:1e07:2a8b | 25 | 0 | [Resumen](archivos/red-C-S-resumen.txt) |
| S | child, después router | fd2c:525a:8ff2:2258:9966:43d2:59a9:c435 | 25 | 0 | [Resumen](archivos/red-C-S-resumen.txt) |

## Contratos de aplicación — ASD

| Recurso | Métodos | Request | Respuesta | Content-Format |
|---|---|---|---|---|
| /env/temp | GET, GET+Observe | Sin payload | CBOR {t: float16}, 6 B, 2.05 | 60 |
| /act/valve | PUT, GET | PUT CBOR {v:0/1}, o texto 0/1 sin Content-Format | CBOR {v:0/1}, 4 B; 2.04 PUT, 2.05 GET, 4.00 inválido | 60 en respuesta |

CDDL:

```text
env-reading = { t: float16 }
valve-state = { v: 0 / 1 }
```

Temperatura simulada; Max-Age 60 s; Observe con cambios >0.5 °C como NON y
heartbeat tras 45 s sin notificar como CON. Válvula simulada mediante LED blanco.

## GET y decodificación

- Hexadecimal recibido: `a16174f94e63` (6 bytes), confirmado en el log S; la salida C contenía un prefijo de consola no hexadecimal.
- Decodificación: A1 = mapa de un par; 61 74 = clave t; F9 4E 63 = float16 de 25.546875 °C. El helper confirmó el valor. El log S muestra 25.54 °C antes de cuantizar a float16.
- Tiempo GET ida/vuelta, método y resolución: pendiente.
- Request/response CoAP bytes del log S: 15 B / 17 B; código 2.05.
- Evidencias C/S: [GET y decodificación](archivos/get-env-temp-C-S.txt).

## Observe — cinco minutos

| Duración | Threshold inicio/fin/delta | Heartbeat inicio/fin/delta | Total notificaciones | GET a 1 Hz | Ratio 300/total |
|---|---|---|---|---|---|
| 300 s, ventana extraída del log S | 0/29/29 (inicio inferido del primer contador 1) | 0/0/0 | 29 generadas por S y registradas en C | 300 | ≈10.34 |

- Evidencia de S: [log original](archivos/observe-S-registro.txt), con 36 notificaciones completas y final truncado. No contiene cancelación ni la recepción en C.
- Suscripción aceptada en S a 00:11:34.006; ventana analizada hasta 00:16:34.006 (300 s).
- Las primeras 29 notificaciones caen en la ventana; la 29 aparece a 00:16:31.116 y la 30 a 00:16:36.122, fuera de ella.
- Todas son threshold/NON, de 19 B CoAP y 6 B CBOR incluidos en ese total. Total de notificaciones CoAP en la ventana: 551 B, sin sumar UDP/IPv6/MAC ni el registro inicial.
- Registro Observe inicial: request 16 B y response 19 B (incluye Observe); se distingue del GET normal de 15/17 B.
- Los 300 GET hipotéticos de polling son referencia; 300/29 ≈10.34 compara consultas con notificaciones, no consumo energético ni total de paquetes RF.
- Heartbeat 0 es coherente con cambios frecuentes; no hubo un intervalo de 45 s sin notificar dentro de la ventana.
- Recepción C: [transcripción estructurada](archivos/observe-C-recepcion.txt). OBS=2 es la respuesta inicial; OBS=3..40 son 38 notificaciones consecutivas. Las 29 de la ventana de 300 s corresponden a OBS=3..31; la correspondencia temporal se establece con el log S, porque C no incluye timestamps.
- No hay saltos en las secuencias aportadas; esto documenta la recepción de esa muestra, sin convertirla en una medición formal de PER ni de consumo.
- Cancelación posterior confirmada: C ejecutó `ot coap cancel` y S registró `(cancel)` con 2.05 a 00:29:47.864. [Evidencia](archivos/cancelacion-observe-y-timeout-CON.txt).

Conteo de notificaciones distinto de paquetes de radio: heartbeat CON puede
incluir ACK/reintentos. La suscripción completa duró 1093.858 s según los
timestamps de registro/cancelación en S; solo se usa la ventana inicial de 300 s
para la comparación.

## Válvula, idempotencia y rechazo

| Comando | Código/payload real | Log S | Estado LED | Evidencia |
|---|---|---|---|---|
| PUT CON 1 | 2.04; a1617601 = {v:1} | OPEN a 00:23:21.060 | No documentado | [C](archivos/valvula-C-apertura-repeticiones-rechazo.txt), [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |
| GET (dos consultas) | 2.05; a1617601 = {v:1} | OPEN a 00:24:00.447 y 00:25:01.146 | No documentado | [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |
| PUT CON 1 repetido (dos) | 2.04; a1617601 = {v:1} | OPEN, no change a 00:24:21.582 y 00:24:48.419 | No documentado | [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |
| PUT CON 0 + GET | 2.04 y 2.05; a1617600 = {v:0} | CLOSED a 00:27:11.060 (PUT) y 00:27:22.263 (GET) | No documentado | [C/S](archivos/valvula-C-S-cierre.txt) |
| PUT CON 7 | 4.00 según S; respuesta sin payload en C | Rechazo a 00:25:08.200 | No documentado | [C](archivos/valvula-C-apertura-repeticiones-rechazo.txt), [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |

- Cierre confirmado en la secuencia posterior: PUT 0 con 2.04 y GET cerrado con 2.05. Apertura/cierre, idempotencia y rechazo quedan documentados; no se aportó verificación visual del LED.
- Los comandos CoAP ejecutados localmente en S devolvieron InvalidState porque su cliente no está iniciado; los ensayos se ejecutan desde C. No iniciar el cliente en S para resolver ese error.
- Observe siguió activo durante la prueba de válvula y se canceló después, antes de detener Thread en S.

## CON/NON con servidor detenido

| Mensaje | Condición | Resultado | Tiempo/ventana observada | Evidencia |
|---|---|---|---|---|
| CON | S thread stop; rol disabled | Error 28: ResponseTimeout | No aportado; pendiente de cronometraje | [C/S](archivos/cancelacion-observe-y-timeout-CON.txt) |
| NON | S detenida | Pendiente | Esperar 120 s | |
| CON posterior | S reincorporada | Pendiente | | |

Predicción de timeout a partir de reintentos y contraste con lo medido: pendiente.

## SED y latencia

- mode/state/parent de S y ML-EID antes de medir: pendiente.
- Comando: ot ping <S-mleid> 16 10 1.3 64 40.

| Poll period (ms) | Rol/padre verificados | Enviados/recibidos | Pérdida (%) | RTT min/avg/max (ms) | Fracción ideal de sondeo (10 ms/T) |
|---|---|---|---|---|---|
| 1000 | Pendiente | | | | 1 % |
| 5000 | Pendiente | | | | 0.2 % |
| 15000 | Pendiente | | | | ≈0.0667 % |

Las fracciones son cálculos con la hipótesis de 10 ms por sondeo, no medidas de
radio/consumo. Copiar pérdidas reales, sin sustituirlas por valores esperados.

## PUT con SED a cinco segundos

- Comando y respuesta C: pendiente.
- PUT observados en logs S, tiempos y no change: pendiente.
- Explicación de reintentos/deduplicación/idempotencia: pendiente según resultados.

## Presupuesto de bytes

| Intercambio | Request CoAP B | Response/notify CoAP B | Paquetes básicos | Evidencia |
|---|---|---|---|---|
| GET /env/temp | 15 | 17 | 2 según intercambio de aplicación, sin captura RF | [GET](archivos/get-env-temp-C-S.txt) |
| Observe NON | — | 19 | 1 datagrama previsto, sin captura RF | [S](archivos/observe-S-registro.txt) |
| PUT /act/valve CON válido | 18 | 13 (incluye CBOR 4 B) | 2 con ACK piggyback, sin captura RF | [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |
| GET /act/valve | 16 | 13 (incluye CBOR 4 B) | 2 previstos, sin captura RF | [S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) |

Añadir UDP 8 B y estimación IPv6/6LoWPAN aparte. Los totales CoAP incluyen el CBOR.
Comparación HTTP/MQTT: citar Lab 0 y distinguir valores orientativos de mediciones.
Ajuste a una trama 802.15.4: indicar hipótesis o captura si se realiza.

## Energía — estimación

- Fuente ESP32-C6, revisión/tabla/condiciones: pendiente.
- I_RX e I_sueño en mA: pendiente.
- Capacidad AA asumida y conexión de dos pilas (en serie no se suman mAh): pendiente.
- Periodo elegido e hipótesis 10 ms de radio por sondeo: pendiente.
- I_media = (0.010/T)*I_RX + (1-0.010/T)*I_sueño.
- Vida ideal en horas = capacidad_mAh / I_media_mA.
- Consumo del resto de la placa, LED, USB, logs y procesamiento: fuera de esta
  estimación simplificada; no confundir radio rx-off con sueño profundo del SoC.

## Decisiones y preguntas

- ADR-003: CoAP/CBOR frente a alternativas, usando los bytes observados: pendiente.
- ADR-004: periodo de sondeo, latencia y energía estimada: pendiente.
- UDP, CON/NON; Observe frente a polling; PUT idempotente frente a toggle;
  CBOR/CDDL y evolución del contrato: respuestas pendientes.
- ISO/IEC 30141: contratos y patrones CoAP en ASD; Thread/UDP y sondeo SED en
  subsistema de comunicación SCD. Completar explicación con la práctica.

## Seguridad y comunicación

- Diseño ante OPEN sin CLOSE: política local, duración máxima y estado seguro
  propuestos con justificación; pendiente. Esta política no está implementada en
  el firmware de prácticas y no debe presentarse como validada.
- Resumen para Edwin (tres líneas): confirmación, indisponibilidad y latencia: pendiente.

## Índice y cierre

| Archivo | Qué demuestra |
|---|---|
| [GET C/S](archivos/get-env-temp-C-S.txt) | Primera lectura de temperatura, payload CBOR y tamaños |
| [Red C/S](archivos/red-C-S-resumen.txt) | Roles, ML-EID, canal y potencia, sin dataset |
| [Observe S](archivos/observe-S-registro.txt) | Notificaciones emitidas y ventana de 300 s |
| [Observe C](archivos/observe-C-recepcion.txt) | OBS=2 inicial y notificaciones OBS=3..40; cancelación pendiente |
| [Válvula C](archivos/valvula-C-apertura-repeticiones-rechazo.txt) | Apertura, repetición y respuesta al inválido; cierre pendiente |
| [Válvula S](archivos/valvula-S-apertura-repeticiones-rechazo.txt) | 2.04, 2.05, no change, 4.00 y bytes medidos |
| [Cierre C/S](archivos/valvula-C-S-cierre.txt) | PUT 0 y GET confirman CLOSED y CBOR {v:0} |
| [Cancelación y CON](archivos/cancelacion-observe-y-timeout-CON.txt) | Observe cancelado y timeout con S disabled; tiempo CON pendiente |

- [ ] Restaurar S: mode rdn y pollperiod 0.
- [ ] Cerrar y consultar válvula.
- [ ] Detener Thread y bajar interfaz en ambas.
- [ ] Revisar evidencias sin dataset/claves y vincularlas aquí.
