%include 'funciones_basicas.asm'

section .data
	pregunta_nombre db '¿como te llamas? ',0x0
	pregunta_edad db '¿cual es tu edad? ',0x0

section .bss 
	Buffer_nombre resb 20
	Buffer_nombre_len equ $-Buffer_nombre

	Buffer_edad resb 4
	Buffer_edad_len equ $-Buffer_edad

	nombre resb 20
	edad resb 4

section .text
	GLOBAL _start:

_start:
	mov eax,pregunta_nombre
	call sprint
	mov ecx,Buffer_nombre
	mov edx,Buffer_nombre_len
	call LeerTexto

	mov eax,pregunta_edad
	call sprint
	mov ecx,Buffer_edad
	mov edx,Buffer_edad_len
	call LeerTexto
	mov eax,Buffer_edad
	call atoi
	mov [edad],eax

	mov eax,Buffer_nombre
	call sprintLF
	mov eax,[edad]				;
	call iprintLF				;imprime enteros

	call salida					; salida!

LeerTexto:
	mov ebx,stdin
	mov eax,sys_read
	int 0x80
	ret
