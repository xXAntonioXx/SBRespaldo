%include "funciones.asm"

section .DATA
	msg1 DB "lo nuestro duro...",0x0
	msg2 DB "lo mismo que duran dos peces en un whiskey on the rocks",0x0

section .text
	GLOBAL _start

_start:
	mov EAX,msg1
	call sprintLF
	mov EAX,msg2
	call sprintLF
	;fin
	jmp salida