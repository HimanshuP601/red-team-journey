strlen:
	mov rdx , rsi
loop:
	cmp byte[rdx] , 0
	je finished
	inc rdx
	jmp loop
finished:
	sub rdx , rsi
	ret

sprint:
	mov dil , 1
	call strlen
	mov al , 1
	syscall

quit:
	mov al , 60
	xor rdi , rdi
	syscall
	
