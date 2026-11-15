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

VirtualBox 7.2.22 y una VM `Lab5-Alpine` con Alpine Linux 3.19.0 se instalaron en un VDI dinámico de 10 GiB. La instalación se completó en el disco `/dev/sda`; el ISO se retiró y la VM arrancó desde el disco virtual. Se creó el snapshot `Base Alpine instalado y NAT`.

La primera comprobación se hizo con 1 CPU y 1024 MiB: `nproc` indicó 1; `free -m` informó 969 MiB de memoria total para el sistema invitado. Con NAT, `ip addr` mostró `10.0.2.15/24` y `ping -c 3 1.1.1.1` recibió 3 de 3 respuestas (0 % de pérdida). La renovación DHCP del adaptador en modo Host-only obtuvo `192.168.56.101/24`; el modo Bridge sobre `Realtek RTL8852BE-VS WiFi 6 802.11ax PCIe Adapter` obtuvo `192.168.80.51/24`.

Después de probar los tres modos de red, la VM quedó con 2 CPU y 2048 MiB asignados; Alpine confirmó `nproc = 2` y `free -m = 1976 MiB` utilizables. La VM regresó a NAT. Se creó el snapshot `Pruebas de disco completadas`; para comprobar la restauración se cambió temporalmente la NIC a Host-only y luego se restauró el snapshot. `showvminfo` confirmó que la configuración volvió a NAT, con 2 CPU y 2048 MiB. El árbol de snapshots conserva `Base Alpine instalado y NAT`, `Antes de pruebas de disco` y `Pruebas de disco completadas`.

| Modo de red | Dirección IP observada | Prueba |
|---|---|---|
| NAT | `10.0.2.15/24` | Ping a `1.1.1.1`: 3/3 recibidos, 0 % de pérdida |
| Host-only | `192.168.56.101/24` | Lease DHCP del host-only `192.168.56.100` |
| Bridge (Wi-Fi) | `192.168.80.51/24` | Lease DHCP del router `192.168.80.1` |

### Mediciones de disco

Se crearon dos discos de prueba de 4 GiB: `Comparacion-Dinamico.vdi` y `Comparacion-Fijo.vdi`. Cada uno se particionó, formateó con ext4, montó por separado y recibió el mismo archivo de 200 MiB mediante `dd` con `conv=fsync` para forzar el vaciado al disco.

| Tipo de disco | Escritura medida | Tiempo `real` | Rendimiento informado por `dd` |
|---|---:|---:|---:|
| Dinámico | 200 MiB | 2,10 s (2,093411 s de copia) | 95,5 MB/s |
| Fijo | 200 MiB | 2,33 s (2,327281 s de copia) | 85,9 MB/s |

Estos resultados son una sola corrida por disco en esta VM y no constituyen un benchmark universal: el anfitrión, la caché, el sistema de archivos y la carga de VirtualBox también influyen. En esta observación el dinámico fue ligeramente más rápido; por tanto, no se atribuye la diferencia a una ventaja general de ese formato.

### Decisiones técnicas de VirtualBox

#### Modo de red e implicaciones de seguridad

Para una VM de laboratorio personal, el estudiante elige NAT como configuración habitual. En la prueba, NAT entregó la dirección `10.0.2.15/24` y permitió que la VM iniciara conexiones salientes, incluida la prueba ICMP a `1.1.1.1`, sin colocarla directamente como otro equipo visible en la LAN doméstica. Host-only sería preferible para practicar servicios entre la VM y el anfitrión en un entorno aislado, o para simular una red privada de laboratorio; se pierde la salida directa a Internet salvo que se configure enrutamiento adicional. Bridge fue útil para comprobar la obtención de DHCP del router, pero expone la VM a la misma red local y hace que servicios activos, como SSH si se instalara y habilitara, puedan ser alcanzables por otros dispositivos de esa red. La dirección observada `192.168.80.51/24` confirma esa presencia directa. Por ello, el estudiante conserva NAT por defecto y usa Host-only o Bridge solo cuando el objetivo del ejercicio requiere esa conectividad concreta.

#### Disco, CPU y RAM

En la corrida registrada, el disco dinámico escribió 200 MiB en 2,09 s (95,5 MB/s) y el fijo en 2,33 s (85,9 MB/s), así que el dinámico resultó más rápido en esta medición específica; la diferencia no permite afirmar que siempre lo sea, porque una única ejecución depende también de la caché y de la carga del anfitrión. El disco fijo reserva su espacio de 4 GiB desde el inicio y evita expandir gradualmente el archivo VDI conforme se escriben bloques; esa reserva puede reducir variabilidad, pero ocupa el espacio completo incluso si el huésped usa poco. El dinámico conserva espacio en el equipo anfitrión mientras el huésped no llene el disco asignado, una ventaja práctica para cursos y computadores con almacenamiento limitado. La VM quedó con 2 CPU y 2048 MiB: Alpine mostró 2 procesadores y 1976 MiB utilizables. Esa asignación ofrece recursos suficientes para el ejercicio y deja capacidad para Windows anfitrión; asignarle todos los procesadores o la mayor parte de la RAM podría ralentizar el anfitrión y otras aplicaciones.

### Exportación y conclusiones

La VM se exportó correctamente como `Rubio_Post5_U5.ova` en `C:\Users\USUARIO\VirtualBox VMs\Lab5-Alpine\`; el archivo ocupa 151.727.616 bytes (aprox. 144,7 MiB). El OVA y los VDI de prueba permanecen fuera del repositorio, de acuerdo con la guía para no versionar archivos grandes. En esta práctica, DOSBox emula por software un entorno x86/DOS de 16 bits y su parámetro `cycles` cambia el ritmo de ejecución emulado. VirtualBox, en cambio, ejecuta un sistema operativo huésped completo sobre hardware virtualizado, asigna CPU y RAM y permite cambiar interfaces de red, snapshots y discos virtuales. Las mediciones observadas confirman que cada herramienta responde a un propósito distinto: DOSBox sirve para reproducir programas DOS ligeros, mientras VirtualBox permite instalar y administrar un sistema Linux aislado, con costos de recursos y almacenamiento más cercanos a una máquina independiente.

## Capturas

- CP1, estructura del repositorio: `capturas/cp1_estructura.png`.
- CP2, DOSBox y NASM: `capturas/cp2_dosbox_nasm.png`.
- CP3, saludo: `capturas/cp3_saludo.png`.
- CP4, entrada de teclado y eco hexadecimal: `capturas/cp4_entrada.png`.
- CP5, desensamblado y ejecución paso a paso en DEBUG: `capturas/cp5_debug.png`.
- CP6, medición inicial con `cycles=8000`: `capturas/cp6_ciclos_8000.png`.
- CP7, comparación con `cycles=1000` y `cycles=20000`: `capturas/cp7_ciclos_1000.png` y `capturas/cp7_ciclos_20000.png`; la corrida de referencia `8000` está en CP6.
- CP8, tabla y primera decisión de `cycles`: `capturas/cp8_tabla_decision_cycles.png`.
- CP8, segunda decisión sobre ciclos emulados y ciclos reales del anfitrión: `capturas/cp8_decision_cycles_host.png`.
- Parte 2, NAT e inventario de CPU/RAM: `capturas/p2_nat_recursos.png`.
- Parte 2, obtención de dirección por DHCP Host-only: `capturas/p2_hostonly.png`.
- Parte 2, obtención de dirección por DHCP Bridge sobre Wi-Fi: `capturas/p2_bridge.png`.
- Parte 2, verificación dentro de Alpine de 2 CPU y 2048 MiB: `capturas/p2_recursos_final.png`.
- Parte 2, benchmark de escritura en disco dinámico: `capturas/p2_benchmark_dinamico.png`.
- Parte 2, benchmark de escritura en discos dinámico y fijo: `capturas/p2_benchmark_resultados.png`.
- Parte 2, árbol de snapshots con `Pruebas de disco completadas` activa: `capturas/p2_snapshots.png`.
- Parte 2, archivo OVA y tamaño visibles en el Explorador: `capturas/p2_export_ova.png`.

## Conclusión

La práctica muestra que la emulación de DOSBox prioriza recrear un entorno legado concreto con un costo bajo de recursos y control de velocidad mediante `cycles`. VirtualBox permite ejecutar Alpine como sistema huésped completo, adaptar CPU, RAM y red, y guardar estados recuperables mediante snapshots; al restaurar el snapshot final, la red volvió de Host-only a NAT. En el equipo usado, NAT permitió conectividad saliente con aislamiento de la LAN, mientras Bridge incorporó la VM a la red doméstica. El benchmark de 200 MiB produjo resultados próximos y dependientes de la ejecución; para elegir almacenamiento también pesan la reserva inmediata del disco fijo y el menor uso inicial de espacio del dinámico.
