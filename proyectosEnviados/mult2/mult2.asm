%include 'funciones_basicas.asm'

SECTION .text
	global _start

_start:
	pop ecx

sigArg:
	cmp ecx, 0h
	jz nomasArg
	mul edx
	call iprint
	pop eax
	call atoi
	
	mov edx,eax
	dec ecx
	jmp sigArg

nomasArg:
	call salida

salida:
	mov eax,sys_exit
 	int 0x80