[bits 32]


PM_InitLongMode:
    pushad

    ; To detect long mode we must use the 'cpuid' command.
    ; First, we have to check if the CPU supports the command
    pushfd              ; Copy flags
    pop eax
    mov ecx, eax        ; Save to ecx for later

    xor eax, 1 << 21    ; Bit 21 tells us of CPUID is supported

    push eax            ; Write to flags
    popfd

    pushfd              ; Bit is flipped i CPUID is supported
    pop eax

    push ecx
    popfd

    cmp eax, ecx        ; Compare
    je PM_InitLongMode_CPUIDNotFound

    ; Now we know that the CPU supports the cpuid command.
    ; We call it and check for some extended functions
    ; which are needed to enable long mode.
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001 ; See if the result is larger than 0x80000001
    jb PM_InitLongMode_CPUIDNotFound

    ; Check for long mode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz PM_InitLongMode_LMNotFound

    popad
    ret


PM_InitLongMode_CPUIDNotFound:
    call PM_VGAClear
    mov esi, CPUID_NOT_FOUND_MSG
    call PM_VGAPrint
    jmp $


PM_InitLongMode_LMNotFound:
    call PM_VGAClear
    mov esi, LM_NOT_FOUND
    call PM_VGAPrint
    jmp $


LM_NOT_FOUND        db `ERROR: Long mode not supported`, 0
CPUID_NOT_FOUND_MSG db `ERROR: CPUID not supported`, 0
