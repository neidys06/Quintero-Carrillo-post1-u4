# Quintero Carrillo-post1-u4

## Descripción

Laboratorio 1 de la Unidad 4 — Lenguaje Ensamblador, correspondiente a la asignatura **Arquitectura de Computadores** de Ingeniería de Sistemas (UFPS, 2026).

El programa implementa la estructura completa de un ejecutable NASM de 16 bits para entorno DOS: define datos inicializados y no inicializados usando las directivas `DB`, `DW`, `DD`, `RESB`, `RESW` y `EQU`, inicializa correctamente el registro de segmento `DS`, y produce salida en pantalla utilizando las interrupciones DOS `INT 21h` (función `09h` para cadenas y función `02h` para caracteres individuales). El bucle de impresión de la tabla de bytes demuestra el uso del registro índice `SI` junto con la instrucción `LOOP`.

---

## Prerrequisitos

- **DOSBox 0.74** o superior instalado ([dosbox.com](https://www.dosbox.com))
- **NASM 2.14** o superior — el ejecutable `nasm.exe` debe estar disponible en el PATH de Windows o en la carpeta de trabajo
- **ALINK** — el enlazador `alink.exe` debe estar en la misma carpeta de trabajo (o en el PATH)
- Editor de texto plano (Notepad++, VS Code, etc.) — guardar los `.asm` con codificación **ASCII sin BOM**

---

## Estructura del repositorio

```
quintero carrillo-post1-u4/
├── programa.asm       ← código fuente NASM comentado
├── README.md          ← este archivo
└── capturas/
    ├── Configuración de Entorno.png
    ├── compilacion.png   ← captura de ensamblado y enlazado exitosos
    └── ejecucion.png     ← captura de la salida en DOSBox
```

---

## Compilación y enlazado (terminal de Windows)

Los pasos de ensamblado y enlazado se ejecutan desde la **terminal de Windows** (CMD o PowerShell), no desde DOSBox, porque `nasm.exe` y `alink.exe` son aplicaciones de Windows.

```cmd
:: Paso 1 — Ensamblar: genera el archivo objeto programa.obj
nasm -f obj programa.asm -o programa.obj

:: Paso 2 — Enlazar: genera el ejecutable DOS programa.exe
alink programa.obj -oEXE -o programa.exe -entry main
```

Si NASM detecta errores de sintaxis, los reporta con el número de línea:

```
programa.asm:42: error: parser: instruction expected
```

Corregir el error indicado y repetir el paso 1.

---

## Ejecución en DOSBox

Una vez generado `programa.exe`, copiarlo a la carpeta que DOSBox tiene montada y ejecutarlo desde DOSBox:

```
Z:\> mount C C:\ruta\a\tu\carpeta
Z:\> C:
C:\> programa.exe
```

### Salida esperada en pantalla

```
=== Laboratorio NASM — Unidad 4 ===
Variable A (word):  Z
: : [elementos de la tabla separados por espacios]
Programa finalizado correctamente.
```

## Explicación del código

| Sección | Propósito |
|---------|-----------|
| Constantes `EQU` | Definen `CR`, `LF`, `TERMINADOR` e `ITERACIONES` sin reservar memoria |
| `.data` | Almacena cadenas y variables con valores iniciales (`DB`, `DW`, `DD`) |
| `.bss` | Reserva espacio sin inicializar para `buffer` y `resultado` (`RESB`, `RESW`) |
| `.text` | Contiene el código ejecutable; `main` inicializa `DS` y llama a `INT 21h` |

La instrucción `mov ax, @data` / `mov ds, ax` es **obligatoria** en modo real de 16 bits para que el segmento `DS` apunte correctamente a la sección `.data` antes de cualquier acceso a memoria de datos.

