section .data
	a db "4"
	b db "3"
	msg db "la suma es",0x80
	len equ $ - msg
	vac db " ",0xA,0x80
	lv equ $ -vac

segment .bss
	sum resb 1

section .text
	global _start

_start:
	mov eax,[a]
	sub eax,'0'

	mov ebx,[b]
	sub ebx,'0'

	add eax,ebx
	add eax,'0'

	mov [sum],eax

	mov ecx,msg
	mov edx,len
	mov ebx,1
	mov eax,4
	int 0x80

	mov ecx,sum
	mov edx,1
	mov ebx,1
	mov eax,4
	int 0x80

	mov ecx,vac
	mov edx,lv
	mov ebx,1
	mov eax,4
	int 0x80

	mov eax,1
	int 0x80