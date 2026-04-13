; ============================================================
; programa.asm - Laboratorio Post-Contenido 1, Unidad 4
; Asignatura : Arquitectura de Computadores - UFPS 2026
; Entorno    : NASM 16-bit para DOS en DOSBox con ALINK
; Proposito  : Demostrar directivas de seccion, datos y
;              constantes en NASM, e interrupciones DOS INT 21h
; ============================================================

; === Constantes (EQU — no reservan memoria) ===
CR          EQU 0Dh         ; Carriage Return: retorno de carro
LF          EQU 0Ah         ; Line Feed: salto de linea
TERMINADOR  EQU 24h         ; "$" delimitador de cadena para INT 21h funcion 09h
ITERACIONES EQU 5           ; numero de elementos en tabla_bytes

; ============================================================
; Segmento de datos inicializados
; Contiene mensajes, variables y tabla de bytes
; ============================================================
segment data

    ; --- Mensajes de texto (terminados en "$" para INT 21h/09h) ---
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (byte convertido a ASCII): ", TERMINADOR
    etiqueta_t  db "Tabla de bytes: ", TERMINADOR
    fin_msg     db "Programa finalizado correctamente.", CR, LF, TERMINADOR

    ; --- Variables de distintos tipos de datos ---
    var_byte    db 42           ; 1 byte  — valor decimal 42
    var_word    dw 1234h        ; 2 bytes — valor hexadecimal 0x1234
    var_dword   dd 0DEADBEEFh   ; 4 bytes — valor hexadecimal

    ; --- Tabla de 5 bytes con valores de un digito (1-5) ---
    ; Se usan valores del 1 al 5 para que la conversion +30h
    ; produzca correctamente los caracteres ASCII '1' al '5'
    tabla_bytes db 1, 2, 3, 4, 5

; ============================================================
; Segmento de datos no inicializados (BSS)
; El espacio se reserva pero no se escribe en el ejecutable
; ============================================================
segment bss

    buffer      resb 80     ; 80 bytes reservados para buffer de entrada
    resultado   resw 1      ; 1 word reservado para almacenar resultado

; ============================================================
; Segmento de codigo ejecutable
; ============================================================
segment code

    global main

main:
    ; --- Inicializar DS para que apunte al segmento de datos ---
    ; Es obligatorio inicializar DS manualmente en DOS de 16 bits
    mov ax, data
    mov ds, ax

    ; === INT 21h / Funcion 09h: imprimir cadena terminada en "$" ===

    ; Imprimir mensaje de bienvenida
    mov ah, 09h
    mov dx, bienvenida
    int 21h

    ; Imprimir separador
    mov ah, 09h
    mov dx, separador
    int 21h

    ; Imprimir etiqueta de variable A
    mov ah, 09h
    mov dx, etiqueta_a
    int 21h

    ; === INT 21h / Funcion 02h: imprimir un caracter individual en DL ===

    ; Imprimir valor de var_byte convertido a ASCII
    ; var_byte = 42; 42 + 48 (30h) = 90 ASCII = caracter 'Z'
    mov al, [var_byte]      ; AL = 42
    add al, 30h             ; conversion a ASCII: 42 + 48 = 90 ('Z')
    mov ah, 02h             ; funcion DOS: imprimir caracter en DL
    mov dl, al
    int 21h

    ; Imprimir salto de linea
    mov ah, 02h
    mov dl, CR
    int 21h
    mov ah, 02h
    mov dl, LF
    int 21h

    ; Imprimir etiqueta de la tabla
    mov ah, 09h
    mov dx, etiqueta_t
    int 21h

    ; === Bucle: recorrer tabla_bytes e imprimir cada elemento ===
    ; Se usa SI como puntero y LOOP para decrementar CX automaticamente
    mov si, tabla_bytes     ; SI apunta al primer byte de la tabla
    mov cx, ITERACIONES     ; CX = 5 (numero de iteraciones)

imprimir_tabla:
    mov al, [si]            ; AL = byte actual (1, 2, 3, 4 o 5)
    add al, 30h             ; conversion a ASCII: 1->'1', 2->'2', etc.
    mov ah, 02h             ; funcion DOS: imprimir caracter
    mov dl, al
    int 21h

    mov ah, 02h             ; imprimir espacio entre elementos
    mov dl, 20h             ; codigo ASCII del espacio en blanco
    int 21h

    inc si                  ; avanzar puntero al siguiente byte
    loop imprimir_tabla     ; CX--; si CX != 0 repetir el bucle

    ; Imprimir salto de linea despues de la tabla
    mov ah, 02h
    mov dl, CR
    int 21h
    mov ah, 02h
    mov dl, LF
    int 21h

    ; Imprimir mensaje de finalizacion
    mov ah, 09h
    mov dx, fin_msg
    int 21h

    ; === Terminar el programa (funcion 4Ch, codigo de salida 0) ===
    mov ax, 4C00h
    int 21h
