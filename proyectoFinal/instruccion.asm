section .data
    capture db "Número entero>",0x0

    titulos db "Arreglo de entrada     Arreglo de resultados",0x0
    barra db   "==================     =====================",0x0
                                             
    ;basura de espacios
    sangria db "   ",0x0
    sangria2 db "                       ",0x0

    archivo db "este es un archivo.txt",0x0
    mensajePrueba db "y este es el mensaje de prueba",0x0
    segundoMensaje db "este es otro mensaje",0x0
    longitud equ $-mensajePrueba
    segundaLong equ $-segundoMensaje

section .bss
    numeroCapt resb 4
    numeroCaptLen equ $-numeroCapt
    numero_recivido resb 4

    CadenaImprimir resb 1024
    CadenaFinal resb 1024
    CadenaImprimirLen equ $-CadenaImprimir 
    CadenaFinallong equ $-CadenaFinal

    arregloStream resb 1024
    longitudStream equ $-arregloStream

section .text
agregarDato:
    mov eax,capture
    call sprint
    mov ecx,numeroCapt
    mov edx,numeroCaptLen
    call LeerTexto
    mov eax,numeroCapt
    call atoi
    mov [numero_recivido],eax
    mov ebp,numeroArg
    mov [ebp+edi*4],eax
    mov eax,[ebp]
    call iprintLF
    mov eax,[ebp+4]
    call iprintLF
    mov eax,[ebp+8]
    call iprintLF
    mov eax,[ebp+12]
    call iprintLF

    inc edi
    mov ebp,0

    jmp mostrarMenu

generarLinea:
    push ecx
    mov ecx,0
    mov esi,numeroArg
    mov ebp,resultadosArg ;mov a ebp la direccion del arreglo donde se almacenan los resultados
    call glBucle
    pop ecx
    ;mov eax,[esi]
    ;imul eax,4
    ;call iprint
    ;call salida
    

    jmp mostrarMenu

generarCurva:
    push ecx
    mov ecx,0 ;para usarlo como contador
    push eax
    push edx
    push ebx
    mov esi,numeroArg
    mov ebp,resultadosArg
    call gcBucle
    pop ebx
    pop edx
    pop eax
    pop ecx

    jmp mostrarMenu

mostrarDatos:
	push ecx;
	mov ecx,0
	;aqui es para mostrar en pantalla el arreglo original y enseguida el de resultado
	mov ebp,numeroArg ;recuperamos el arreglo donde estan los numeros de entrada
	mov ebx,resultadosArg ;aqui el arreglo de resultados
	mov eax,titulos ;imprimimos los titulos
	call sprintLF 
	mov eax,barra ;imprimimos una barra que separa como columnas
	call sprintLF
	mov eax,sangria ;damos formato
	call sprint
	;mov eax,[ebp]
	;call iprint
	;mov eax,[ebp+4]
	;call iprint
	call bucle

guardarArchivo:
    ;primero convertir a cadena cada numero
    ;mov ebx,CadenaFinal    ;cadena Final donde se tiene los numeros y resultados
    mov edx,CadenaFinal
    mov ecx,0
    mov esi,CadenaImprimir ;esta cadena funciona como auxiliar para coonvertir a numero
    mov ebp,resultadosArg      ;obtener el buffer con los numeros
    call sacarNumeros
    mov edx,CadenaFinal
    mov eax,edx
    call sprintLF
    push eax
    push ebx
    push ecx
    ;esto crea el archivo
    mov eax,sys_creat
    mov ebx,archivo
    mov ecx,511
    int 80h
    ;aqui se abre el archivo
    mov eax,sys_open
    mov ebx,archivo
    mov ecx,O_RDWR
    int 80h
    mov ebx,eax
    ;y esto escribe en el archivo
    mov eax,sys_write
    mov edx,CadenaFinallong
    mov ecx,CadenaFinal
    int 80h
    ;ahora sincronizar
    mov eax,sys_sync
    int 80h

    ;finalmente se cierra el archivo
    mov eax,sys_close
    int 80h

    cmp eax,0
    jle salida

    mov ebx,eax

    ;ya terminada la apertura
    pop ecx
    pop ebx
    pop eax

    call mostrarMenu


;todo este bucle pertenece a imprimir resultado
bucle:                                        ;
	cmp ecx,edi                               ;
	jl reed                                   ;
	pop ecx                                   ;
	jmp mostrarMenu                           ;
reed:                                         ;
	mov eax,sangria                           ;
	call sprintLF                             ;
	mov eax,[ebp+ecx*4]                       ;
	call iprint                               ;
	mov eax,sangria2                          ;
	call sprint                               ;
	mov eax,[ebx+ecx*4]                       ;
	call iprintLF                             ;
	inc ecx                                   ;
	inc esp                                   ;
	jmp bucle                                 ;
;=============================================

;todo esto es para generarLinea=====================================
glBucle:                                                            ;
    cmp ecx,edi                                                     ;
    jl glOperacion                                                  ;
    ret                                                             ;
                                                                    ;
glOperacion:                                                        ;
    mov eax,[esi+ecx*4] ;leer cada numero en el arreglo principal   ;
    imul eax,4                                                      ;
    add eax,3                                                       ;
    mov [ebp+ecx*4],eax                                             ;
    inc ecx                                                         ;
    jmp glBucle                                                     ;
;===================================================================

;todo este bloque para generarCurva=================================
gcBucle:                                                            ;
    cmp ecx,edi                                                     ; 
    jl gcOperacion                                                  ;
    ret                                                             ;
gcOperacion:                                                        ;
    mov ebx,[esi+ecx*4];primero un auxiliar del valor               ;
    mov eax,ebx                                                     ;
    ;primero la cubica                                              ;
    imul eax,eax                                                    ;
    imul eax,ebx                                                    ;
    ;en eax va el cubico                                            ;
    ;primero cuadrado                                               ;
    mov edx,ebx                                                     ;
    imul edx,edx                                                    ;
    imul edx,4 ;valor del segundo elemento en ecx                   ;
                                                                    ;
    ;finalmente ebx se convierte en el ultimo elemento              ;
    imul ebx,6                                                      ;
                                                                    ;
    sub eax,edx                                                     ;
    add eax,ebx                                                     ;
    sub eax,24 ;en eax esta el resultado final                      ;
                                                                    ;
    mov [ebp+ecx*4],eax;guardamos el resultado                      ;
                                                                    ;
    inc ecx                                                         ;
    jmp gcBucle                                                     ;
;===================================================================

;todo este bloque pertenece a guardar el archivo
sacarNumeros:
    cmp ecx,edi
    jl convertir
    ret
convertir:
    mov eax,[ebp+ecx*4]
    call itoa
    ;cmp ebx,0
    ;jg after
    
    mov eax,esi
    ;push esi
    ;mov esi,arregloStream
    ;call copystring
    mov [edx+ebx],eax
    ;pop esi
    push eax
    call strlen
    add ebx,eax
    pop eax
    call sprintLF

    inc ecx
    mov eax,ebx
    call iprintLF
    jmp sacarNumeros

;after:
;   mov eax,esi
;   push eax
;   call strlen
;   add ebx,eax
;   pop eax
;   call sprintLF
;   inc ecx
;   jmp sacarNumeros

;abrirArchivo:
 ;   mov eax,sys_open
  ;  mov ebx,archivo
   ; mov ecx,O_RDWR
    ;int 80h

    ;cmp eax,0
    ;jle salida

    ;mov ebx,eax
    ;ret