# Procedencia del resumen general copiado

Fuente: [IoT-Labs-DHR/Resumen_General/README.md](https://github.com/dahenaor-source/IoT-Labs-DHR/blob/fce8f76094cf799cfc72182fa40f0c2fec219f6f/Resumen_General/README.md).
Revisión: `fce8f76094cf799cfc72182fa40f0c2fec219f6f`. Copia: 30 de octubre de 2026.
SHA-256 del archivo original: `48623a8b72519f5b7ab43f88baa426f2c3cbfb6f92199f707d539e4a12fbaf71`.
Autoría conservada: David Henao Rojas; el original identifica trabajo conjunto.

[ORIGINAL_DHR.md](ORIGINAL_DHR.md) es una copia byte por byte; sus enlaces relativos
pertenecen al repositorio de origen. [README.md](README.md) conserva su texto y
convierte únicamente esos enlaces en URLs de la revisión de origen, con esta
nota de procedencia. No se copió firmware ni se modificó el repositorio DHR.

## Diferencias que no se incorporan como resultados de IoT

- El resumen externo menciona ≈85 s de healing en Lab 2. Nuestro registro de
  Lab 2 no tiene ensayos propios; no se adopta esa cifra ni se confunde reintegro
  de un nodo con reparación de una ruta multisalto.
- El resumen externo afirma pérdida a ≥20 m y alcance ~15–20 m. En IoT solo se
  midieron 1/5/10/15 m y se detuvo la serie a 15 m. Las medidas posteriores se
  descartaron antes de ejecutarse; no se establece una separación de despliegue.
- Los ≈44 ms de Lab 3 son intervalos visuales de video, no un RTT RF aislado;
  ≈381 días son una estimación energética, no autonomía observada.
- En IoT ADR-007 está adoptada para la arquitectura del prototipo de Lab 5,
  mientras la fuente presenta una propuesta para un piloto. Son alcances distintos.

Los [DDR por práctica](../DDR/README.md), el [informe unificado](../INFORME_LABORATORIOS.md)
y los registros locales son las fuentes de los resultados de este repositorio.
