# Design & Decision Record (DDR) — Lab 5 — Border Router

**GreenField Technologies | IoT Systems Design — SoilSense**  
**Team Members:** Ismael Cortes Ramirez; David Henao Rojas.  
**Consolidación documental:** 30 de octubre de 2026; no sustituye la fecha de cada ensayo.  
**Plantilla:** [docs/ddr_template.md del curso](https://github.com/saacifuentesmu/4201327-iot_systems_design/blob/ff6e6754d01e15bf405f0934d4a1100f007ead96/docs/ddr_template.md). Se conservan sus diez secciones y se limita el contenido a esta práctica.

## 1. System Overview

**System Type:** System.

S3 N16R8 con PSRAM octal y C6 RCP por UART conecta C/S Thread con Windows por Wi-Fi; OMR, ruta IPv6 manual, CoAP/CBOR y NAT64.

**Estado:** Finalizado por el equipo; dashboard móvil y 0 dBm confirmados verbalmente.

Alcance exclusivo de esta práctica; no reemplaza integración final de Lab 8.

## 2. Lab Log & Stakeholder Summaries

Daniela: acceso desde PC y celular y control LED operativos. Edwin: sin BR el control C→S sigue, pero el acceso externo falla; restauración manual con mismo dataset.

[Informe detallado](INFORME.md) · [Registro y evidencia](evidencias/registro.md). Datos del resumen externo no sustituyen logs propios.

## 3. Architecture Decision Records (ADRs)

### ADR-007 — Acceso Wi-Fi mediante BR manteniendo control interno

- **Context:** S3 N16R8 con PSRAM octal y C6 RCP por UART conecta C/S Thread con Windows por Wi-Fi; OMR, ruta IPv6 manual, CoAP/CBOR y NAT64.
- **Decision:** Adoptar S3+C6 RCP como BR del prototipo, conservando aplicación C/S dentro de Thread.
- **Rationale:** PC recibió 10/10 GET y NAT64 funcionó; durante corte de BR falló GET PC y el usuario confirmó control del LED desde C. Tras restaurar, GET PC 2.05 y 23,5 °C.
- **Status:** Aceptada para el prototipo; no prueba disponibilidad de despliegue ni recuperación autónoma.

Los IDs ADR-001–007 mantienen su significado en el informe unificado; HTTP/MQTT usan identificadores propios.

## 4. ISO/IEC 30141 Mapping

### Domain Mapping

| Elemento | Dominio ISO/IEC 30141 | Justificación |
|---|---|---|
| DS18B20 y LED; S3 con RCP | PED (Physical Entity Domain) | Fenómeno físico o representación de laboratorio; se distingue del dato digital |
| ESP32-C6 y radio/interfaz local | SCD (Sensing and Controlling Domain) | Observación/actuación y transferencia asociadas |
| Cliente Python Windows y dashboard móvil | ASD (Application and Service Domain) / UD (User Domain) | Servicio de aplicación y acceso del operador |

### Component Capabilities

| Categoría | Subcategoría | Componente/función | Estado | Práctica |
|---|---|---|---|---|
| Primary | Observation / control | DS18B20 y LED; S3 con RCP | Activa en el alcance descrito | Lab 5 — Border Router |
| Secondary | Processing | Ruteo IPv6, NAT64, CBOR y Observe | Activa | Lab 5 — Border Router |
| Secondary | Transferring | Thread/Spinel UART/Wi-Fi/IPv6/UDP | Activa | Lab 5 — Border Router |
| Interface | Human / application | Cliente Python Windows y dashboard móvil | Activa | Lab 5 — Border Router |

Mapeo de diseño; no constituye certificación de conformidad ISO.

## 5. First Principles Reflections

El BR conecta dominios IP y es dependencia para acceso externo, no para toda comunicación local. NAT64 permite alcanzar IPv4, pero no aporta autenticación ni cifrado de aplicación.

## 6. Performance Baselines

| Métrica | Objetivo/referencia | Resultado | Estado |
|---|---|---|---|
| CoAP PC→S | Mediana <200 ms | 10/10; mediana 33 ms, 30–49 ms | Cumple |
| Ping PC→BR | Referencia | 10/10; medio mostrado 8 ms | Medido IPv6 |
| Ping PC→S | Referencia | 10/10; medio mostrado 32 ms | Medido IPv6 |
| Diferencia recorridos | <100 ms, indicador | ≈24 ms; 24,1 usando muestras | Cumple con límites |
| NAT64 | RTT <200 ms | 10/10; min/media/max 48/53/61 ms | Cumple en la serie |
| Corte y retorno | Separar control interno/externo | LED interno confirmado; GET PC falla y vuelve 2.05 | Verificado, sin tiempo medido |

No se confirmó wifi ps off: no se atribuye causalidad a la mejora. BR usa settings RAM y requiere restauración manual; retorno sin cronometraje. Cierre físico final no confirmado.

## 7. Ethics & Sustainability Checklist

- [x] Control local sin nube confirmado; NAT64 a Internet es prueba separada.
- [ ] No se declara seguridad de aplicación ni actuación hidráulica real.

Credenciales y datasets se mantienen fuera del repositorio. Los valores estimados o no medidos se identifican explícitamente.

## 8. Viewpoint Analysis

| Viewpoint | Aplicación en esta práctica |
|---|---|
| Foundational | Thread/Spinel UART/Wi-Fi/IPv6/UDP; límites entre dato, transporte y entidad física |
| Business | Prototipo SoilSense; no se infiere aptitud comercial de un ensayo de laboratorio |
| Usage | Cliente Python Windows y dashboard móvil; operador interpreta estados y errores |
| Functional | Ruteo IPv6, NAT64, CBOR y Observe |
| Trustworthiness | Evidencia y brechas de la sección 9 |
| Construction | Firmware/configuración de la carpeta local y montaje descrito |

## 9. Trustworthiness Audit (Lab 4+)

Disponibilidad: efecto del corte delimitado; resiliencia: retorno manual. Integridad: GET y CBOR previos medidos. Confidencialidad/autorización de aplicación pendientes; WPA2 no sustituye DTLS.

**Brechas y límites:** No se confirmó wifi ps off: no se atribuye causalidad a la mejora. BR usa settings RAM y requiere restauración manual; retorno sin cronometraje. Cierre físico final no confirmado.

No se declara cumplimiento normativo ni equivalencia entre LED y válvula de riego. Para prácticas anteriores a Lab 4 se registra el alcance preliminar de la auditoría.

## 10. Construction Viewpoint - IoT System Pattern (Lab 8)

| Elemento del patrón | Implementación/alcance |
|---|---|
| IoT System | SoilSense, prototipo incremental de Lab 5 — Border Router |
| IoT Components / devices | ESP32 y componentes descritos en la sección 1 |
| Digital Network | Thread/Spinel UART/Wi-Fi/IPv6/UDP |
| Primary observation/control | DS18B20 y LED; S3 con RCP |
| Secondary processing | Ruteo IPv6, NAT64, CBOR y Observe |
| Secondary transferring | Protocolos de la sección 4 |
| Secondary storage | Logs y evidencias; no se demuestra persistencia general de estado |
| Interface network/application/human | Cliente Python Windows y dashboard móvil y API/CLI descrita |
| Supplemental security | Credenciales fuera de Git; seguridad de aplicación no validada en esta práctica |
| Supplemental orchestration/management | Configuración y diagnóstico manual del prototipo |

Vista incremental para documentar construcción; no afirma haber completado Lab 8.

