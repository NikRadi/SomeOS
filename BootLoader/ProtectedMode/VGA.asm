[bits 32]


PM_VGAClear:
    pusha
    mov ebx, VGA_SIZE
    mov ecx, VGA_START
    mov edx, 0
PM_VGAClear_LoopStart:
    cmp edx, ebx         ; While edx < ebx
    jge PM_VGAClear_LoopEnd

    push edx
    mov al, ` `
    mov ah, VGA_STYLE

    add edx, ecx        ; Print character to VGA memory
    mov word[edx], ax

    pop edx
    add edx, 2
    jmp PM_VGAClear_LoopStart
PM_VGAClear_LoopEnd:
    popa
    ret


; Args
;   esi      String to print
PM_VGAPrint:
    pusha
    mov edx, VGA_START
PM_VGAPrint_LoopStart:
    cmp byte[esi], 0    ; Check for null terminator
    je PM_VGAPrint_LoopEnd
    mov al, byte[esi]
    mov ah, VGA_STYLE
    mov word[edx], ax   ; Print character

    add esi, 1
    add edx, 2
    jmp PM_VGAPrint_LoopStart
PM_VGAPrint_LoopEnd:
    popa
    ret
