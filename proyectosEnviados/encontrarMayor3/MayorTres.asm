%include 'funciones_basicas.asm'

SECTION .text
GLOBAL _start

_start:
	pop ecx ;sacas la cantidad de argumentos
	mov ecx,0
	pop ecx ;sacar el titulo del ejecutable
	mov ecx,0
	pop eax ;sacas el primer argumento y se guarda en eax
	call atoi ; conviertes el primer argumento en eax se convierte en numero
	mov ecx,eax ;muves ese numero convertido, lo pasas a ecx donde no te estorba
	pop eax ;sacas el segundo argumento y pasa a eax
	call atoi ;lo conviertes en numero
	mov ebx,eax ;lo mueves a ebx donde no te moleste
	pop eax ;sacas el ultimo argumento y lo pones en eax
	call atoi;tambien lo conviertes en numero
	;ahora en los registros eax,ebx y ecx estan los numeros para hacer la comparacion
	call compararParteDos
	mov ebx,ecx
	call compararParteDos
	call iprint
	jmp salida

	;ocupas una funcion que compare dos y lo devuelva en eax