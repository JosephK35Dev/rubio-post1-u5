; Programa 1: salida de texto con DOS INT 21h, funcion 09h.
org 100h

section .text
    mov  ah, 09h
    mov  dx, mensaje
    int  21h

    mov  ax, 4C00h
    int  21h

section .data
mensaje db 'Laboratorio 5 - DOSBox y Ensamblador', 0Dh, 0Ah
        db 'Estudiante: Rubio', 0Dh, 0Ah
        db 'Unidad 5 - Arquitectura de Computadores', 0Dh, 0Ah, '$'
