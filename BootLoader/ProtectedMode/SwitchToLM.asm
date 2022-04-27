[bits 32]


PM_SwitchToLM:
    mov ecx, 0xC0000080 ; Switch to 64-bit mode
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0        ; Enable paging
    or eax, 1 << 31
    mov cr0, eax

    lgdt [PM_GDT_Descriptor]
    jmp PM_GDT_CODE_SEGMENT:PM_InitSwitch


[bits 64]

PM_InitSwitch:
    cli
    mov ax, PM_GDT_DATA_SEGMENT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp BeginLongMode
