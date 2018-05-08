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

sprintLF:
	call sprint
	push EAX
	mov EAX,0xA
	push EAX
	mov EAX,ESP
	call sprint
	pop EAX
	pop EAX
	ret

salida:
	mov EAX,1
	int 0x80