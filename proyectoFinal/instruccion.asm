%include 'funciones_basicas.asm'

;listen resb 10
buffer resb 1024
Len equ 1024

;todo este bloque es para leer el archivo
abrir_el_archivo:
	pop ecx
	pop edx
	dec ecx

	pop ebx ;aqui el titulo del archivo
	mov eax,sys_open ;preparamos la instruccion de lectura
	mov ecx,0
	int 80h
	cmp eax,0 ;si hay un error regresara 0 o un numero negativo
	jle error

	mov ebx,eax ;movemos a ebx el handler por que necesitamos eax
	mov eax,sys_read ;preparas la instruccion para leer
	mov ecx,buffer ;pasamos a ecx la direccion del buffer donde se almacena el contenido
	int 80h

	mov eax,sys_close ;para cerrar la instruccion de lectura
	int 80h

	ret

error:
	mov ebx,eax ;no se para que respaldamos el valor de eax en ebx
	mov eax,sys_exit ;se prepara para terminar
	int 80h

agregarDato:
	mov eax,delteme
	call sprintLF
	ret

generarLinea:
	call salida

generarCurva:
	call salida

mostrarDatos:
	call salida

guardarArchivo:
	call salida



