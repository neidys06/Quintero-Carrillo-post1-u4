; ============================================================
; programa.asm — Laboratorio Post-Contenido 1, Unidad 4
; Asignatura : Arquitectura de Computadores — UFPS 2026
; Propósito  : Demostrar directivas de sección, definición de
;              datos (DB, DW, DD), constantes EQU, inicialización
;              de registros de segmento e INT 21h (09h y 02h)
; Entorno    : MASM, modo DOS 16-bit, ejecutado en DOSBox
; ============================================================

.MODEL SMALL        ; Modelo de memoria: 1 segmento código, 1 segmento datos
.STACK 100h         ; Reservar 256 bytes para la pila del programa

; ── CONSTANTES — No reservan memoria, son alias numéricos ──────────────
CR          EQU 0Dh     ; Carriage Return: mueve cursor al inicio de línea
LF          EQU 0Ah     ; Line Feed: baja el cursor una línea
TERMINADOR  EQU 24h     ; Carácter '$' que DOS usa para terminar cadenas
ITERACIONES EQU 5       ; Número de elementos en la tabla de bytes

; ── SECCIÓN .DATA — Variables y cadenas con valor inicial ──────────────
.DATA

    ; Mensajes de texto terminados en '$' (requerido por función 09h)
    bienvenida  DB "=== Laboratorio MASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   DB "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  DB "Variable A (word):  ", TERMINADOR
    fin_msg     DB "Programa finalizado correctamente.", CR, LF, TERMINADOR

    ; Variables de distintos tamaños para demostrar directivas de datos
    var_byte    DB 42           ; 1 byte  (8 bits)  con valor decimal 42
    var_word    DW 1234h        ; 2 bytes (16 bits) con valor 0x1234
    var_dword   DD 0DEADBEEFh  ; 4 bytes (32 bits) con valor 0xDEADBEEF

    ; Arreglo de 5 bytes consecutivos en memoria
    tabla_bytes DB 10, 20, 30, 40, 50

; ── SECCIÓN .DATA? — Variables sin valor inicial (equivale a .bss) ─────
.DATA?

    buffer      DB 80 DUP(?)   ; Reserva 80 bytes sin inicializar
    resultado   DW 1 DUP(?)    ; Reserva 1 word (2 bytes) sin valor

; ── SECCIÓN .CODE — Código ejecutable del programa ─────────────────────
.CODE

MAIN PROC
    ; ── Inicializar el registro de segmento de datos ──────────────────
    ; DS no acepta valores inmediatos directamente.
    ; Se usa AX como registro intermediario obligatorio.
    MOV AX, @DATA           ; AX recibe la dirección del segmento de datos
    MOV DS, AX              ; DS apunta correctamente a la sección .DATA

    ; ── Imprimir mensaje de bienvenida (función 09h) ───────────────────
    ; AH=09h, DX=dirección de cadena terminada en '$'
    MOV AH, 09h
    LEA DX, bienvenida      ; LEA carga la dirección efectiva de bienvenida
    INT 21h

    ; ── Imprimir línea separadora ──────────────────────────────────────
    MOV AH, 09h
    LEA DX, separador
    INT 21h

    ; ── Imprimir etiqueta descriptiva ─────────────────────────────────
    MOV AH, 09h
    LEA DX, etiqueta_a
    INT 21h

    ; ── Demostración función 02h: imprimir un carácter individual ──────
    ; var_byte contiene 42. Al sumarle 30h (48 decimal):
    ; 42 + 48 = 90, que corresponde al carácter 'Z' en ASCII.
    MOV AL, var_byte        ; AL = 42 (valor almacenado en var_byte)
    ADD AL, 30h             ; Conversión a ASCII: 42 + 48 = 90 → 'Z'
    MOV AH, 02h             ; Función 02h: imprimir el carácter en DL
    MOV DL, AL              ; DL = 'Z'
    INT 21h

    ; ── Imprimir salto de línea ────────────────────────────────────────
    MOV AH, 02h
    MOV DL, CR
    INT 21h
    MOV AH, 02h
    MOV DL, LF
    INT 21h

    ; ── Recorrer tabla_bytes e imprimir cada elemento ─────────────────
    ; SI apunta al inicio del arreglo, CX controla las iteraciones.
    LEA SI, tabla_bytes     ; SI = dirección del primer byte del arreglo
    MOV CX, ITERACIONES     ; CX = 5 (un elemento por iteración)

RECORRER_TABLA:
    MOV AL, [SI]            ; AL = byte actual apuntado por SI
    ADD AL, 30h             ; Conversión simple a ASCII (válido para 0-9)
    MOV AH, 02h             ; Función 02h: imprimir carácter
    MOV DL, AL
    INT 21h

    ; Imprimir espacio entre elementos
    MOV AH, 02h
    MOV DL, 20h             ; 20h = código ASCII del espacio en blanco
    INT 21h

    INC SI                  ; Avanzar SI al siguiente byte del arreglo
    LOOP RECORRER_TABLA     ; CX--; si CX != 0, repetir

    ; ── Salto de línea después de la tabla ────────────────────────────
    MOV AH, 02h
    MOV DL, CR
    INT 21h
    MOV AH, 02h
    MOV DL, LF
    INT 21h

    ; ── Imprimir mensaje de finalización ──────────────────────────────
    MOV AH, 09h
    LEA DX, fin_msg
    INT 21h

    ; ── Terminar el programa (función 4Ch de INT 21h) ─────────────────
    ; AH=4Ch indica fin de programa, AL=00h es el código de salida (0=éxito)
    MOV AX, 4C00h
    INT 21h

MAIN ENDP
END MAIN