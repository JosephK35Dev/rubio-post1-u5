# Rubio — Post-contenido 1, Unidad 5

**Curso:** Arquitectura de Computadores  
**Actividad:** Emuladores y Virtualización: Ensamblador en DOSBox y Máquinas Virtuales con VirtualBox

## Estado

El repositorio reúne la Parte 1 (DOSBox y NASM) y la Parte 2 (VirtualBox con Alpine Linux). Los resultados que dependen de ejecuciones reales, mediciones y capturas se completarán durante el laboratorio; no se han inventado valores.

## Parte 1 — DOSBox

- DOSBox: 0.74-3.
- NASM para DOS: versión 2.16.03 (verificada en DOSBox con `nasm -v`).
- CWSDPMI: se inicia desde `dosbox.conf` para dar soporte DPMI a NASM para DOS.
- DEBUG.COM: se reutiliza el depurador DOS del laboratorio anterior, copiado a la raíz para la verificación de `saludo.com`.
- Configuración personalizada: `dosbox.conf`, con `cycles=8000` como valor de referencia.
- Programas fuente: `src/saludo.asm`, `src/entrada.asm` y `src/ciclos.asm`.

### Mediciones de ciclos

| Corrida | cycles | Hora inicial | Hora final | Duración observada |
|---|---:|---|---|---|
| 1 | 8000 | 14:35:08:11 | 14:35:40:90 | 32,79 s (3279 centésimas) |
| 2 | 1000 | 14:41:31:65 | 14:45:53:98 | 4 min 22,33 s (26233 centésimas) |
| 3 | 20000 | 14:48:08:32 | 14:48:21:45 | 13,13 s (1313 centésimas) |

### Decisiones técnicas de DOSBox

Pendiente: justificar el valor de `cycles` y diferenciar las instrucciones emuladas de los ciclos reales de la CPU anfitriona, con un mínimo de 100 palabras por decisión.

## Parte 2 — VirtualBox y Alpine Linux

Pendiente: instalación de VirtualBox y Alpine Linux; configuración de red, snapshots, recursos, comparación de discos y exportación OVA.

| Modo de red | Dirección IP observada | Prueba |
|---|---|---|
| NAT | Pendiente | Pendiente |
| Host-only | Pendiente | Pendiente |
| Bridge | Pendiente | Pendiente |

### Mediciones de disco

| Tipo de disco | Tamaño de prueba | Tiempo observado |
|---|---:|---|
| Dinámico | 200 MB | Pendiente |
| Fijo | 200 MB | Pendiente |

### Decisiones técnicas de VirtualBox

Pendiente: justificar el modo de red y sus implicaciones de seguridad, y comparar disco fijo/dinámico junto con la asignación de CPU/RAM. Cada decisión tendrá un mínimo de 100 palabras y se basará en las observaciones del laboratorio.

## Capturas

Se agregarán las evidencias reales de los ocho checkpoints de DOSBox y los ocho checkpoints de VirtualBox en `capturas/`.

## Conclusión

Pendiente: comparar, a partir de la práctica, la emulación de DOSBox con la virtualización de VirtualBox.
