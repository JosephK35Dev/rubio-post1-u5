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

Los tres programas se ensamblan desde la raíz del disco C: montado en DOSBox:

```text
NASM -f bin SRC\SALUDO.ASM -o BIN\SALUDO.COM
NASM -f bin SRC\ENTRADA.ASM -o BIN\ENTRADA.COM
NASM -f bin SRC\CICLOS.ASM -o BIN\CICLOS.COM
```

`saludo.com` imprime el título del laboratorio, el nombre Rubio y la unidad. En `entrada.com`, al presionar `a`, se observó `Caracter recibido: a` y el código hexadecimal `61`. DEBUG desensambló el programa desde `CS:0100` y permitió ejecutar sus tres primeras instrucciones con `T`; la pantalla registra los valores reales de los registros.

### Mediciones de ciclos

| Corrida | cycles | Hora inicial | Hora final | Duración observada |
|---|---:|---|---|---|
| 1 | 8000 | 14:35:08:11 | 14:35:40:90 | 32,79 s (3279 centésimas) |
| 2 | 1000 | 14:41:31:65 | 14:45:53:98 | 4 min 22,33 s (26233 centésimas) |
| 3 | 20000 | 14:48:08:32 | 14:48:21:45 | 13,13 s (1313 centésimas) |

### Decisiones técnicas de DOSBox

#### Valor fijo de `cycles`

El estudiante selecciona `cycles=8000` como configuración de referencia porque mantiene una carga de trabajo idéntica y permite repetir la medición con el mismo límite de emulación. En las corridas observadas, el bucle tardó 32,79 segundos con 8000 cycles, 4 minutos y 22,33 segundos con 1000, y 13,13 segundos con 20000. Los resultados muestran que reducir el valor alarga la ejecución y aumentarlo la acorta. `cycles=max` dejaría que el anfitrión ejecute el bucle a la máxima velocidad que pueda sostener DOSBox, por lo que el tiempo dependería demasiado del equipo y podría resultar muy breve. `cycles=auto` ajusta el límite según la carga detectada y puede variar entre corridas. El valor fijo no elimina todas las diferencias entre equipos, pero sí mantiene constante un parámetro experimental. `cycles=max` o `auto` sería más útil para software que necesita responder con rapidez y no depende de una temporización histórica reproducible.

#### Cycles emulados frente a ciclos reales del anfitrión

El estudiante distingue el valor `cycles` del archivo de configuración de la frecuencia física de la CPU anfitriona. El valor 8000 no significa que el procesador Ryzen del equipo funcione a 8000 ciclos reales por segundo; representa el límite de trabajo de CPU que DOSBox intenta emular para el programa invitado. Para ejecutar una instrucción x86 de 16 bits, el emulador realiza trabajo adicional en el sistema anfitrión, de modo que el proceso `DOSBox.exe` consume ciclos reales del procesador que no se reflejan directamente en esa cifra. Las mediciones observadas —32,79 segundos a 8000 frente a 13,13 a 20000— comparan el reloj DOS emulado bajo dos límites, no cuentan los ciclos físicos del silicio. Si se requiere estimar el consumo real del anfitrión, el estudiante usaría el Administrador de tareas o un perfilador de procesos para observar el uso de CPU de DOSBox durante la ejecución.

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

- CP2, DOSBox y NASM: `capturas/cp2_dosbox_nasm.png`.
- CP3, saludo: `capturas/cp3_saludo.png`.
- CP4, entrada de teclado y eco hexadecimal: `capturas/cp4_entrada.png`.
- CP5, desensamblado y ejecución paso a paso en DEBUG: `capturas/cp5_debug.png`.
- CP6, medición inicial con `cycles=8000`: `capturas/cp6_ciclos_8000.png`.
- CP7, comparación con `cycles=1000` y `cycles=20000`: `capturas/cp7_ciclos_1000.png` y `capturas/cp7_ciclos_20000.png`; la corrida de referencia `8000` está en CP6.
- CP1 (árbol de directorios) y CP8 (README con decisiones y tabla): pendientes de captura.
- Parte 2, VirtualBox: pendiente.

## Conclusión

Pendiente: comparar, a partir de la práctica, la emulación de DOSBox con la virtualización de VirtualBox.
