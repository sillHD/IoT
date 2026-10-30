# Design & Decision Record (DDR) — Lab 1 — Radio 802.15.4

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** Component.

Dos ESP32-C6 con OpenThread caracterizan energía por canal, RSSI por receptor y pérdida de solicitudes ping bidireccionales.

**Estado:** Escaneo y medidas a 1/5/10/15 m documentados; serie detenida a 15 m.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Samuel: canal 25 elegido con escaneo. Edwin: durante las mediciones se presentó un problema de línea de visión; a ello se atribuye la variación anormal de las medidas. No se fija separación de instalación.

[Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-001 — Canal 25 para las pruebas

- **Context:** Dos ESP32-C6 con OpenThread caracterizan energía por canal, RSSI por receptor y pérdida de solicitudes ping bidireccionales.
- **Decision:** Fijar canal 25 a partir del escaneo local y conservar por separado las sesiones de potencia.
- **Rationale:** Canal 25 registró −104 dBm, empatado con 21 y 24. La referencia 1 m usó 0 dBm y la serie 5–15 m 20 dBm; no constituyen una única curva a potencia constante.
- **Status:** Aceptada para la sesión, no recomendación universal de canal.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| Propagación y obstáculos entre radios | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Shell OpenThread y tablas de medición | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | Propagación y obstáculos entre radios | Activa en el alcance descrito | Lab 1 — Radio 802.15.4 |
| Secondary | Processing | RSSI, LQ In, cálculo de pérdida por conteos | Activa | Lab 1 — Radio 802.15.4 |
| Secondary | Transferring | IEEE 802.15.4/Thread/IPv6/ICMPv6 | Activa | Lab 1 — Radio 802.15.4 |
| Interface | Human / application | Shell OpenThread y tablas de medición | Activa | Lab 1 — Radio 802.15.4 |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

RSSI de paquetes recibidos y pérdida no son equivalentes: las muestras recibidas no describen las que se perdieron. La pérdida de ping incluye ida y vuelta, no una tasa PHY aislada.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| Energía canal 25 | Escaneo previo | −104 dBm | Medido |
| 1 m, 0 dBm | Referencia | RSSI A→B/B→A −67/−66; pérdida 0/0 % | Medido |
| 5 m, 20 dBm | 100 pings por sentido | −78/−80 dBm; pérdida 1/0 % | Medido |
| 10 m, 20 dBm | 100 pings por sentido | −91/−91 dBm; pérdida 0/3 % | Medido |
| 15 m, 20 dBm | 100 pings por sentido | −80/−86 dBm; pérdida 98/96 % | Medido |
| Más de 15 m | No extrapolar | No ejecutado | Sin resultado |

Payload 64 B, 100 solicitudes por sentido, 0,2 s, direcciones secuenciales. Línea de visión incompleta; no se extrapola un alcance ni una separación de despliegue.

## 7. Ethics & Sustainability Checklist

- [x] Distancias no realizadas identificadas como tales.
- [ ] Ausencia de interferencia a terceros no certificada.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | IEEE 802.15.4/Thread/IPv6/ICMPv6; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Shell OpenThread y tablas de medición; operador interpreta estados y errores |
| Functional | RSSI, LQ In, cálculo de pérdida por conteos |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Fiabilidad y disponibilidad: pérdidas medidas. Integridad: dirección RSSI atribuida al receptor. Interferencia: escaneo local, sin prueba formal de no afectación a vecinos.

**Brechas y límites:** Payload 64 B, 100 solicitudes por sentido, 0,2 s, direcciones secuenciales. Línea de visión incompleta; no se extrapola un alcance ni una separación de despliegue.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 1 — Radio 802.15.4 |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | IEEE 802.15.4/Thread/IPv6/ICMPv6 |
| Primary observation/control | Propagación y obstáculos entre radios |
| Secondary processing | RSSI, LQ In, cálculo de pérdida por conteos |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Shell OpenThread y tablas de medición y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

