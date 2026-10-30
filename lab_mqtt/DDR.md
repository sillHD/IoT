# Design & Decision Record (DDR) — Lab 0 MQTT

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** System.

ESP32-C6 publica iot/sensor cada 2 s y recibe iot/control; Mosquitto en Windows distribuye mensajes al dashboard.

**Estado:** Telemetría y control desde dashboard validados.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Samuel: el broker desacopla publicador y consumidor. Edwin: depende de mantener Mosquitto activo y alcanzable; no se probó desconexión/reconexión.

[Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-MQTT-001 — Publicación/suscripción con broker local

- **Context:** ESP32-C6 publica iot/sensor cada 2 s y recibe iot/control; Mosquitto en Windows distribuye mensajes al dashboard.
- **Decision:** Separar telemetría iot/sensor y órdenes iot/control; usar Mosquitto local y QoS 1 para órdenes del dashboard.
- **Rationale:** Conexión TCP desde WSL, telemetría recibida y comandos LED 1/0 registrados. QoS 1 admite entrega repetida; no equivale a ejecución física exactamente una vez.
- **Status:** Aceptada para el prototipo.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| LED RGB; temperatura simulada | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Dashboard Flask | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | LED RGB; temperatura simulada | Activa en el alcance descrito | Lab 0 MQTT |
| Secondary | Processing | JSON, tópicos y estados de LED | Activa | Lab 0 MQTT |
| Secondary | Transferring | Wi-Fi/IPv4/TCP/MQTT | Activa | Lab 0 MQTT |
| Interface | Human / application | Dashboard Flask | Activa | Lab 0 MQTT |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

El broker agrega una dependencia operativa aunque reduce acoplamiento entre consumidores. La confirmación MQTT no sustituye la comprobación del actuador.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| Telemetría | Publicación periódica | Cada 2 s; JSON visible en dashboard | Verificado |
| Control | Estados 1/0 | Múltiples órdenes en serial; dashboard operativo | Verificado |
| Broker | Accesible desde WSL | TCP 1883 conectado | Verificado |
| RTT/reconexión | Medir | Sin medición/ensayo de corte | No medido |

No se midieron latencia, consumo ni recuperación del broker; no se afirma TLS o autorización en este ensayo.

## 7. Ethics & Sustainability Checklist

- [x] Broker local y credenciales excluidas de Git.
- [ ] Recuperación tras fallo y cifrado no validados.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | Wi-Fi/IPv4/TCP/MQTT; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Dashboard Flask; operador interpreta estados y errores |
| Functional | JSON, tópicos y estados de LED |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Disponibilidad: broker y flujo local operativos. Fiabilidad: control observado; duplicación QoS 1 no ensayada deliberadamente. Confidencialidad y autorización: no demostradas.

**Brechas y límites:** No se midieron latencia, consumo ni recuperación del broker; no se afirma TLS o autorización en este ensayo.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 0 MQTT |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | Wi-Fi/IPv4/TCP/MQTT |
| Primary observation/control | LED RGB; temperatura simulada |
| Secondary processing | JSON, tópicos y estados de LED |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Dashboard Flask y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

