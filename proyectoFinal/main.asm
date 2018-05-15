;integrantes de equipo
;	Alfredo Murillo Casas
;	Jose Antonio Gonzalez Munguia
;	Eduardo Varela


%include 'funciones_basicas.asm'
%include 'instruccion.asm'

section .data
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
	bufferOpcion resb 10 ;aqui es donde se almacena en valor numerico la opcion seleccionada
	bufferOpcionLen equ $-bufferOpcion ;longitud de la opcion sirve para indicar el fin en memoria del buffer de arriba

	valoresNum resb 1024
	finalvaloresNum resb 1024
	;para abrir el archivo

	;para los numbers en forma de caracter
	buffer resb 1024 ;buffer lleva el contenido del archivo
	Len equ 1024	;indica donde acaba en memoria el buffer

	;para los numeros en valor numerico
	numeroArg resb 16 ;¡¡¡MUY IMPORTANTE!!! aqui estan guardados los numeros
	temporalNum resb 3 ;auxiliar para concatenar caracteres y hacerlos numeros

	;para el resultado de las operaciones(arreglo de resultados)
	resultadosArg resb 16 ;arreglo donde se almacenan los numeros resultado de las operacion hechos con los originales(numeroArgs)	

section .text
	GLOBAL _start:

_start:
	pop ecx ;sacamos el numero de argumentos
    pop edx ;saco el titulo del programa
    dec ecx ;le restamos uno al numero de argumentos
    pop ebx ;aqui el titulo del archivo
	;mov ecx,buffer
	call abrir_el_archivo ;abrimos el archivo para sacar su contenido
	;mov eax,buffer
	;call sprintLF


	mov eax,buffer;pasamos el buffer para sacar la longitud
	call strlen
	mov edx,eax ;edx ahora tiene la cantidad de caracteres que tiene el buffer
	;mov esi,paraPasar
	mov eax,temporalNum
	mov esi,buffer
	;mov edi,numeroArg
	call pasar_numero

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

;ABRIR EL ARCHIVO:			 	 ;
;	es tomado del ejemplo 		 ;
;	en clase para leer archivos  ;
abrir_el_archivo:
     
    mov eax,sys_open ;preparamos la instruccion de lectura
    mov ecx,0 ;read only
    int 80h ;ejecutar
    cmp eax,0 ;si hay un error regresara 0 o un numero negativo
    jle error ;si es menor o igual a cero es que sucedio un error o el archivo esta vacio

    mov ebx,eax ;movemos a ebx el handler por que necesitamos eax
    mov eax,sys_read ;preparas la instruccion para leer
    mov ecx,buffer ;pasamos a ecx la direccion del buffer donde se almacena el contenido
    mov edx,Len
    int 80h

    mov eax,sys_close ;para cerrar la instruccion de lectura
    int 80h

    ret

error:
    mov ebx,eax ;no se para que respaldamos el valor de eax en ebx
    mov eax,sys_exit ;se prepara para terminar
    int 80h

;pasar como numeros
pasar_numero:
	push ecx ;salvar el contador
	mov ecx,0 ;preparalo para utilizarlo
	mov ebp,0 ;contador para recorrer cada caracter del buffer

caracter:
	cmp ecx,edx ;compara el prinipio del proceso con la longitud del buffer Leido
	je mostrarMenu
	mov bl,byte[esi+ecx] ;pasar a bl el caracter del buffer
	cmp bl,0xA ;comparar el caracter con el salto de linea
	je guardar ;si el salto de linea aprace preparate para convertir y guardar
	mov [eax+ebp],bl ;concatenar el caracter a cada byte de eax en el punto ebp
	inc ebp ;ebp es la direccion en byte del buffer de eax
	inc ecx ;ecx es la direccion del buffer leido en esi
	call caracter

guardar:
	call atoi ;convierte el eax en numero
	mov ebp,numeroArg
	mov [ebp+edi*4],eax ;guarda el primer numero
	inc edi ;contador para la direccion del arreglo de numeros
	inc ecx ;contador para la cantidad de caracteres sacados del buffer
	mov eax,temporalNum ;limpiamos eax
	;mov esp,temporalNum
	mov ebp,0
	;call limpiarTemp
	mov ebp,0
	call caracter
;continuacion: ;esto es para que la ejecucion siga, por que se me pierde el ret
;	mov ebp,0
;	call caracter

mostrarMenu:
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
;limpiarTemp:
;	cmp ebp,3
;	jl clean
;	mov ebp,0
;	mov eax,temporalNum
;	call continuacion
;clean:
;	mov bl,0xa
;	mov [esp+ebp],bl
;	mov eax,bandera
;	mov eax,temporalNum
;	call sprintLF
;	inc ebp
;	jmp limpiarTemp