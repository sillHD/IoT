# Lab 2 — malla Thread con tres ESP32-C6

Firmware común: [firmware/](firmware/) · [Guía completa por placa](guia.md) ·
[Registro de evidencias](evidencias/registro.md) · [Origen](ORIGEN.md)

## Qué se prepara

La misma imagen se carga en **A, B y C**. A crea la red; B y C se unen al mismo
dataset. OpenThread determina sus roles: A se espera como líder y B/C como routers.
El LED muestra azul para líder, verde para router, amarillo para child, rojo para
detached y apagado para disabled. Los roles también aparecen en el log.

Objetivo de compilación: `esp32c6_devkitc/esp32c6/hpcore`, RGB GPIO8, flash de al
menos 4 MB. Una placa de 8 MB utiliza los primeros 4 MB. Si la tercera placa es
otro modelo, revisar su target y su LED antes de usar estos comandos.

## Inicio rápido en WSL

En el PC con Zephyr y el repositorio actualizado:

```bash
cd ~/IoT
bash lab2/tools/build.sh usb
```

Conecta las placas una a una y pásalas a WSL con usbipd. Cierra el monitor antes
de cada carga. Si al conectar cada placa sola aparece como `/dev/ttyACM0`:

```bash
bash ~/IoT/lab2/tools/flash.sh A /dev/ttyACM0 usb
```

Desconecta A, conecta B y verifica de nuevo el puerto:

```bash
bash ~/IoT/lab2/tools/flash.sh B /dev/ttyACM0 usb
```

Desconecta B, conecta C y verifica de nuevo el puerto:

```bash
bash ~/IoT/lab2/tools/flash.sh C /dev/ttyACM0 usb
```

**Se compila una vez y se carga tres veces.** La letra identifica la placa en el
archivo de evidencia del flasheo; no fija su rol en el firmware.

Con las tres conectadas simultáneamente, identifica los puertos reales y abre
una terminal por placa. Por ejemplo, solo si corresponden a ese orden:

```bash
bash ~/IoT/lab2/tools/monitor.sh A /dev/ttyACM0
```

```bash
bash ~/IoT/lab2/tools/monitor.sh B /dev/ttyACM1
```

```bash
bash ~/IoT/lab2/tools/monitor.sh C /dev/ttyACM2
```

Sigue [guia.md](guia.md) para reiniciar datasets, crear la red, registrar direcciones,
forzar dos saltos y ejecutar tres ensayos de recuperación. No reutilices las
direcciones de Lab 1. Canal inicial 25 y potencia 0 dBm en las tres placas.

Para usar el conector UART/CH343, compila con `build.sh uart`, carga con
`flash.sh A PUERTO uart` y conecta el monitor a ese mismo conector.
Un dispositivo `ttyACM` o `ttyUSB` identifica el puerto enumerado, no garantiza
por sí solo qué backend de consola necesita el firmware.

## Estado

- [x] Firmware y scripts preparados.
- [x] Guía para A/B/C y plantillas de evidencia disponibles.
- [ ] Compilar en el entorno Zephyr del PC.
- [ ] Cargar y comprobar el arranque de las tres placas.
- [ ] Completar direccionamiento, RTT, contadores y tres pruebas de recuperación.
- [ ] Completar ADR-002 y los resúmenes con los resultados reales.

Los archivos de esta carpeta son preparación; no se ha compilado ni flasheado
desde el entorno de este chat. No se necesitan Wi-Fi, broker MQTT ni dashboard.
