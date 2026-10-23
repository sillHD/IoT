# Evidencia — Lab 3 CoAP, C/S

**Estado:** imagen USB generada y carga de C verificada; arranque de la aplicación
pendiente de diagnóstico. La carga de S y las pruebas CoAP siguen pendientes.

## Sesión

- Fecha/lugar/integrantes: pendiente.
- C: modelo, capacidad flash, puerto y conector: pendiente.
- S: modelo, capacidad flash, puerto y conector: pendiente.
- Zephyr y commit IoT usados: pendiente.
- Potencia/canal reales C/S: pendiente (previstos 0 dBm/canal 25).
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
La causa sigue sin confirmar. Siguiente comprobación propuesta: compilar con
consola UART y observar por el conector CH343, para distinguir un fallo de
inicialización de la aplicación de un problema con la salida USB.

| Placa | Rol inicial | ML-EID | Canal | TX (dBm) | Evidencia |
|---|---|---|---|---|---|
| C | Pendiente | | | | |
| S | Pendiente | | | | |

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

- Hexadecimal recibido: pendiente.
- Decodificación manual y helper: pendiente.
- Tiempo GET ida/vuelta, método y resolución: pendiente.
- Request/response CoAP bytes del log S: pendiente.
- Evidencias C/S: pendiente.

## Observe — cinco minutos

| Duración | Threshold inicio/fin/delta | Heartbeat inicio/fin/delta | Total notificaciones | GET a 1 Hz | Ratio 300/total |
|---|---|---|---|---|---|
| Pendiente | | | | 300 si duración=300 s | |

Conteo de notificaciones distinto de paquetes de radio: heartbeat CON puede
incluir ACK/reintentos. No asumir contadores iniciales cero.

## Válvula, idempotencia y rechazo

| Comando | Código/payload real | Log S | Estado LED | Evidencia |
|---|---|---|---|---|
| PUT CON 1 | Pendiente | | | |
| GET | Pendiente | | | |
| PUT CON 1 repetido | Pendiente | | | |
| PUT CON 0 + GET | Pendiente | | | |
| PUT CON 7 | Pendiente | | | |

## CON/NON con servidor detenido

| Mensaje | Condición | Resultado | Tiempo/ventana observada | Evidencia |
|---|---|---|---|---|
| CON | S thread stop | Pendiente | | |
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
| GET /env/temp | Pendiente | | 2 | |
| Observe NON | — | Pendiente | 1 | |
| PUT /act/valve CON | Pendiente | | 2 con ACK piggyback | |

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
| Pendiente | Añadir logs/capturas reales al ejecutar |

- [ ] Restaurar S: mode rdn y pollperiod 0.
- [ ] Cerrar y consultar válvula.
- [ ] Detener Thread y bajar interfaz en ambas.
- [ ] Revisar evidencias sin dataset/claves y vincularlas aquí.
