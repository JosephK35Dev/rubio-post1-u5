; Programa 2: leer un caracter y mostrarlo junto a su codigo ASCII hexadecimal.
org 100h

section .text
    mov  ah, 09h
    mov  dx, prompt
    int  21h

    mov  ah, 07h             ; Leer un caracter sin eco automatico.
    int  21h
    mov  bl, al

    mov  ah, 09h
    mov  dx, msg_caracter
    int  21h
    mov  ah, 02h
    mov  dl, bl
    int  21h

    mov  ah, 09h
    mov  dx, msg_codigo
    int  21h
    mov  al, bl
    shr  al, 4
    call imprimir_nibble
    mov  al, bl
    and  al, 0Fh
    call imprimir_nibble

    mov  ah, 09h
    mov  dx, nueva_linea
    int  21h
    mov  ax, 4C00h
    int  21h

imprimir_nibble:
    cmp  al, 9
    jbe  .digito
    add  al, 7
.digito:
    add  al, 30h
    mov  dl, al
    mov  ah, 02h
    int  21h
    ret

section .data
prompt       db 'Ingrese una letra (se mostrara su codigo ASCII): $'
msg_caracter db 0Dh, 0Ah, 'Caracter recibido: $'
msg_codigo   db 0Dh, 0Ah, 'Codigo ASCII (hex): $'
nueva_linea  db 0Dh, 0Ah, '$'
