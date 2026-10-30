# Design & Decision Record (DDR) — Lab 0 HTTP

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** System.

ESP32-C6 por Wi-Fi sirve GET /api/sensor y POST /api/control; Flask presenta temperatura simulada y órdenes de LED.

**Estado:** GET/POST directos y LED validados; telemetría de dashboard observada, actuación UI con salvedad.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Daniela: lectura y actuación directas funcionan. Edwin: el aviso de error al apagar desde UI requiere distinguir estado previo, respuesta HTTP y estado físico.

[Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-HTTP-001 — API de recursos HTTP

- **Context:** ESP32-C6 por Wi-Fi sirve GET /api/sensor y POST /api/control; Flask presenta temperatura simulada y órdenes de LED.
- **Decision:** Usar GET para telemetría y POST JSON con state 0/1 para control, mostrando el resultado al operador.
- **Rationale:** curl obtuvo HTTP 200 y el serial confirmó ambos estados. La separación de recursos permite comprobar sensado y actuación de forma independiente.
- **Status:** Aceptada para el prototipo.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| LED RGB; temperatura simulada | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Dashboard Flask y curl | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | LED RGB; temperatura simulada | Activa en el alcance descrito | Lab 0 HTTP |
| Secondary | Processing | JSON, validación de state y temperatura simulada | Activa | Lab 0 HTTP |
| Secondary | Transferring | Wi-Fi/IPv4/HTTP | Activa | Lab 0 HTTP |
| Interface | Human / application | Dashboard Flask y curl | Activa | Lab 0 HTTP |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

Una respuesta HTTP confirma una operación de protocolo; para probar actuación también se necesita el estado serial y físico. Una temperatura generada por software no caracteriza el ambiente.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| GET /api/sensor | Respuesta JSON | 200; temperature 29.8 °C simulados | Verificado |
| POST state 1 y 0 | Control de LED | 200; serial LED state 1 y 0 | Verificado |
| Dashboard ON→OFF | Secuencia completa | Telemetría en video; aviso al apagar estando apagado | Parcial |
| RTT HTTP | Medir | Sin serie temporizada | No medido |

No se midieron latencia ni precisión térmica; no se atribuye el fallo UI a una causa técnica confirmada.

## 7. Ethics & Sustainability Checklist

- [x] Se identifican explícitamente datos simulados.
- [ ] Cifrado/autorización de aplicación no validados.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | Wi-Fi/IPv4/HTTP; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Dashboard Flask y curl; operador interpreta estados y errores |
| Functional | JSON, validación de state y temperatura simulada |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Disponibilidad: respuesta directa observada. Integridad: JSON y estados comprobados. Confidencialidad: HTTP sin TLS en el ensayo. Seguridad funcional: LED, sin actuador hidráulico.

**Brechas y límites:** No se midieron latencia ni precisión térmica; no se atribuye el fallo UI a una causa técnica confirmada.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 0 HTTP |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | Wi-Fi/IPv4/HTTP |
| Primary observation/control | LED RGB; temperatura simulada |
| Secondary processing | JSON, validación de state y temperatura simulada |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Dashboard Flask y curl y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

