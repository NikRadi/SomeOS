[bits 32]


PM_GDT_Start:


; Mandatory null descriptor
; Required for memory integrity check
PM_GDT_NullDescriptor:
    dd 0x0
    dd 0x0


PM_GDT_Code:
    dw 0xffff       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    ; 1st flags
    ;   Present             1 (Used for virtual memory)
    ;   Privilege           00 (Ring 0 is the highest privilige)
    ;   Descriptor type     1 (1 is for code or data segment)
    ; Type flags
    ;   Code                1 (1 is for code segment)
    ;   Conforming          0 (Used for memory protection)
    ;   Readable            1 (1 if readable and 0 if execute-only)
    ;   Accessed            0 (Often used for debugging)
    db 0b10011010   ; 1st flags and type flags
    ; 2nd flags
    ;   Granularity         1 (Allows our segment to span 4GB of memory)
    ;   32-bit default      0
    ;   64-bit seg          1
    ;   AVL                 0 (We can set it for own uses, e.g. debugging)
    db 0b10101111   ; 2nd flags and Limit flags (bits 16-19)
    db 0x0          ; Base (bits 24-31)


PM_GDT_Data:
    dw 0x0          ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 0b10010010   ; 1st flags and type flags
    db 0b10100000   ; 2nd flags and Limit flags (bits 16-19)
    db 0x0          ; Base (bits 24-31)


; We need this label to calculate the size of the GDT
PM_GDT_End:


PM_GDT_Descriptor:
    dw PM_GDT_End - PM_GDT_Start - 1 ; Size of the GDT
    dd PM_GDT_Start                  ; Start address of the GDT


PM_GDT_CODE_SEGMENT equ PM_GDT_Code - PM_GDT_Start
PM_GDT_DATA_SEGMENT equ PM_GDT_Data - PM_GDT_Start
