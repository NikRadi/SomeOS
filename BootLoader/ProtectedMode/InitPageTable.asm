[bits 32]


; PML4T     0x1000      Page map level 4 table
; PDPT      0x2000      Page directory pointer table
; PDT       0x3000      Page directory table
; PT        0x4000      Page table


PM_InitPageTable:
    pushad

    ; First, we clear the memory area using 'stosd' command
    ; The stosd instruction ("repeating string command")
    ; writes the same thing until a criteria is met.
    ; The criteria lies in eax, edi, and ecx
    mov edi, 0x1000     ; Page table starting address
    mov cr3, edi        ; cr3 is used to locate page table entires
    xor eax, eax        ; Set eax to 0. This is faster than 'mov eax, 0'
    mov ecx, 4096       ; Repeat 4096 times
    rep stosd           ; Zero out page table entries

    mov edi, cr3
    ; Second, we set up the first entry of each table
    ; The page tables must be aligned, meaning the lower 12
    ; bits of the physical address must be 0.
    mov dword[edi], 0x2003  ; Set PML4T[0] to address 0x2000 with flags 0x0003
    add edi, 0x1000         ; Go to PDPT[0]
    mov dword[edi], 0x3003  ; Set PDPT[0] to address 0x3000 with flags 0x0003
    add edi, 0x1000         ; Go to PDT[0]
    mov dword[edi], 0x4003  ; Set PDT[0] to address 0x4000 with flags 0x0003

    ; Third, we fill the final page table
    ; We use the 'loop' command
    add edi, 0x1000         ; Go to PT[0]
    mov ebx, 0x3
    mov ecx, 512            ; Do the operation 512 times
PM_InitPageTable_LoopStart:
    mov dword[edi], ebx
    add ebx, 0x1000
    add edi, 8              ; Increment page table location (1 entry is 8 bytes)
    loop PM_InitPageTable_LoopStart

    ; Tell the CPU that we want to use paging later.
    ; We enable the feature but don't use it yet
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    popad
    ret
