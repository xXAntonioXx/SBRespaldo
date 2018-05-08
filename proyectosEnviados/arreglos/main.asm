%include 'funciones_basicas.asm'
section .bss
	arreglo resb 20
	lon equ $-arreglo

section .text
GLOBAL _start


_start:
	pop ecx ;sacar la cantidad de argumentos
	pop eax ;sacamos el titulo de programa
	;dec ecx ;desconatamos el titulo del programa
	pop eax ;sobrescribimos para sacar el primer argumento del stack
	mov esi,arreglo ;metemos a esi el arreglo
	mov ebx,0

ciclo_del_ciclo:
	dec ecx
	pop eax
	cmp ecx,0
	jz imprimir
	call ciclo
	

ciclo:
	inc ebx
	cmp byte[eax],0 ;comparar cada caracter con 0 buscando el espacio que indica el fin
	jz ciclo_del_ciclo;si se acaba la palabra brinca a la salida
	mov bl,byte[eax] ;mueves a bl el caracter que tenga eax
	mov byte[esi+edx],bl ;mueves al primer espacio del arreglo el valor de bl
	inc edx;incrementas edx para recorrer el arreglo
	inc eax;incrementas eax para referirte al siguiente caracter
	jmp ciclo;se llama asi mismo para buclearse

imprimir:
	cmp ebx,edx
	jz salida
	mov eax,[esi+ebx]
	call sprintLF
	inc ebx
	call imprimir

salida:
    mov eax,1
    int 0x80