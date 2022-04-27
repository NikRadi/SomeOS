[bits 16]

; Args
;   bx      Value to print
RM_PrintHex:
    push ax             ; Save registers we are going to use
    push bx
    push cx

    mov ah, 0x0E        ; Enable BIOS printint mode

    mov al, '0'         ; Print '0x'
    int 0x10
    mov al, 'x'
    int 0x10

    mov cx, 4           ; Initialize counter
RM_PrintHex_LoopStart:
    cmp cx, 0           ; If counter is 0 then we are done
    je RM_PrintHex_LoopEnd
    push bx
    shr bx, 12          ; Shift so the 4 leftmost bits become the 4 rightmost
    cmp bx, 10          ; Check if the bits are less than 10
    jl RM_PrintHex_PrintNumber

    mov al, 'A'         ; Find which letter to print
    sub bl, 10
    add al, bl
    jmp RM_PrintHex_Print
RM_PrintHex_PrintNumber:
    mov al, '0'
    add al, bl
RM_PrintHex_Print:
    int 0x10            ; Print character

    pop bx
    shl bx, 4           ; Shift to the next 4 bits

    dec cx
    jmp RM_PrintHex_LoopStart
RM_PrintHex_LoopEnd:
    pop cx
    pop bx
    pop ax
    ret
