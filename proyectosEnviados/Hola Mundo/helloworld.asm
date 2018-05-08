;
section .data
	mensaje DB 'Antonio',0xA,0xD
	longitud EQU $ - mensaje
	mensaje2 DB 'Gonzalez',0xA,0xD
	longitud2 EQU $ - mensaje2
	mensaje3 DB 'Munguia' ,0xA,0xD
	longitud3 EQU $ - mensaje3
section .text
	GLOBAL _start

_start:
	mov RCX, mensaje
	mov RDX, longitud
	mov RBX, 1
	mov RAX, 4
	int 0x80
	mov RAX, 1
	
	mov RCX, mensaje2
	mov RDX, longitud2
	mov RBX, 1
	mov RAX, 4
	int 0x80
	mov RAX, 1

	mov RCX, mensaje3
	mov RDX, longitud3
	mov RBX, 1
	mov RAX, 4
	int 0x80
	mov RAX, 1
	int 0x80
	