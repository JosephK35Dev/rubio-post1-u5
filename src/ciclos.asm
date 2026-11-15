; Programa 3: registrar la hora DOS antes y despues de un bucle fijo.
org 100h

section .text
    mov  ah, 09h
    mov  dx, msg_inicio
    int  21h

    mov  ah, 2Ch             ; CH=h, CL=min, DH=seg, DL=cent segundo.
    int  21h
    mov  [hora_inicio], ch
    mov  [min_inicio], cl
    mov  [seg_inicio], dh
    mov  [cs_inicio], dl

    mov  cx, 2000
.bucle_externo:
    push cx
    mov  cx, 0FFFFh
.bucle_interno:
    inc  ax
    loop .bucle_interno
    pop  cx
    loop .bucle_externo

    mov  ah, 2Ch
    int  21h
    mov  [hora_final], ch
    mov  [min_final], cl
    mov  [seg_final], dh
    mov  [cs_final], dl

    mov  ah, 09h
    mov  dx, msg_tiempo_inicio
    int  21h
    mov  al, [hora_inicio]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [min_inicio]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [seg_inicio]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [cs_inicio]
    call imprimir_dos_digitos

    mov  ah, 09h
    mov  dx, msg_tiempo_final
    int  21h
    mov  al, [hora_final]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [min_final]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [seg_final]
    call imprimir_dos_digitos
    call imprimir_dos_puntos
    mov  al, [cs_final]
    call imprimir_dos_digitos

    mov  ah, 09h
    mov  dx, msg_fin
    int  21h
    mov  ax, 4C00h
    int  21h

imprimir_dos_puntos:
    mov  ah, 09h
    mov  dx, dos_puntos
    int  21h
    ret

; Convierte AL (0-99) en dos digitos decimales y los imprime.
imprimir_dos_digitos:
    aam
    xchg ah, al
    push ax
    add  al, 30h
    mov  dl, al
    mov  ah, 02h
    int  21h
    pop  ax
    mov  al, ah
    add  al, 30h
    mov  dl, al
    mov  ah, 02h
    int  21h
    ret

section .data
msg_inicio       db 'Midiendo bucle de trabajo fijo...', 0Dh, 0Ah, '$'
msg_tiempo_inicio db 'Hora inicial (hh:mm:ss:cc): $'
msg_tiempo_final db 0Dh, 0Ah, 'Hora final   (hh:mm:ss:cc): $'
msg_fin          db 0Dh, 0Ah, 'Medicion completa. Compare el campo cc (centesimas).', 0Dh, 0Ah, '$'
dos_puntos       db ':$'
hora_inicio      db 0
min_inicio       db 0
seg_inicio       db 0
cs_inicio        db 0
hora_final       db 0
min_final        db 0
seg_final        db 0
cs_final         db 0
