section .data
    capture db "Número entero>",0x0

    titulos db "Arreglo de entrada     Arreglo de resultados",0x0
    barra db   "==================     =====================",0x0
                                             
    ;basura de espacios
    sangria db "   ",0x0
    sangria2 db "                       ",0x0

section .bss
    numeroCapt resb 4
    numeroCaptLen equ $-numeroCapt
    numero_recivido resb 4

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
    call salida


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

;todo este bloque para generarCurva
gcBucle:
    cmp ecx,edi
    jl gcOperacion
    ret
gcOperacion:
    mov ebx,[esi+ecx*4];primero un auxiliar del valor
    mov eax,ebx
    ;primero la cubica
    imul eax,eax
    imul eax,ebx
    ;en eax va el cubico
    ;primero cuadrado
    mov edx,ebx 
    imul edx,edx
    imul edx,4 ;valor del segundo elemento en ecx

    ;finalmente ebx se convierte en el ultimo elemento
    imul ebx,6 

    sub eax,edx
    add eax,ebx
    sub eax,24 ;en eax esta el resultado final

    mov [ebp+ecx*4],eax;guardamos el resultado

    inc ecx
    jmp gcBucle