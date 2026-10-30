# Design & Decision Record (DDR) — Lab 2 — Malla Thread y 6LoWPAN

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** Component.

Adaptación con dos placas para roles, direcciones IPv6, un salto y reconexión manual. Reenvío por intermediario y caminos alternativos requieren tres nodos en el ensayo original.

**Estado:** Firmware y procedimiento A/B preparados; sin ejecución propia registrada.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Samuel: no hay evidencia para cuantificar latencia por salto ni healing de ruta. Una tercera C6 usada como RCP en Lab 5 no constituye el experimento multisalto de Lab 2.

[Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-002 — Adaptación A/B y topología pendiente

- **Context:** Adaptación con dos placas para roles, direcciones IPv6, un salto y reconexión manual. Reenvío por intermediario y caminos alternativos requieren tres nodos en el ensayo original.
- **Decision:** Preparar A/B para un salto y reservar la comparación multisalto y recuperación de rutas para una configuración adecuada con tercer nodo.
- **Rationale:** Dos extremos no permiten comprobar reenvío A→B→C ni desvío al fallar B. Ensayos de otros laboratorios no sustituyen la evidencia faltante.
- **Status:** Adaptación preparada; elección de topología redundante propuesta, sin validación experimental.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| Radios A/B; rutas alternativas no ensayadas | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Shell y plantilla de registro A/B | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | Radios A/B; rutas alternativas no ensayadas | Preparada, no ensayada | Lab 2 — Malla Thread y 6LoWPAN |
| Secondary | Processing | Procedimiento de identificación ML-EID/RLOC/Router ID | Preparada | Lab 2 — Malla Thread y 6LoWPAN |
| Secondary | Transferring | Thread/6LoWPAN/IPv6 | Preparada | Lab 2 — Malla Thread y 6LoWPAN |
| Interface | Human / application | Shell y plantilla de registro A/B | Preparada | Lab 2 — Malla Thread y 6LoWPAN |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

Formar una red y obtener IPv6 no demuestra rutas alternativas. Reincorporar un nodo y reparar una ruta son eventos distintos y deben cronometrarse con orígenes definidos.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| RTT un salto | Ensayo A/B | Pendiente | No medido |
| Costo por salto | Comparar uno/dos | Requiere configuración de tres nodos | No medido |
| Healing de ruta | <120 s según plantilla | Sin ensayos propios | No evaluado |
| Reconexión manual | Tres repeticiones previstas | Sin resultados | Pendiente |

No se adopta el valor ≈85 s del resumen externo ni los tiempos de reintegro de Labs 3–5 como healing de Lab 2.

## 7. Ethics & Sustainability Checklist

- [x] Se separan preparación, teoría y ejecución.
- [ ] Ensayos de recuperación pendientes.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | Thread/6LoWPAN/IPv6; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Shell y plantilla de registro A/B; operador interpreta estados y errores |
| Functional | Procedimiento de identificación ML-EID/RLOC/Router ID |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Fiabilidad, disponibilidad y resiliencia: procedimiento preparado; ninguna conclusión cuantitativa propia de esta práctica.

**Brechas y límites:** No se adopta el valor ≈85 s del resumen externo ni los tiempos de reintegro de Labs 3–5 como healing de Lab 2.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 2 — Malla Thread y 6LoWPAN |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | Thread/6LoWPAN/IPv6 |
| Primary observation/control | Radios A/B; rutas alternativas no ensayadas |
| Secondary processing | Procedimiento de identificación ML-EID/RLOC/Router ID |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Shell y plantilla de registro A/B y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

