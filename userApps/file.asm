[org 0x0000]
bits 16

start:
    push ds
    push es

    mov ax, cs
    mov ds, ax
    mov es, ax

    mov ah, 9
    int 0x30

    mov ah, 0
    mov si, msg_reading
    int 0x30

    mov ah, 16
    mov si, filename
    mov di, file_buffer
    int 0x30
    
    cmp ax, 0
    jne .error_read
    
    mov byte [file_buffer+511], 0
    mov ah, 0
    mov si, file_buffer
    int 0x30

    mov ah, 0
    mov si, msg_ask
    int 0x30

    mov cx, 512
    mov di, file_buffer
    mov al, 0
    rep stosb
    
    mov ah, 5
    mov di, file_buffer
    int 0x30
    
    mov ah, 17
    mov si, filename
    mov di, file_buffer
    int 0x30
    
    cmp ax, 0
    jne .error_write
    
    mov ah, 0
    mov si, msg_success
    int 0x30
    jmp .exit

.error_read:
    mov ah, 0
    mov si, msg_err_read
    int 0x30
    jmp .exit

.error_write:
    mov ah, 0
    mov si, msg_err_write
    int 0x30

.exit:
    pop es
    pop ds
    retf

filename: db "TEST    TXT"
msg_reading: db "Reading TEST.TXT...", 13, 10, 0
msg_ask: db 13, 10, "Enter new string for TEST.TXT:", 13, 10, 0
msg_success: db "Successfully updated TEST.TXT.", 13, 10, 0
msg_err_read: db "Error reading TEST.TXT (not found).", 13, 10, 0
msg_err_write: db "Error writing TEST.TXT.", 13, 10, 0

file_buffer:
