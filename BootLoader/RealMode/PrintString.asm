[bits 16]

; Args
;   bx      String to print
RM_PrintString:
    push ax             ; Save registers we are going to use
    push bx

    mov ah, 0x0e        ; Enable BIOS printint mode
RM_PrintString_LoopStart:
    mov al, [bx]        ; Set al to the value at bx
    cmp al, 0           ; Check for null terminator
    je RM_PrintString_LoopEnd
    int 0x10            ; Print character
    inc bx              ; Move to the next character
    jmp RM_PrintString_LoopStart
RM_PrintString_LoopEnd:
    pop bx
    pop ax
    ret
