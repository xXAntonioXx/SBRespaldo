%include 'funciones_basicas.asm'

SECTION .text
	global _start

_start:
	pop ecx

sigArg:
	cmp ecx, 0h
	jz nomasArgs
	pop eax
	call sprintLF
	dec ecx
	jmp sigArg

nomasArgs:
	call salida

salida:
	mov eax,sys_exit
	int 0x80
