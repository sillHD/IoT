# Evidencia — Lab 2: Thread Mesh

**Estado:** firmware y procedimiento preparados; pendiente de ejecución física.
No hay resultados experimentales de Lab 2 registrados todavía.

## Sesión

- Fecha y lugar: pendiente.
- Integrantes: pendiente.
- Modelo y capacidad de flash de A/B/C: pendiente.
- Puertos reales y conector de cada placa: pendiente.
- Zephyr (`git -C ~/zephyrproject/zephyr rev-parse HEAD`): pendiente.
- Commit de IoT usado para compilar: pendiente.
- Canal previsto: 25; lectura real en las tres: pendiente.
- Potencia prevista: 0 dBm; salida de `ot txpower` en A/B/C: pendiente.
- Posición/obstáculos/orientación: pendiente.
- Dataset compartido localmente; no guardar la clave ni el hexadecimal en Git.

## Compilación y carga

| Actividad | Evidencia prevista | Resultado |
|---|---|---|
| Build USB o UART | archivos/build-usb.log o build-uart.log | Pendiente |
| Flash A | archivos/flash-A-usb.log (o uart) | Pendiente |
| Flash B | archivos/flash-B-usb.log (o uart) | Pendiente |
| Flash C | archivos/flash-C-usb.log (o uart) | Pendiente |
| Estados y red de tres routers | Arranque y ot state/router table | Pendiente |

## Direcciones

| Placa | Rol | ML-EID | RLOC | RLOC16 | Router ID | Extaddr | Link-local |
|---|---|---|---|---|---|---|---|
| A | Pendiente | | | | | | |
| B | Pendiente | | | | | | |
| C | Pendiente | | | | | | |

| Tipo | Identificación | Alcance/uso |
|---|---|---|
| Link-local | fe80::/64 | Un enlace; comunicación entre vecinos |
| RLOC | Prefijo mesh-local + 0:ff:fe00:RLOC16 | Localizador de encaminamiento; puede cambiar |
| ALOC | Prefijo mesh-local + 0:ff:fe00:fcXX | Función/servicio; fc00 representa al líder |
| ML-EID | ot ipaddr mleid | Identidad del dispositivo dentro de la malla; usada en los pings |

- Derivación extaddr → IID link-local: pendiente con valores reales;
  primer byte XOR 0x02 (bit U/L).
- Derivación RLOC16 → Router ID: pendiente con valores reales; RLOC16 >> 10.
- Grupos encontrados con ot ipmaddr y su alcance: pendiente.

## Prueba del reenvío por B

| Condición | TxUnicast en B tras reset y ping A→C | Next Hop hacia C en A | Evidencia |
|---|---|---|---|
| Sin filtros | Pendiente | Pendiente | Pendiente |
| A/C con LQ directa fijada a 1 | Pendiente | Pendiente | Pendiente |

Registra tablas y valores reales. Los contadores pueden incluir tráfico de control.

## RTT y pérdida

| Trayecto | Saltos verificados | RTT min/avg/max (ms) | Enviados/recibidos | Pérdida (%) | Evidencia |
|---|---|---|---|---|---|
| A→B | 1 | Pendiente | | | |
| A→C mediante B | 2 | Pendiente | | | |
| Referencia Lab 1 | 1 | Pendiente de elegir sesión comparable | | | |

- Incremento de RTT promedio (2 saltos menos 1 salto): pendiente.
- Intervalo/tamaño: 0.5 s / 64 bytes / 20 pings por trayecto.
- Resolución inicial de dirección u otras incidencias observadas: pendiente.

## Recuperación al desconectar B

| Ensayo | Momento del corte | Primera respuesta recuperada | Pings perdidos | Interrupción (s) | Ruta posterior | ¿Menor de 120 s? |
|---|---|---|---|---|---|---|
| 1 | Pendiente | | | | | |
| 2 | Pendiente | | | | | |
| 3 | Pendiente | | | | | |

Un ping por segundo, 200 pings. Diferenciar pérdidas ajenas al corte. Guardar
tablas antes/después y confirmar el retorno al reenvío por B antes del siguiente ensayo.

## ADR-002 — Topología

- Contexto: comparar malla Thread con una estrella tipo LoRaWAN para el escenario del curso.
- Decisión: pendiente de completar con las mediciones.
- Alternativas y criterios: saltos, latencia, recuperación, infraestructura y consumo.
- Evidencia: completar con RTT, contadores y tres ensayos.
- Consecuencias: pendiente.

## ISO/IEC 30141 y roles

La malla, sus routers y enlaces forman el subsistema de comunicación del SCD.
La ML-EID permite a los servicios del ASD identificar nodos dentro de la malla.

| Rol | Función | Implicación de energía |
|---|---|---|
| Leader | Funciones de router y coordinación (IDs de router/datos de red) | Receptor activo |
| Router | Reenvía paquetes | Receptor activo |
| REED | Dispositivo final elegible para convertirse en router | Capacidad de asumir el trabajo de router |
| End device | Hoja que usa un padre | No reenvía paquetes de otros nodos |
| Sleepy end device | Hoja que duerme y consulta a su padre | Puede apagar el receptor entre consultas |

Efecto sobre la meta de tres meses con batería: pendiente de análisis;
no asumir que un router con receptor activo consume como un SED.

## Preguntas del informe

1. Compresión IPHC/contexto/IID y fragmentación 6LoWPAN: pendiente.
2. Detección de fallo por MAC ACK/MLE frente al envejecimiento sin tráfico: pendiente.
3. Por qué se conserva un enlace A↔C pobre y qué ocurriría al bloquearlo: pendiente.
4. Opcional, efecto de un cambio de RLOC comparado con ML-EID: pendiente.

## Resumen para Edwin — tres líneas

Pendiente: recuperación medida; cumplimiento de <120 s; comprobaciones ante un nodo caído.

## Resumen para Samuel — tres líneas

Pendiente: incremento de RTT por salto; dirección usada por la aplicación; motivo.

## Índice de archivos

| Archivo | Qué demuestra |
|---|---|
| Pendiente | Añadir enlaces a logs/capturas reales tras ejecutar |

## Cierre

- [ ] Limpiar filtros en A/C.
- [ ] Detener Thread y bajar interfaz en las tres placas.
- [ ] Revisar logs/capturas para excluir dataset/claves.
- [ ] Completar las tablas con datos reales y vincular evidencias.
