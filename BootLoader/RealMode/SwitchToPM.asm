[bits 16]


RM_SwitchToPM:
    cli                 ; Disable CPU interrups
    lgdt [RM_GDT_Descriptor]

    mov eax, cr0    ; Set the first bit of cr0 to indicate
    or eax, 0x1     ; that we are moving to protected mode
    mov cr0, eax

    ; Make a far jump to our 32-bit code
    jmp RM_GDT_CODE_SEGMENT:RM_InitSwitch


[bits 32]

RM_InitSwitch:
    mov ax, RM_GDT_DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; The stack pointer gets messed up so we set it again
    mov ebp, 0x90000
    mov esp, ebp

    call BeginProtectedMode
