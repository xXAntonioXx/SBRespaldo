;arreglo_cuadrados.asm

%include 'funciones_basicas.asm'

section .data
  msgPromedioArea   DB  'Promedio de areas:',0
  msgPromedioPerim  DB  'Promedio de Perimetros:',0

segment .bss
	arreglo_enteros  resb 200         ;50 casillas de 4 bytes c/u

section .text
	global _start:

_start:
  ;BLOQUE INICIAL: Revisamos si hay suficientes argumentos
	pop ecx			;obtenemos el numero de argumentos
	cmp ecx,2		;comparamos si es menor a 2
	jl salir 		;salimos si es menor a 2

  ;BLOQUE de INICIALIZACION
	pop eax			;obtenemos nombre de programa
	dec ecx			;restamos 1 al numero de argumentos
	mov ebx,ecx
	mov edx, 0		;ponemos en 0 EDX
	mov esi,arreglo_enteros   ;la direccion de 'array' a ESI

  ;CICLO DE EXTRACCION DE ARGUMENTOS
ciclo:
	pop eax				;sacamos direccion de argumento del stack
	call atoi			;lo convertimos a entero de 4 bytes
	mov [esi+edx*4],eax	;lo guardamos en array
	inc edx					;incrementamos el indice del array
	dec ecx					;decrementamos numero de argumentos por procesar
	cmp ecx,0				;preguntamos si ya no tenemos argumentos
	jne ciclo 				;ciclar en caso de que si existan argumentos
limpiar:
	mov eax,0

  ;CICLO DE IMPRESION
ciclo_impresion:
  add eax, [esi+ecx*4];traemos de array numero a imprimir
  ;call iprintLF         ;imprimimos numero
  ;call iprintLF
  inc ecx               ;incrementamos indice de array
  dec edx               ;decrementamos contador
  cmp edx,0             ;llegamos a 0?
  jne ciclo_impresion   ;ciclar en caso de no llegar a cero

operacion:
	call iprintLF
	div ebx
	call iprintLF 

salir:
	mov eax,1
    int 0x80
