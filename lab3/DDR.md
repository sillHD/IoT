# Design & Decision Record (DDR) — Lab 3 — CoAP, CBOR y SED

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** System.

Dos ESP32-C6 C/S sirven temperatura simulada con GET/Observe y control idempotente /act/valve representado por LED; se ensaya un nodo dormido.

**Estado:** Finalizado por el equipo con evidencia medida, visual y estimada diferenciadas.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Daniela: GET, Observe y PUT funcionan. Edwin: sondeo 5 s ofrece un compromiso propuesto; el tiempo operativo admisible y la autonomía requieren validación.

[Informe detallado](INFORME.md) · [Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-003 / ADR-004 — CoAP/CBOR y sondeo SED

- **Context:** Dos ESP32-C6 C/S sirven temperatura simulada con GET/Observe y control idempotente /act/valve representado por LED; se ensaya un nodo dormido.
- **Decision:** Adoptar GET/Observe, PUT CON y CBOR para los recursos; proponer pollperiod 5 s para la hoja SED.
- **Rationale:** Mensajes pequeños y control verificado; 5 s produjo RTT medio ICMP 2,119 s frente a 0,4656 s con 1 s y 8,4889 s con 15 s. El sondeo reduce recepción continua a costa de espera.
- **Status:** ADR-003 aceptada en prototipo; ADR-004 propuesta, no requisito operacional aprobado.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| LED de válvula; temperatura simulada | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Shell C/S y cliente | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | LED de válvula; temperatura simulada | Activa en el alcance descrito | Lab 3 — CoAP, CBOR y SED |
| Secondary | Processing | CBOR, umbral 0,5 °C y heartbeat; estado idempotente | Activa | Lab 3 — CoAP, CBOR y SED |
| Secondary | Transferring | Thread/IPv6/UDP/CoAP | Activa | Lab 3 — CoAP, CBOR y SED |
| Interface | Human / application | Shell C/S y cliente | Activa | Lab 3 — CoAP, CBOR y SED |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

Observe evita polling periódico del cliente, pero la ventaja depende de la tasa de cambio y del intervalo con que se compara. Una estimación de batería no incluye todos los costos de una placa real.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| GET CoAP | <200 ms | ≈50/17/67 ms visuales; media ≈44 ms | Evidencia visual, no RTT RF aislado |
| Observe | Caracterizar tráfico | 29 notificaciones/300 s; 0 heartbeat | Medido |
| SED 1 s | 10 pings | RTT medio 465,6 ms; 10/10 | Medido |
| SED 5 s | Referencia <5 s | Medio 2119 ms; máximo 4039 ms; 10/10 | Serie ICMP medida |
| SED 15 s | 10 pings | Medio 8488,9 ms; máximo 14461 ms; 10/10 | Medido |
| Autonomía a 5 s | Modelo explícito | ≈381,52 días, 3000 mAh y corrientes supuestas | Estimación |

CON con destino detenido terminó en timeout ≈92 s según usuario; NON solo confirmó envío local. No se midió corriente real. Fechas de sesión y de video se distinguen en el informe.

## 7. Ethics & Sustainability Checklist

- [x] Estimaciones energéticas identificadas y supuestos explícitos.
- [ ] Cierre local seguro y seguridad de aplicación no implementados.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | Thread/IPv6/UDP/CoAP; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Shell C/S y cliente; operador interpreta estados y errores |
| Functional | CBOR, umbral 0,5 °C y heartbeat; estado idempotente |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Integridad: CBOR y rechazo de valor inválido 7; idempotencia de PUT repetido. Disponibilidad: recuperación y timeout observados. Seguridad funcional: LED, sin válvula real.

**Brechas y límites:** CON con destino detenido terminó en timeout ≈92 s según usuario; NON solo confirmó envío local. No se midió corriente real. Fechas de sesión y de video se distinguen en el informe.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 3 — CoAP, CBOR y SED |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | Thread/IPv6/UDP/CoAP |
| Primary observation/control | LED de válvula; temperatura simulada |
| Secondary processing | CBOR, umbral 0,5 °C y heartbeat; estado idempotente |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Shell C/S y cliente y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

