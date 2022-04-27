[bits 16]

; Args
;   bx      Sector start point
;   cx      Number of sectors to read
;   dx      Destination address
RM_LoadDisk:
    push ax                 ; Save registers we are going to use
    push bx
    push cx
    push dx

    push cx                 ; We will need this again later so save it twice
    mov ah, 0x02            ; Let BIOS know that we want to load from disk

    mov al, cl              ; BIOS expects the information in specific
    mov cl, bl              ; registers, so we move data around
    mov bx, dx

    mov ch, 0x0             ; Cylinder and cylinder head to read from
    mov dh, 0x0             ; These values only work when using QEMU

    mov dl, byte[BOOT_DRIVE]

    int 0x13                ; Read from disk
    jc RM_LoadDisk_Error1   ; If there is an error then print some message

    pop bx                  ; Check if BIOS loaded the correct number of sectors
    cmp al, bl
    jne RM_LoadDisk_Error2

    mov bx, SUCCESS_MSG
    call RM_PrintString

    pop dx
    pop cx
    pop bx
    pop ax
    ret


RM_LoadDisk_Error1:
    mov bx, ERROR_MSG1
    call RM_PrintString

    shr ax, 8           ; The return code is in ah, so we mask al
    mov bx, ax
    call RM_PrintHex
    jmp $


RM_LoadDisk_Error2:
    mov bx, ERROR_MSG2
    call RM_PrintString

    shr ax, 8           ; The return code is in ah, so we mask al
    mov bx, ax
    call RM_PrintHex
    jmp $


ERROR_MSG1  db `ERROR1: Could not load sectors. Error code: `, 0
ERROR_MSG2  db `ERROR2: Could not load sectors. Error code: `, 0
SUCCESS_MSG db `Loaded sectors\r\n`, 0
