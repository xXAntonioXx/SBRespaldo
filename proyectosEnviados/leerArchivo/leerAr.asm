%include 'funciones_basicas.asm'

section .data

section .bss
	buffer resb 1024
	len equ 1024 ;tambien puede ser $-buffer
	file resb 20
	filelen resb 4

section .text
GLOBAL _start

_start:
	pop ecx
	pop eax
	dec ecx

	pop ebx ;creo que aqui es donde sacas el titulo del codigo
	mov eax,sys_open ;es la instruccion que indica apertura de archivo
	mov ecx,0 ;ahora que tenemos el titulo podemos limpiar ecx
	int 80h ;llamada al kernel para ejecutar el sys_open
	cmp eax,0 ;compara el valor con 0
	jle error ;salta por si un error a la funcion error

	mov ebx,eax ;en caso de que no sea cero se respalda en ebx el valor de eax(sospecho yo es el contenido del archivo)
	mov eax,sys_read ;preparas la directiva de lectura
	mov ecx,buffer ;el espacio reservado
	mov edx,len ;longitud
	int 80h ;llamada al kernel para las directivas

	mov eax,sys_close ;listo para cerrar
	int 80h ;llamada al kernel

	mov eax,buffer ;eax recibe el tamaño de de buffer(preguntar esto al profe)
	call sprintLF ;imprime lo que tenga el buffer(esto imprime el buffer osea el contenido del archivo)

	call salida

error:
	mov ebx,eax ;no se para que respaldamos el valor de eax en ebx
	mov eax,sys_exit ;se prepara para terminar
	int 80h ;se ejecuta la instruccion del kernel

;aqui una funcion para copiar
stringCopy:
	;direccion en eax
	;longitud en ebx
	;esi direccion de arreglo de cadena
