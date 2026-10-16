# Lab 2 — instrucciones completas para A, B y C

Referencia: [Lab 2 del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/54ce49e5c0251dd3e7cc1300dbe6c96c28d55fd2/en/labs/lab2.md).
Guarda resultados en [evidencias/registro.md](evidencias/registro.md), logs en
`evidencias/archivos/` e imágenes en `Imagen/`. Los valores pendientes deben
reemplazarse por mediciones reales.

## 1. Equipos, conectores y entorno

Necesitas tres ESP32-C6 con flash de al menos 4 MB, cables USB de datos y un PC
con el Zephyr que utilizamos antes. Etiqueta físicamente A, B y C. Puedes usar un
solo PC con tres terminales seriales, o repartirlas entre varios PCs. Los PCs no
necesitan compartir una red Wi-Fi: los paquetes viajan por 802.15.4/Thread.

Este firmware apunta a DevKitC con RGB en GPIO8. Para otro modelo se debe
comprobar el target/overlay, especialmente si no tiene RGB direccionable.

**USB nativo (conector ESP32C6):** usa compilación `usb`; el overlay dirige
consola y shell al USB-Serial-JTAG. **CH343/UART:** usa compilación `uart` y ese
conector. No cambies de conector para el monitor sin comprobar el backend que
compilaste. La velocidad es 115200, 8N1, sin control de flujo.

En Windows, lista dispositivos desde PowerShell:

```powershell
usbipd list
```

Para cada placa destinada a WSL, ejecuta con su BUSID real; `bind` requiere una
terminal con permisos de administrador:

```powershell
usbipd bind --busid 1-1
usbipd attach --wsl --busid 1-1
```

`1-1` es solo ejemplo. Repite con los BUSID de B y C. En WSL:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
```

Identifica la asociación A/B/C conectando una a la vez. El orden puede cambiar
después de un reset o de mover un cable. No adivines la asociación por el número.

Si hay permiso denegado:

```bash
sudo usermod -aG dialout "$USER"
```

Cierra la sesión de WSL y vuelve a abrirla para aplicar el grupo.

## 2. Compilar una sola imagen

Si ya tienes `~/IoT`, actualízalo con el árbol de trabajo limpio:

```bash
cd ~/IoT
git pull --ff-only
bash lab2/tools/build.sh usb
```

El script activa `~/zephyrproject/.venv`, compila desde el workspace Zephyr y
guarda `build-usb.log`. La imagen queda en
`~/zephyrproject/build-iot-lab2-usb/zephyr/zephyr.bin`.

Si tu workspace está en otra ruta:

```bash
ZEPHYR_WORKSPACE=/ruta/zephyrproject bash ~/IoT/lab2/tools/build.sh usb
```

Comando equivalente para compilación USB, sin el script:

```bash
source ~/zephyrproject/.venv/bin/activate
cd ~/zephyrproject
west build -p always -b esp32c6_devkitc/esp32c6/hpcore \
  -s ~/IoT/lab2/firmware -d build-iot-lab2-usb -- \
  -DDTC_OVERLAY_FILE="$HOME/IoT/lab2/firmware/boards/esp32c6_devkitc_hpcore.overlay" \
  -DEXTRA_CONF_FILE="$HOME/IoT/lab2/firmware/usb_console.conf" \
  -DEXTRA_DTC_OVERLAY_FILE="$HOME/IoT/lab2/firmware/usb_console.overlay"
```

El overlay de placa se selecciona explícitamente con DTC_OVERLAY_FILE;
EXTRA_DTC_OVERLAY_FILE añade la consola USB conservando LED y flash de 4 MB.
El mapa de particiones
predeterminado de la versión de Zephyr usada anteriormente cabe en 4 MB.

Para UART:

```bash
bash ~/IoT/lab2/tools/build.sh uart
```

No hacen falta tres proyectos ni tres builds: cambian los comandos de red, no
el programa. No hay credenciales Wi-Fi ni claves Thread en el código.

## 3. Cargar A, B y C

Cierra los monitores antes de flashear. La opción más sencilla es conectar una
placa a la vez al PC con Zephyr. Con A sola, si su puerto es ttyACM0:

```bash
bash ~/IoT/lab2/tools/flash.sh A /dev/ttyACM0 usb
```

Desconecta A. Conecta y adjunta B a WSL, vuelve a listar los puertos y ejecuta:

```bash
bash ~/IoT/lab2/tools/flash.sh B /dev/ttyACM0 usb
```

Repite con C:

```bash
bash ~/IoT/lab2/tools/flash.sh C /dev/ttyACM0 usb
```

Cada comando guarda un log de flash por letra. Usa el puerto real si no es
ttyACM0. Alternativa con las tres conectadas: especifica el puerto de cada una
en lugar de usar ttyACM0 en todos los comandos. No abras dos programas sobre el
mismo puerto. Si no sincroniza: mantén BOOT, pulsa RESET, suelta BOOT y reintenta.

El script pasa `--esp-flash-size 4MB`, coherente con el overlay. En una placa de
8 MB la imagen sigue usando los primeros 4 MB. Si el chip tiene menos de 4 MB o
el build sigue indicando 8 MB, detén la carga y revisa la configuración.

Equivalente para A, desde el workspace Zephyr:

```bash
west flash -d build-iot-lab2-usb --esp-device /dev/ttyACM0 --esp-flash-size 4MB
```

## 4. Abrir las tres consolas

Abre una terminal por placa. Ejemplo para A:

```bash
bash ~/IoT/lab2/tools/monitor.sh A /dev/ttyACM0
```

En otras terminales, usa B y C con sus puertos reales. Pulsa Enter para obtener
`uart:~$`. Sal del monitor con Ctrl+]. El arranque debe incluir
`Lab 2 mesh node ready`.

En un PC sin Zephyr basta un terminal serial (PuTTY o Tera Term) con el COM que
muestre el Administrador de dispositivos: 115200, 8N1, sin control de flujo.
La placa debe haberse cargado previamente en el PC con Zephyr. Si Windows va a
abrir el puerto, no lo dejes adjuntado a WSL; puedes devolverlo con
`usbipd detach --busid BUSID_REAL`. Un adaptador CH343 puede necesitar su driver.

## 5. Inicialización: solo al comenzar el laboratorio

En **cada placa**, borra el dataset anterior una vez:

```text
ot factoryreset
```

La placa se reinicia. Si USB se reenumera, vuelve a adjuntarla a WSL y abre el
monitor en el puerto actual. No repitas factoryreset entre ensayos.

### Placa A — crear la red

Ejecuta una línea a la vez:

```text
ot txpower 0
ot txpower
ot dataset init new
ot dataset channel 25
ot dataset commit active
ot ifconfig up
ot thread start
```

Espera y consulta `ot state` hasta ver `leader`. Luego:

```text
ot dataset active -x
```

Copia la cadena hexadecimal completa para B y C por un medio local. Contiene
la clave de la red: no la incluyas en capturas, logs compartidos ni Git.

### Placa B — unirse a A

Reemplaza el marcador por el hexadecimal de A, sin los signos `< >`:

```text
ot txpower 0
ot txpower
ot dataset set active <HEX_DE_A>
ot ifconfig up
ot thread start
```

Espera a que `ot state` pase de `child` a `router`.

### Placa C — unirse a A

Usa exactamente el mismo dataset de A:

```text
ot txpower 0
ot txpower
ot dataset set active <HEX_DE_A>
ot ifconfig up
ot thread start
```

Espera a que `ot state` indique `router`. Puede tardar alrededor de dos minutos.
Si hay varios leaders persistentes, acércalos y revisa el dataset compartido;
no generes un dataset nuevo en B o C.

### Comprobación en las tres

```text
ot state
ot txpower
ot channel
ot router table
ot neighbor table
```

Guarda las salidas sin el dataset. Deben estar en canal 25, a 0 dBm, con tres
routers en la malla (el líder también realiza funciones de router).

## 6. Direcciones: A, B y C

Ejecuta en cada placa:

```text
ot ipaddr
ot ipaddr mleid
ot ipaddr rloc
ot rloc16
ot extaddr
ot ipmaddr
```

Registra en la plantilla: ML-EID, RLOC, RLOC16, extended address y link-local.
`...:fc00` es el ALOC del líder, no el RLOC individual de A. Para obtener este
último usa `ot ipaddr rloc`. Usa **ML-EID** para los pings de este laboratorio.

Comprueba las derivaciones: Router ID = RLOC16 >> 10; la dirección link-local
usa un IID derivado de extaddr con el bit U/L (0x02 del primer byte) invertido.
Clasifica también los grupos multicast encontrados.

## 7. Referencia sin filtros

Mantén las tres placas sobre una mesa, con línea de visión despejada, sin
cambiar posición, canal ni potencia entre pruebas. En A y C:

```text
ot macfilter rss clear
```

En B resetea contadores, en A haz ping a C y después consulta B:

```text
ot counters mac reset
```

```text
ot ping <ML_EID_C> 64 20 0.5
```

```text
ot counters mac
```

Los tres bloques corresponden a B, A y B, respectivamente. Guarda el valor de
TxUnicast como referencia; el tráfico de control puede contribuir al contador.

## 8. Obligar a preferir A → B → C

Obtén extaddr de A y C con `ot extaddr` (16 caracteres hexadecimales, sin dos
puntos). En A:

```text
ot macfilter rss add-lqi <EXTADDR_C> 1
```

En C:

```text
ot macfilter rss add-lqi <EXTADDR_A> 1
```

No añadas filtros en B. Espera aproximadamente un minuto y captura
`ot router table` en A. El enlace directo A↔C permanece disponible, con LQ
forzada a 1; la ruta por B debe resultar preferida. Esto modela una ruta de
respaldo sin depender de paredes ni de separaciones físicas.

Repite la secuencia B reset / A ping a C / B counters de la sección anterior.
Compara TxUnicast: con 20 solicitudes y 20 respuestas reenviadas puede aumentar
aproximadamente 40, además del tráfico de control. Registra el valor real;
no uses el número esperado como resultado. Conserva las tablas para relacionar
Next Hop con el Router ID de B y demostrar que la ruta pasa por él.

## 9. RTT de uno y dos saltos

En A, ejecuta uno a la vez:

```text
ot ping <ML_EID_B> 64 20 0.5
```

```text
ot ping <ML_EID_C> 64 20 0.5
```

Registra enviados/recibidos, pérdida y RTT min/promedio/max. La diferencia de
promedios es el incremento del RTT para la ruta de dos saltos; RTT incluye ida
y vuelta, no es un retardo unidireccional medido. Un primer ping puede perderse
durante la resolución de la ML-EID: anótalo, sin atribuir automáticamente toda
pérdida a ese motivo. No ejecutes pings simultáneos.

## 10. Recuperación al desconectar B — tres ensayos

Con los filtros de A/C aún aplicados y B reenviando, inicia desde A:

```text
ot ping <ML_EID_C> 64 200 1
```

Tras unas diez respuestas correctas, desconecta la alimentación de B. Conserva
A y C encendidas. Anota el instante de desconexión y la última respuesta previa;
registra cuándo vuelven las respuestas por el enlace A↔C. Anota la duración de
la interrupción, los paquetes perdidos y el resumen completo del ping.

La cantidad de pings perdidos a intervalo de 1 s da una aproximación del tiempo
de interrupción; usa tiempos y secuencias para distinguirla de pérdidas previas
o posteriores. No asumas que toda pérdida del resumen ocurrió por el corte.

Después del corte, captura en A:

```text
ot router table
ot neighbor table
```

Comprueba el cambio de ruta hacia C. B puede permanecer temporalmente en la
tabla antes de desaparecer. La guía usa Next Hop 63 como ausencia de relay;
registra lo que reporte tu versión y relaciónalo con los contadores y pings.

Vuelve a conectar B, adjúntala de nuevo a WSL si corresponde y abre su monitor.
El dataset se conserva; el arranque de Thread es manual. En B:

```text
ot txpower 0
ot ifconfig up
ot thread start
ot state
```

Espera a router, revisa la potencia y comprueba en A que vuelva la ruta por B
antes del siguiente ensayo. Repite el procedimiento **tres veces en total**.
Evalúa si cada tiempo de recuperación fue menor de 120 s.

## 11. Guardar evidencias y terminar

Guarda resúmenes de ping, tablas de vecinos/rutas, direcciones, potencia y
contadores. Nombres sugeridos: `direccionamiento-A.txt`, `rtt-1-salto.txt`,
`rtt-2-saltos.txt`, `contadores-B-sin-filtro.txt`, `contadores-B-con-filtro.txt`,
`recuperacion-1.txt` y equivalentes para ensayos 2 y 3.

Completa las tablas de [registro.md](evidencias/registro.md) y añade imágenes a
`Imagen/`. No subas un log serial completo si incluye el dataset copiado.

Al terminar, en A y C:

```text
ot macfilter rss clear
```

En las tres placas:

```text
ot thread stop
ot ifconfig down
```

El informe incluye ADR-002, clasificación de direcciones, funciones/consumo de
los roles Thread y su mapeo SCD/ASD, respuestas de 6LoWPAN/fallos/redundancia y
los resúmenes para Edwin y Samuel. La plantilla contiene los apartados.

## 12. Si algo falla

| Síntoma | Acción |
|---|---|
| Falta west | Activa la venv de Zephyr o ejecuta el script en el PC donde está instalado. |
| Faltan blobs/SDK | Usa la instalación existente: `west blobs fetch hal_espressif`; revisa `west sdk list`. |
| Puerto desaparece | Revisa USB/cable y repite `usbipd list` / attach; vuelve a listar los puertos. |
| No hay prompt | Comprueba consola usb/uart, conector físico y 115200; pulsa Enter y RESET. |
| No sincroniza al cargar | Cierra todos los monitores; secuencia BOOT/RESET y reintento. |
| Varios leaders | Acerca las placas y revisa que B/C usen el dataset de A; espera la convergencia. |
| B/C siguen child | Espera unos dos minutos; revisa el firmware FTD y no midas el ensayo de tres routers hasta confirmar el rol. |
| macfilter no existe | Asegura que cargaste Lab 2 y no Lab 1; CONFIG_OPENTHREAD_MAC_FILTER debe estar habilitado. |
| Contador B no cambia | Verifica extaddr, filtros simétricos A/C, convergencia y Next Hop. |
| No recupera al quitar B | Comprueba que A/C se oyen; no deben existir deny-lists ni barreras que eliminen el enlace de respaldo. |
| Aviso flash 8 MB frente a chip 4 MB | Recompila limpio con el overlay suministrado; comprueba CONFIG_FLASH_SIZE=4096 y la opción de flash 4MB. |
