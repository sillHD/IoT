# Presentación del Lab 5 — Border Router

Esta es la guía para exponer **solo el Lab 5**. El Lab 5 integra conceptos que
aparecieron en los Labs 1–4; el resumen inicial ayuda a explicar esa relación,
pero no implica repetir ni declarar como nuevas las pruebas anteriores.

## Placas y función

| Etiqueta usada en la exposición | Placa | Función |
|---|---|---|
| **S4** | ESP32-S3 N16R8 | Border Router: enlaza Thread con Wi-Fi y ofrece NAT64. |
| **RCP** | ESP32-C6 adicional | Radio 802.15.4 controlada por S4 mediante Spinel. No tiene shell de usuario. |
| **S** | ESP32-C6 con DS18B20 en GPIO18 | Sensor y servidor CoAP `/env/temp`; la válvula se representa con el LED. |
| **C** | ESP32-C6 sin sensor | Cliente Thread/CoAP y punto de control. |

En los scripts, **S4 se llama `BR`**. Hay cuatro imágenes, una para cada placa.

Para esta configuración, S, C y S4 usan consola UART por CH343; RCP no ofrece
consola. En S4 el shell sale por UART0 (GPIO43 TX/GPIO44 RX). Para flashear RCP
se puede usar su USB nativo o CH343. Verifica qué puerto enumera cada conexión
antes de usar `west flash` o abrir un monitor.

## Resumen oral de los Labs 1–5

| Lab | Tema y aprendizaje | Relación con Lab 5 |
|---|---|---|
| **1 — Radio** | Se exploró IEEE 802.15.4, escaneo de energía, RSSI y pérdida de paquetes. El canal 25 se eligió entre los canales con menor energía. A 15 m se registró 96–98 % de pérdida; la línea de visión no estuvo completamente despejada. | Lab 5 usa esa radio 802.15.4 para transportar Thread; la antena y el enlace siguen siendo la base de la comunicación. |
| **2 — Red de nodos** | Se estudian la formación de red Thread, roles como leader/router/child, direcciones IPv6 y comunicación entre nodos. La adaptación documentada con dos placas permite explicar el enlace de un salto; las pruebas de dos saltos y ruta alternativa quedaron pendientes de una tercera placa de aplicación. | Lab 5 amplía la red Thread y conecta sus nodos a otra red mediante el Border Router. |
| **3 — CoAP** | C consulta temperatura y cambia el estado lógico de una válvula usando CoAP y CBOR. Observe notifica cambios sin consultar continuamente; el LED representa la válvula. | Lab 5 conserva CoAP/CBOR y hace posible consultar y observar el nodo desde el PC o el teléfono. |
| **4 — Sensor y confianza del dato** | El DS18B20 entrega lecturas reales. Se trataron fallas de sensor, valores rechazados y frescura: un dato viejo debe identificarse como viejo y no presentarse como actual. No se logró una calibración con una referencia independiente confiable. | Lab 5 integra la lectura real de S en el servicio al que llega el PC a través del Border Router. |
| **5 — Integración** | S y C forman la red Thread; S4, junto con RCP, enlaza Thread y Wi-Fi. Se verificaron CoAP desde el PC, dashboard, NAT64 y control local C→S cuando el Border Router no estaba disponible. | Integra radio, red, aplicación y sensor en un sistema completo. |

**Precisión sobre Lab 2:** en el repositorio la adaptación para dos nodos está
preparada, pero su compilación/carga y registro experimental siguen marcados
como pendientes. Presenten los conceptos y distingan claramente esa preparación
de las pruebas que sí se ejecutaron.

## Preparación y flasheo

### Antes de empezar

1. Usar el PC con WSL donde están Zephyr y `west` para compilar y flashear. El PC
   de Henao puede ejecutar el cliente/dashboard con Python, aunque no tenga
   Zephyr. Para abrir ahí el monitor serial de C, solo necesita las herramientas
   Python del repo:

   ```bash
   cd ~/IoT
   bash lab5/tools/setup_host.sh
   bash lab5/tools/monitor.sh C /dev/ttyACM0
   ```

   Sustituye `/dev/ttyACM0` por el puerto actual. Esto no instala ni prepara Zephyr.
2. Cerrar monitores seriales y conectar **una placa a la vez** al PC de flasheo.
   Identificar el puerto actual después de cada conexión; no asumir que conserva
   el mismo `/dev/ttyACM*`.
3. Tener S4 identificada como ESP32-S3 N16R8 y RCP como la tercera ESP32-C6.
   No intercambiar sus firmwares. Para la consola de S4 usa su conector CH343;
   su USB nativo Serial/JTAG puede reenumerarse al reset y no es el shell UART0.
4. Mantener el DS18B20 conectado a S: VDD a 3V3, GND común, DATA a GPIO18 y
   pull-up de 4.7 kΩ entre DATA y 3V3.

### Compilar

Los scripts usan el workspace aislado `~/zephyrproject-lab5` fijado a la
revisión del curso. Desde `~/IoT`:

```bash
cd ~/IoT
bash lab5/tools/prepare_workspace.sh  # solo si todavía no existe el workspace
bash lab5/tools/build.sh S uart
bash lab5/tools/build.sh C uart
```

La revisión reciente incorporó el selector de fuente en la aplicación C/S.
**Compilar y flashear S y C es el paso pendiente antes de la presentación.**
RCP y S4 ya tuvieron carga y verificación funcional; no hace falta reconstruirlos
si conservan esas imágenes. Si hay que restaurarlos, compila también:

```bash
bash lab5/tools/build.sh RCP
bash lab5/tools/build.sh BR N16R8
```

Cada compilación debe terminar con `Successfully created...` y el script guarda
un log y comprueba target/configuración. No se debe flashear si falla el build.

### Flashear solo lo que cambió

Cierra el monitor del puerto y usa el nombre real de cada dispositivo. Sustituye
los marcadores sin escribir los signos `< >`:

```bash
bash ~/IoT/lab5/tools/flash.sh S <PUERTO_S> uart
bash ~/IoT/lab5/tools/flash.sh C <PUERTO_C> uart
```

Para una placa que necesite restauración:

```bash
bash ~/IoT/lab5/tools/flash.sh RCP <PUERTO_RCP>
bash ~/IoT/lab5/tools/flash.sh BR <PUERTO_S4> N16R8
```

Confirma `Hash of data verified` o la verificación equivalente de `west flash`,
y luego el arranque de cada placa. En S debe aparecer `sensor: ds18b20` y una
lectura válida en `soilsense stats`; si aparece `No 1-Wire slaves connected`,
detén la demo de sensor y revisa el cableado antes de seguir.

### Montar S4 con RCP

Con ambas desconectadas de USB, conecta:

| S4 | RCP |
|---|---|
| GPIO5 TX | GPIO4 RX |
| GPIO4 RX | GPIO5 TX |
| GND | GND |

No conectes los pines de alimentación entre placas: cada una usa su propio USB.
Al encender, alimenta RCP antes o junto con S4. La UART Spinel va a 460800
baudios; la consola de S4 usa otro puerto/configuración. Verifica desde S4 con
`ot rcp version` y `ot version`.

## Demostración del Lab 5, en orden

### 1. Arranque del Border Router

Enciende S y C. Enciende RCP antes o junto con S4. En la consola de S4 verifica
la PSRAM y la comunicación con RCP. Conecta S4 a la Wi-Fi local usando las
credenciales localmente; no las incluyas en capturas, texto ni Git:

```text
wifi connect -s "SSID_LOCAL" -p "CLAVE_LOCAL" -k 1
wifi status
```

Si es la primera configuración de esa red, crea el dataset Thread desde S4:

```text
ot dataset init new
ot dataset channel 25
ot dataset networkname SoilSense-IC-DH
ot dataset commit active
ot ifconfig up
ot thread start
```

Espera a que Thread esté activo y comprueba:

```text
ot state
ot br state
ot nat64 state
ot br omrprefix
ot netdata show
```

Guarda el dataset fuera del repo para reutilizarlo localmente si S4 se reinicia.
El estado de red del firmware actual de S4 se conserva en RAM: tras reiniciar
puede ser necesario conectar de nuevo Wi-Fi y restaurar el mismo dataset. No
ejecutes `ot dataset init new` durante una restauración, porque crearía otra red.

### 2. Incorporar S y C

Si S/C aún guardan otra red, haz `ot factoryreset` en ellas y espera el reinicio.
Después, en cada una, introduce localmente el dataset de S4:

```text
ot dataset set active <DATASET_GUARDADO_LOCALMENTE>
ot ifconfig up
ot thread start
ot state
ot ipaddr
ot txpower
```

El dataset contiene la clave Thread: no lo leas en voz alta ni lo captures.
Espera a que S/C entren a la red. Anota sus direcciones actuales y roles; no
reutilices las direcciones de ensayos anteriores.

En S:

```text
soilsense source ds18b20
soilsense stats
```

Comprueba lectura válida antes de continuar. En C:

```text
ot coap start
ot ping <S_MLEID> 16 10 1
```

El ping demuestra comunicación local Thread C→S.

### 3. Acceso desde el PC y CoAP

Obtén la dirección OMR vigente de S, prefijo OMR y dirección Wi-Fi de S4. En el
PC conectado a la misma Wi-Fi, verifica primero la ruta IPv6 hacia `<S_OMR>` y
el ping. Si el PC es Windows, el PC de Henao puede usar el entorno Python local;
no depende de Zephyr. Si se necesita ruta manual, se configura para la sesión
usando las direcciones reales de S4 y el adaptador Wi-Fi.

Cliente CoAP desde Windows:

```powershell
.\.venv\Scripts\python.exe coap_client.py --host <S_OMR> --count 10 get /env/temp
```

La evidencia previa dio 10/10 respuestas `2.05 Content`, RTT mediano 33 ms
(mínimo 30, máximo 49 ms). No se debe prometer que la ejecución nueva repetirá
exactamente los mismos tiempos.

### 4. Dashboard y control

Desde PowerShell en la carpeta del cliente de Henao, inicia el dashboard:

```powershell
.\.venv\Scripts\python.exe dashboard_coap.py --host <S_OMR>
```

Abre el dashboard en ese PC y, si la red/firewall lo permiten, en el celular con
la IPv4 Wi-Fi del PC. CoAP Observe informa cambios de temperatura. Acciona OPEN y
CLOSE desde el dashboard y confirma estado con GET/logs de S. El LED solo
representa la válvula; no hay una válvula hidráulica conectada.

El dashboard móvil y el control LED se confirmaron previamente. La confirmación
móvil fue verbal; no hay captura móvil original archivada en el repo.

### 5. NAT64 y dependencia del Border Router

En S, prueba el destino IPv4 usando la traducción NAT64 que publica S4:

```text
ot ping 8.8.8.8
```

El Border Router sintetiza una dirección IPv6 para alcanzar un destino IPv4.
En la evidencia previa hubo 10/10 respuestas, RTT medio 53 ms.

Si se desea mostrar la dependencia, apaga S4/RCP de forma controlada y deja S/C
alimentadas. Se espera que falle el acceso del PC al OMR mientras el control
local C→S puede seguir funcionando. En la sesión previa, Windows obtuvo
`NetworkError` y el equipo confirmó control local por LED. Restaura RCP antes o
junto con S4; vuelve a conectar Wi-Fi, restaura el mismo dataset si hace falta y
verifica de nuevo OMR y GET. La recuperación histórica fue manual; no se midió
un tiempo de recuperación automática.

## Diálogo sugerido para Ismael y Henao

Se puede acortar según el tiempo disponible. Las acciones nuevas se presentan
como demostración en vivo; las cifras siguientes son resultados anteriores.

### 1. Apertura y arquitectura

**Ismael:** “Vamos a presentar el Laboratorio 5. Su objetivo es conectar una red
Thread de sensores con una red Wi-Fi usando un Border Router, y poder acceder al
sensor desde un PC y un celular.”

**Henao:** “El montaje tiene cuatro placas: S mide temperatura; C es el cliente;
RCP aporta la radio 802.15.4; y S4, una ESP32-S3, ejecuta el Border Router. La
S3 y el RCP están unidos por UART.”

**Ismael:** “S4 es el puente entre dos redes distintas. RCP no es otro servidor:
es la radio controlada por la S3. S y C siguen comunicándose por Thread.”

### 2. Conexión y red Thread

**Henao:** “Primero comprobamos alimentación, UART cruzada y tierra común entre
S4 y RCP. Luego revisamos el arranque de la S3 y consultamos `ot rcp version`;
eso confirma que la S3 puede hablar con el coprocesador de radio.”

**Ismael:** “Conectamos S4 a Wi-Fi y activamos Thread. Revisamos `ot state`,
`ot br state`, `ot nat64 state` y el prefijo OMR. El prefijo OMR es la ruta IPv6
que permite al PC alcanzar el nodo Thread.”

**Henao:** “Después unimos S y C al mismo dataset, sin mostrar la clave en la
grabación. Revisamos sus roles, canal, potencia y direcciones actuales.”

### 3. Sensor y CoAP

**Ismael:** “En S confirmamos que el DS18B20 está leyendo y consultamos sus
estadísticas. Si el sensor no aparece, no fingimos una medición: revisamos DATA,
3.3 voltios, tierra y la resistencia pull-up.”

**Henao:** “C hace un ping a S para comprobar el enlace Thread local. Luego el PC
hace un GET CoAP a `/env/temp`. CoAP es un protocolo ligero de solicitud y
respuesta; CBOR codifica la temperatura en pocos bytes.”

**Ismael:** “En nuestras pruebas anteriores, el PC recibió 10 de 10 respuestas
CoAP `2.05 Content`; la mediana fue 33 milisegundos. Estos son datos de una
sesión previa, no una garantía para cada ejecución.”

### 4. Dashboard

**Henao:** “El dashboard usa CoAP Observe para recibir cambios de temperatura,
en lugar de consultar el nodo constantemente. Desde aquí también enviamos OPEN y
CLOSE.”

**Ismael:** “El LED de S muestra el estado lógico de la válvula. Es una
representación del actuador, no una válvula real. El dashboard en el celular y
el encendido/apagado del LED se confirmaron en el ensayo.”

### 5. NAT64 y prueba de dependencia

**Ismael:** “NAT64 permite que un nodo IPv6 de Thread llegue a un destino IPv4.
En la prueba previa, el ping a 8.8.8.8 tuvo 10 respuestas de 10 y un promedio
de 53 milisegundos.”

**Henao:** “También probamos qué ocurre si S4/RCP se apagan: el PC pierde el
camino hacia la red Thread, pero C y S pueden conservar su comunicación local.
En nuestras evidencias el PC reportó `NetworkError` y el control local siguió
funcionando.”

**Ismael:** “Al restaurar el Border Router recuperamos el acceso del PC de forma
manual, usando la misma red. No medimos recuperación automática; después de un
reinicio puede hacer falta reconfigurar Wi-Fi y restaurar el dataset.”

### 6. Cierre

**Henao:** “El resultado principal es la integración: radio 802.15.4, Thread,
sensor, CoAP/CBOR, Wi-Fi, acceso desde el PC y NAT64.”

**Ismael:** “Los cuatro laboratorios previos aportan esas piezas por separado.
El Lab 5 las integra. Como límites, la válvula se representa con un LED, la
ruta IPv6 del PC se configuró manualmente y no se hizo calibración con una
referencia confiable.”

## Preguntas que puede hacer el profesor

- **¿Qué aporta el RCP?** La radio 802.15.4; S4 procesa Thread y controla el RCP
  con Spinel.
- **¿Por qué no basta con Wi-Fi?** S y C se comunican en Thread; el Border Router
  conecta esa red con Wi-Fi y enruta paquetes entre ellas.
- **¿Qué hace NAT64?** Traduce tráfico entre un origen IPv6 y un destino IPv4.
- **¿Qué es OMR?** El prefijo IPv6 que el Border Router anuncia para que la red
  externa pueda enrutar hacia nodos Thread.
- **¿Qué pasa si se apaga S4?** Se pierde el camino desde el PC; el enlace local
  C→S puede seguir activo. La restauración observada fue manual.
- **¿La temperatura está calibrada?** No. El sistema leyó el DS18B20, pero el
  termómetro de cocina no fue una referencia confiable para calcular un offset.
- **¿La válvula es real?** No; el estado se representa con el LED.

## Evidencias y límites

Resultados previos disponibles: [registro del Lab 5](evidencias/registro.md),
[informe](INFORME.md) y [guía de ejecución](guia.md). No expongan SSID,
contraseña Wi-Fi, dataset Thread ni claves. Las direcciones IP/prefijos pueden
cambiar; consulten los actuales durante la presentación. No describan la pérdida
de conexión del PC como pérdida total de Thread: son rutas distintas.
