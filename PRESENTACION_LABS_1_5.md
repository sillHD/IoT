# Presentación de los Labs 1–5 sin reflashear entre prácticas

> **Propuesta reemplazada.** El equipo presentará solo el Lab 5. Usa
> [`lab5/PRESENTACION.md`](lab5/PRESENTACION.md) para el resumen contextual,
> flasheo y diálogo actualizados.

Esta configuración conserva las etiquetas y funciones físicas:

| Etiqueta | Placa | Función durante las demostraciones |
|---|---|---|
| **C** | ESP32-C6 | Cliente Thread/CoAP; en Labs 1–2 sirve como A |
| **S** | ESP32-C6 + DS18B20 en GPIO18 | Nodo servidor; en Labs 1–2 sirve como B |
| **RCP** | Tercera ESP32-C6 | Radio 802.15.4 por Spinel para el Border Router |
| **S3** | ESP32-S3 N16R8 | Wi-Fi, Border Router y NAT64 en Lab 5 |

> “S4” se entiende como S3, el modelo indicado para la placa Border Router.

## Firmware preparado

C y S usarán el mismo código de aplicación OpenThread/CoAP del Lab 5. S se
compila con el overlay del DS18B20; C se compila sin sensor. En la versión
actualizada, S puede apagar el muestreo (Labs 1–2), seleccionar en ejecución la
temperatura simulada de Lab 3 o leer el DS18B20 real de Labs 4–5. C puede
apagar su fuente simulada cuando actúa como cliente. La CLI OpenThread que ya está habilitada cubre
escaneo/radio de Lab 1 y formación/direcciones/ping de Labs 2–5.

RCP y S3 mantienen sus firmwares dedicados del Lab 5. El RCP es un coprocesador
de radio y no ejecuta la aplicación C/S. En total se preparan cuatro imágenes,
una por placa, y se cargan antes de la exposición. Cambiar de laboratorio no
requiere reflashear; sí puede requerir reiniciar Thread o cambiar de dataset,
potencia, sensor simulado/real y alimentación del BR.

## Preparación y carga única

En WSL, actualizar IoT y compilar las imágenes que cambiaron:

```bash
cd ~/IoT
git pull --ff-only
bash lab5/tools/build.sh S uart
bash lab5/tools/build.sh C uart
```

Cierra monitores, conecta cada placa sola, identifica su puerto y carga una vez:

```bash
bash lab5/tools/flash.sh S PUERTO_S uart
bash lab5/tools/flash.sh C PUERTO_C uart
```

RCP y S3 ya tienen las imágenes del Lab 5, así que se conservan si siguen
funcionando. Solo habría que cargar `RCP` o `BR N16R8` si se borró o cambió su
firmware. El entorno de build debe coincidir con `ZEPHYR_WORKSPACE` configurado
en `common.sh`.

Con S y C arrancadas, comprueba que la aplicación informa CoAP/Thread y que S
reconoce `ds18b20`. En S ejecuta:

```text
soilsense stats
```

## Recorrido en orden

### Lab 1 — Radio y canales

Primero, en S y C desactiva la tarea de muestra para reducir carga no
necesaria durante la caracterización:

```text
soilsense source off
```

Después de dejar Thread detenido, muestra el escaneo en una de ellas:

```text
ot ifconfig up
ot scan energy 500
```

El escaneo histórico mostró −104 dBm en los canales 21, 24 y 25; se eligió 25.
Para explicar la medición ya documentada, muestra la tabla RSSI/PER de 1, 5, 10
y 15 m y aclara que la línea de visión estaba parcialmente obstruida. A 15 m se
observó pérdida casi total y se detuvo el ensayo. No afirmar alcance máximo.

Las sesiones históricas no tuvieron idénticas condiciones: la referencia de
1 m fue a 0 dBm y las medidas de 5–15 m a 20 dBm. Para una demo breve en vivo,
forma una red con canal 25 y muestra un ping corto a distancia cercana; no lo
presentes como repetición de toda la tabla. El ping en vivo es una demostración,
no sustituye los resultados ya registrados.

### Lab 2 — Red de dos nodos

En el escenario, C representa A (líder) y S representa B (router/child). Con
dos placas se puede mostrar el dataset local, los roles, IPv6 y ping de un salto.
El firmware ya contiene CLI para hacerlo:

```text
# En ambas, empezar con red limpia (solo al iniciar esta práctica)
ot factoryreset
# Tras el reinicio, en las dos placas:
soilsense source off
```

En C/A crea la red con potencia 0 dBm y canal 25:

```text
ot txpower 0
ot dataset init new
ot dataset channel 25
ot dataset commit active
ot ifconfig up
ot thread start
ot state
```

Cuando A/C sea leader, obtiene su dataset localmente y lo copia a B/S sin
mostrarlo en la grabación:

```text
ot dataset active -x
```

En S/B:

```text
ot txpower 0
ot dataset set active HEX_COPIADO_DE_A
ot ifconfig up
ot thread start
ot state
```

Consulta las ML-EID actuales (`ot ipaddr mleid`) y mide el ping en ambos sentidos.
Registra roles, `ot channel`, `ot txpower`, `ot ipaddr` y `ot neighbor table`.

El procedimiento está preparado, pero el registro de IoT no contiene mediciones
experimentales propias de Lab 2. La exposición debe decir que esta es una
demostración en vivo nueva, si la ejecutan. Dos nodos no demuestran forwarding
A→B→C ni recuperación por ruta alternativa; para eso hace falta una tercera
placa de aplicación, distinta del RCP dedicado al BR.

### Lab 3 — CoAP/CBOR con temperatura simulada

Mantén C como cliente y S como servidor en la misma red Thread. En S selecciona
la fuente simulada y espera una muestra nueva; en C, apaga el muestreo:

```text
soilsense source simulated
soilsense stats
# En C:
soilsense source off
```

En C inicia el cliente CoAP y consulta la ML-EID actual de S:

```text
ot coap start
ot coap get ML_EID_S env/temp con
ot coap observe ML_EID_S env/temp
ot coap put ML_EID_S act/valve con 1
ot coap get ML_EID_S act/valve
ot coap put ML_EID_S act/valve con 0
```

Muestra también `act/valve` con PUT y GET; el LED representa el estado lógico,
no una válvula física. El informe registra 29 notificaciones por umbral en 300 s, respuestas CoAP
válidas e idempotencia del PUT. La fuente se selecciona por comando:
`soilsense source off` para Labs 1–2, `soilsense source simulated` para Lab 3 y
`soilsense source ds18b20` para Labs 4–5. No hay que reflashear.

### Lab 4 — DS18B20 real y frescura

En S cambia a la fuente física y espera la siguiente lectura; en C, apaga el
muestreo si sigue activo:

```text
soilsense source ds18b20
soilsense stats
# En C:
soilsense source off
```

Verifica el sensor conectado a GPIO18 con 3V3, GND y pull-up de 4,7 kΩ entre
DATA y 3V3. Muestra `ot coap get` desde C, `ot coap observe` y los resultados de
frescura registrados: edad/Max-Age decrecientes y 5.03 cuando la lectura deja
de ser fresca.

El modo físico es el predeterminado en la imagen S; el comando deja explícito
el modo de la demo y reinicia los contadores para que no se mezclen lecturas de
fuentes diferentes. No afirmar calibración: faltó referencia independiente.

### Lab 5 — Border Router

Enciende el RCP y después la S3. Conecta UART cruzado (S3 GPIO5 TX→RCP GPIO4 RX;
S3 GPIO4 RX←RCP GPIO5 TX; GND común). No alimentar una placa desde la otra.
Conecta S3 al Wi-Fi y crea la red BR. C y S adoptan el mismo dataset, obtenido
localmente desde S3; no mostrar ni guardar el secreto. Comprueba BR, OMR y NAT64.

Muestra el GET CoAP PC→S, dashboard y una solicitud NAT64. Resultados ya
registrados incluyen 10/10 GET (mediana 33 ms), 10/10 pings NAT64 (media 53 ms)
y control interno C→S cuando el BR se apagó. La restauración del acceso PC fue
manual; no se midió el tiempo de recuperación.

## Curiosidades y problemas que vale la pena contar

- Lab 1: el escaneo tuvo empate entre tres canales; el RSSI no siguió una curva
  simple por la línea de visión parcialmente obstruida y las diferentes sesiones
  de potencia.
- Lab 2: dos dispositivos bastan para el enlace directo, pero no para probar
  reenvío por un tercero o ruta de respaldo; además, sus mediciones históricas
  quedaron pendientes.
- Lab 3: Observe envía cambios sin polling constante; un `Done` de NON solo
  confirma que la CLI aceptó el envío. El LED simula la válvula.
- Lab 4: el sensor puede fallar mientras el nodo sigue conectado. La lectura
  caduca; filtros razonables no sustituyen una referencia de calibración.
- Lab 5: el BR es el camino del PC hacia Thread. Al apagarlo se perdió acceso
  externo, mientras C y S mantuvieron control local. La restauración requirió
  intervención manual.

## Límites de la demostración

El firmware común reduce reflasheos, pero cada modo debe seleccionarse y
verificarse durante el ensayo. Pruebas nuevas en vivo se registran como tales,
separadas de las mediciones anteriores. Antes de la exposición hay que compilar
y cargar S/C con esta revisión y comprobar el comando `soilsense source`; esa
compilación física aún no se ha realizado aquí. Mantén el dataset y la contraseña
Wi-Fi fuera de capturas, transcripciones y Git.
