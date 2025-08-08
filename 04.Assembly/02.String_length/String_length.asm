section .data
	msg db 'My name is Himanshu!',0x0a
section .text
global _start
_start:
	mov ebx , msg
	mov eax , ebx
	
loop:
	cmp byte[eax] , 0
	je finished
	inc eax
	jmp loop
finished:
	sub eax , ebx ;length of String
	
	mov dil , 1
	mov rsi , msg
	mov edx , eax
	xor rax , rax
	mov al , 1
	syscall
	
	mov al , 60
	xor rdi , rdi
	syscall
	
