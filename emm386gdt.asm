; This file modifies the EMM386 set GDT to allow writing to memory
; within the dispatch handler. EMM386 runs in V86-mode and dispatch
; handling is effectively running code in protected mode.
;
; What happens here is that once this file is loaded, writing to
; port 330h will display on first character of textmode (0xb8000)
; what was written to the port.
;
; Install I/O Handler, EMM386.EXE v4.46+
;   AX = 4a15h, BX = 0, CX = number of ports to trap,
;   EDX = end/start I/O address, DS:SI = dispatch table
;   DI = size of code and data
;   only ports 100h-ffffh are allowed
;
; Dispatch function called with:
;   CX = ring0 code selector
;   DS = ring0 data selector
;   EDX = I/O address
;   ECX = direction (0 = input, 8 = output)
;   EAX = data in/out

        org     100h
start:
        mov     ax, 4a15h
        mov     bx, 0
        mov     dx, 330h
        shl     edx, 16
        mov     dx, 330h
        mov     cx, 1
        mov     si, io_dispatch
        mov     di, end
        int     2fh

        mov     ax, 0x3100
        mov     dx, (end-start)/16 + 17
        int     21h

align 16
handler330:
        cmp     [hooked], byte 1
        je      bypass

        pusha
        push    ds
        mov     ax, 8
        mov     ds, ax
        mov     si, [ds:8]
        inc     si
next_entry:
        sub     si, 8
        mov     al, [si+5]
        test    al, 0x80
        jz      free_entry
        jmp     next_entry
free_entry:
        mov     [ds:si+0], word 65535
        mov     [ds:si+2], word 0
        mov     [ds:si+4], byte 0
        mov     [ds:si+5], byte 146
        mov     [ds:si+6], byte 207
        mov     [ds:si+7], byte 0

        pop     ds
        mov     [datase], si
        popa
        mov     [hooked], byte 1
bypass:
        mov     bx, [datase]
        mov     es, bx
        mov     ds, bx
        mov     ah, 0x0f
        ;mov     al, '!'
        mov     ebx, 0xb8000
        mov     [ebx], ax
        retf
hooked:
        db      0
datase:
        dw      0

align 16
io_dispatch:
        dw      0x330
        dw      handler330

end:
