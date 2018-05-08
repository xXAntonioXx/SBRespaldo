%include 'funciones_basicas.asm'

SECTION .text
	global _start

_start:
	pop ecx ;tomas la cantidad de argumentos que fueron tecleados
	pop ebx ;le doy el titulo del ejecutable a eax para deshacerme del el
	pop eax ;le doy el primer argumento a eax
	call atoi; convierto eax a un numero int
	mov edx,eax; muevo el numero a edx que me sirve de auxiliar
	pop eax;saco el ultimo argumento y lo acomodo en eax
	call atoi;lo convierto a numero
	call comparar;brincate a comparar
	call compararParteDos
	jmp salida

;comparar:
;	cmp eax,edx ;segun yo el segundo argumento lo compara con el primero que esta en edx
;	jg iprint ;
;	ret

;compararParteDos:
;	cmp edx,eax
;	jg mover2Opcion
;	ret

;mover2Opcion:
;	mov eax,edx
;	jg iprint
;	ret
;salida:
;	mov eax,sys_exit
 ;	int 0x80
