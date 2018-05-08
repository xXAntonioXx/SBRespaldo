%include 'funciones_basicas.asm'
;%include 'instruccion.asm'

section .data

	delteme db "Seleccionaste la opcion1",0x0
	;opciones
	MENU db "*** Menu ***",0x0
	opcion1 db "1. Agregar dato",0x0
	opcion2 db "2. Generar línea",0x0
	opcion3 db "3. Generar curva",0x0
	opcion4 db "4. Mostrar datos (imprimir)",0x0
	opcion5 db "5. Guardar archivo",0x0
	opcion0 db "0. Salir",0x0
	Opcion db "Opción>",0x0



section .bss
	bufferOpcion resb 10
	bufferOpcionLen equ $-bufferOpcion

	valoresNum resb 1024
	finalvaloresNum resb 1024
	;para abrir el archivo

	;para los numbers
	buffer resb 1024
	Len equ 1024

	paraPasar resb 4
	numeroArg resb 12


section .text
	GLOBAL _start:

_start:
	pop ecx
    pop edx
    dec ecx
    pop ebx ;aqui el titulo del archivo
	;mov ecx,buffer
	call abrir_el_archivo
	;mov eax,buffer
	;call sprintLF


	mov eax,buffer
	mov esi,paraPasar
	mov edi,numeroArg
	call pasarComoNumero


	mov eax,MENU ;mostrar menu
	call sprintLF 
	mov eax,opcion1 ;mostrar agregar dato
	call sprintLF 
	mov eax,opcion2 ;mostrar generar linea
	call sprintLF
	mov eax,opcion3 ;mostrar generar curva
	call sprintLF
	mov eax,opcion4 ;mostrar Mostrar Datos
	call sprintLF 
	mov eax,opcion5 ;mostrar guardar archivo
	call sprintLF
	mov eax,opcion0 ;opcion de salir
	call sprintLF
	call entrada
	call comparar
	call salida

;aqui checas la entrada por teclado y capturas la opcion del usuario
entrada:
	mov eax,Opcion
	call sprint
	mov ecx,bufferOpcion
	mov edx,bufferOpcionLen
	call LeerTexto
	mov eax,bufferOpcion
	call atoi
	ret

comparar:
	cmp eax,1
	je agregarDato
	cmp eax,2
	je generarLinea
	cmp eax,3
	je generarCurva
	cmp eax,4
	je mostrarDatos
	cmp eax,5
	je guardarArchivo
	cmp eax,0
	je salida
	ret

;esto es solo para tener disponible el buffer luego busca como eliminar

abrir_el_archivo:
    

    
    mov eax,sys_open ;preparamos la instruccion de lectura
    mov ecx,0
    int 80h
    cmp eax,0 ;si hay un error regresara 0 o un numero negativo
    jle error

    mov ebx,eax ;movemos a ebx el handler por que necesitamos eax
    mov eax,sys_read ;preparas la instruccion para leer
    mov ecx,buffer ;pasamos a ecx la direccion del buffer donde se almacena el contenido
    mov edx,Len
    int 80h

    mov eax,sys_close ;para cerrar la instruccion de lectura
    int 80h

    mov eax,buffer
    call sprintLF

    ret

error:
    mov ebx,eax ;no se para que respaldamos el valor de eax en ebx
    mov eax,sys_exit ;se prepara para terminar
    int 80h

pasarComoNumero:
	call copystring
	push ebx ;guardamos en el stack el valor de ebx
	push ecx ;guardamos en el stack el valor de ecx
	mov ecx,0 ;lo preparamos para usarlo como contador
	mov eax,esi
	call imprimir_numero
	call atoi
	call iprint
	call salida

imprimir_numero:
	cmp ecx,3
	je salida
	mov bl,[esi+ecx]
	mov [eax],bl
	call atoi
	call iprint
	mov eax,0

	mov bl,byte[esi+8]
	mov eax,ebx
	call atoi
	call iprint
	inc ecx
	call imprimir_numero


