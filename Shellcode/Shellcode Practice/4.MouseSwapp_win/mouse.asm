section .text
	global _start
_start:

		;align stack to 16 bytes
		xor rax , rax
		mov rbx , rsp
		and rsp , 0xFFFFFFFFFFFFFFF0
		sub rsp, 0x30               ; Shadow space


		;get basse address of kernel32.dll
		xor ecx , ecx
		mov rsi , gs:[rcx + 0x60] ; PEB
		mov rsi , [rsi + 0x18] ;RBX = PEB -> ldr
		mov rsi , [rsi + 0x20] ; RSI = InMemOrder
		mov rsi , [rsi] ;traverse through modules
		mov rsi , [rsi]
		mov rbx , [rsi + 0x30] ; BAse Address of kernel32.dll (DllBase)
		
		;RBX = Base Address of kernel32.dll
		
		;find the export table
		mov edx , [rbx + 0x3c]  ;RDX = DOS -> e_elfanew RVA (DWORD)
		add rdx , rbx ; VA of e_elfanew
		mov edx , [rdx + 0x78] ; Export Directory RVA
		add rdx , rbx ; VA of Export Directory
		mov esi , [rdx + 0x20] ; RVA of AddressofNames
		add rsi , rbx ; VA of AddressofNames
		
		;RDX = Base Address of Export Directory
		;Finding GetProcAddress function Name (just a index)
		xor rcx , rcx
		
		Get_fun:
		
		mov eax , [rsi + rcx * 4] ;RVA of next function
		mov rax , rax
		add rax , rbx ; VA of next function

		mov eax, dword [rax]              ; "GetP"
		cmp eax, 0x50746547
		jnz Next_fun

		mov eax, dword [rax + 4]          ; "rocA"
		cmp eax, 0x41636f72
		jnz Next_fun

		mov eax, dword [rax + 8]          ; "redd"
		cmp eax, 0x64647265
		jnz Next_fun

		mov ax, word [rax + 12]           ; "ss"
		cmp ax, 0x7373
		jnz Next_fun
		
		jmp Found_fun
		
		Next_fun:
		inc rcx
		jmp Get_fun
		
		Found_fun:
		
		;RCX = index of AddressofNames[]
		
		

		;optimized :
		mov esi , [rdx + 0x24]
		add rsi , rbx
		movzx ecx , word [rsi + rcx*2]
		mov esi , [rdx + 0x1c]
		add rsi , rbx
		mov eax , [rsi + rcx *4]
		add rax , rbx
		mov r8 , rax
		
		
		
		;r8 = getprocAddress

		

		;build "LOadLibraryA" strig on stack
		
		mov rax , 0x7262694C64616F4C   ; "LoadLibr"
		mov [rsp] , rax
		mov eax , 0x41797261         ; "aryA"
		mov [rsp + 8] , eax
		xor eax , eax
		lea rdi , [rsp + 12]
		stosb
		mov rcx , rbx ; hModule = kernel32.dll
		lea rdx , [rsp] ; lpProcName = "LoadLibraryA"
		call r8 ; GetProcAddress(kernel32.dll, "LoadLibraryA")
		mov r9 , rax ; r9 = LoadLibraryA
		

		
		
		
		; --- build "user32.dll" string ---
		mov rax , 0x642E323372657375  ; "user32.d" (little-endian)
		mov [rsp] , rax
		mov ax, 0x6C6C    ; "ll" 
		mov [rsp+8] , ax
		xor eax , eax
		lea rdi , [rsp + 10]
		stosb
		mov rcx , rsp
		call r9  ; LoadLibraryA("user32.dll")
		mov rsi , rax  ; user32.dll base
		

		
		
		; build "SwapMouseButton" string
		mov rax , 0x73756F4D70617753 ; 'SwapMous'
		mov [rsp] , rax
		mov rax, 0x6E6F7474754265 ; "eButton"
		mov [rsp + 8] , rax
		mov byte [rsp + 16] , 0x6E ; 'n' completes "Button"
		xor al , al
		lea rdi , [rsp + 17]
		stosb
		mov rcx , rsi ;user32.dll base
		lea rdx , [rsp] ; "SwapMouseButton"
		call r8 ; GetProcAddress(user32.dll, "SwapMouseButton")
		
		; --- call SwapMouseButton(1) ---
		
		mov rcx, 1        ; argument = 1 (swap)
		call rax          ; call SwapMouseButton(1)
		
		; --- build "ExitProcess" string ---
		mov rax, 0x636f725074697845  ; "ExitProc" (little-endian)
		mov [rsp] , rax
		mov eax, 0x73736573      ; "sess"
		mov [rsp + 8] , eax
		xor eax , eax
		lea rdi , [rsp + 12]
		stosb
		mov rcx , rbx
		lea rdx , [rsp]
		call r8 ; GetProcAddress(kernel32.dll, "ExitProcess")
		
		
		
		; --- call ExitProcess(0) ---
		xor rcx, rcx
		call rax
		
		
		
		
		
		

