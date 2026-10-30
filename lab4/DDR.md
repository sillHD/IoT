# Design & Decision Record (DDR) — Lab 4 — Sensor real y frescura

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** System.

DS18B20 de 12 bits en S (GPIO18, 3V3) reemplaza el dato simulado; lectura cada 2 s, validación, edad, Max-Age y error 5.03 al vencer.

**Estado:** Finalizado por el equipo, con límites de referencia y sincronización explícitos.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Edwin: se distingue sensor ausente de nodo incomunicado. Edward: filtros no detectan todos los datos falsos plausibles; no hay referencia térmica para calibración ni seguridad de aplicación.

[Informe detallado](INFORME.md) · [Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-005 / ADR-006 — Frescura y propuesta de cierre seguro

- **Context:** DS18B20 de 12 bits en S (GPIO18, 3V3) reemplaza el dato simulado; lectura cada 2 s, validación, edad, Max-Age y error 5.03 al vencer.
- **Decision:** Aceptar lectura con edad <60 s, disminuir Max-Age y devolver 5.03 al vencer. Proponer negar apertura sin dato vigente y cierre temporizado local.
- **Rationale:** GET con edad/Max-Age 16/44, 31/29 y 46/14 seguido de 5.03; inyección extrema rechazada y valor plausible 23 °C aceptado. La pérdida de enlace exige una política local adicional.
- **Status:** ADR-005 aceptada e implementada; ADR-006 propuesta, sin validación hidráulica.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| Temperatura real, DS18B20 y LED | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| soilsense stats/log e interfaz CoAP | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | Temperatura real, DS18B20 y LED | Activa en el alcance descrito | Lab 4 — Sensor real y frescura |
| Secondary | Processing | DS18B20, filtros de rango/salto, edad y Max-Age | Activa | Lab 4 — Sensor real y frescura |
| Secondary | Transferring | 1-Wire local; Thread/IPv6/UDP/CoAP | Activa | Lab 4 — Sensor real y frescura |
| Interface | Human / application | soilsense stats/log e interfaz CoAP | Activa | Lab 4 — Sensor real y frescura |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

Precisión, resolución, repetibilidad y exactitud son propiedades distintas. Una lectura estable no prueba calibración. Max-Age describe validez temporal y no garantiza la verdad del valor.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| Ruido en reposo | Caracterizar | 30 muestras; 21,50–21,62 °C; amplitud 0,12 °C | Medido |
| Fallas reposo | Referencia | 0/78 en 155 s | Medido |
| Fallas con tráfico | <5 % | 0/93 en 186 s | Cumple en esa ventana |
| Conversión con tráfico | Caracterizar | Media 760815 µs | Medido |
| Sensor perdido | ≤60 s desde retiro físico | 5.03 a 61,577 s de última lectura; retiro sin marca | No certificable desde retiro |
| Referencia/offset | Referencia independiente | No disponible; no aplicar −7 °C | No determinado |
| Tiempo t50 | Origen de estímulo | Dos soplidos, instantes no marcados | No determinado |

Ventanas de reposo y tráfico distintas. En prueba de red 1200 enviados/1199 recibidos: pérdida calculada 0,0833 %, aunque CLI muestra 0,0 %. Temperatura corporal y pantalla del refrigerador no constituyen calibración.

## 7. Ethics & Sustainability Checklist

- [x] No se aplica un offset sin referencia confiable.
- [ ] Cierre local del actuador real no implementado.
- [ ] Apagado físico final no documentado.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | 1-Wire local; Thread/IPv6/UDP/CoAP; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | soilsense stats/log e interfaz CoAP; operador interpreta estados y errores |
| Functional | DS18B20, filtros de rango/salto, edad y Max-Age |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Disponibilidad: sensor vuelve tras 193 fallos y reintegro de red observado. Integridad: validación de rango/salto con límites. Fiabilidad: conversión y fallos medidos. Safety: política propuesta, no actuador real.

**Brechas y límites:** Ventanas de reposo y tráfico distintas. En prueba de red 1200 enviados/1199 recibidos: pérdida calculada 0,0833 %, aunque CLI muestra 0,0 %. Temperatura corporal y pantalla del refrigerador no constituyen calibración.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 4 — Sensor real y frescura |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | 1-Wire local; Thread/IPv6/UDP/CoAP |
| Primary observation/control | Temperatura real, DS18B20 y LED |
| Secondary processing | DS18B20, filtros de rango/salto, edad y Max-Age |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | soilsense stats/log e interfaz CoAP y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

