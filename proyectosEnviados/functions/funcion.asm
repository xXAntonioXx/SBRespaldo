section .data
	string1 DB 'cadena1',0xA,0x0
	string2 DB 'cadena2blablabla',0xA,0x0
	string3 DB 'cadena3',0xA,0x0

section .text
	GLOBAL _start

_start:
	mov EAX,string1
	call sprint
	mov EAX, string2
	call sprint
	mov EAX, string3
	call sprint
	mov EAX,1 ;aqui termina
	int 0x80



strlen:
	PUSH EBX
	mov EBX,EAX

sigcar:
	cmp byte[EAX],0
	jz finalizar
	inc EAX
	jmp sigcar

finalizar:
	sub EAX,EBX
	POP EBX
	ret

sprint:
	PUSH EDX
	PUSH ECX
	PUSH EBX
	PUSH EAX
	call strlen
	mov EDX,EAX
	POP EAX
	mov ECX,EAX
	mov EAX,4 ;ESTO ES PARA ESCRIBIR
	mov EBX,1 ;salida del sistema
	int 0x80
	POP EBX
	POP ECX
	POP EDX
	ret