# Quintero-Carrillo-post1-u4

## Descripción

Laboratorio 1 de la Unidad 4 de la asignatura Arquitectura de Computadores
(Universidad Francisco de Paula Santander, Ingeniería de Sistemas, 2026).

Se implementa un programa funcional en lenguaje ensamblador MASM para entorno
DOS de 16 bits, aplicando las directivas de sección (.DATA, .BSS, .CODE) y de
definición de datos (DB, DW, DD, RESB, EQU). Se inicializan correctamente los
registros de segmento y se utiliza la interrupción DOS INT 21h (funciones 09h
y 02h) para producir salida en pantalla. La ejecución se verifica mediante
DOSBox y el proceso queda documentado en este repositorio GitHub.

## Prerrequisitos

- VS Code con la extensión **MASM/TASM** instalada
  (Autor: blindtiger — ID: xsro.masm-tasm)
- DOSBox 0.74 o superior instalado y configurado en la extensión
- Git instalado para control de versiones

## Estructura del repositorio

lab-post1-u4/
├── programa.asm        # Código fuente principal en MASM
├── README.md           # Este archivo de documentación
└── capturas/
    ├── compilacion.png # Captura del proceso de compilación exitoso
    └── ejecucion.png   # Captura de la ejecución en DOSBox

## Compilación y ejecución

### Opción 1 — Desde VS Code (recomendada):
1. Abrir `programa.asm` en el editor
2. Presionar `F6` para compilar y ejecutar automáticamente en DOSBox
3. La extensión invoca `ml.exe` y abre DOSBox con el resultado

### Opción 2 — Manualmente desde DOSBox:

C:> ml programa.asm
C:> programa.exe

## Salida esperada en pantalla
=== Laboratorio MASM - Unidad 4 ===
Variable A (word):  Z
: ; < = >
Programa finalizado correctamente.

## Conceptos demostrados

- Modelo de memoria SMALL con directiva `.MODEL SMALL`
- Declaración de pila con `.STACK`
- Sección de datos inicializados con `.DATA` (DB, DW, DD)
- Sección de datos no inicializados con `.DATA?` (equivalente a .bss)
- Constantes simbólicas con `EQU`
- Inicialización del registro `DS` mediante registro intermediario `AX`
- Función `09h` de `INT 21h` para imprimir cadenas terminadas en `$`
- Función `02h` de `INT 21h` para imprimir caracteres individuales
- Recorrido de arreglo con registro de índice `SI` e instrucción `LOOP`