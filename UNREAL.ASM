   org   0x100

start:
   cli

   ; fix absolute addresses
   mov   ebx, cs
   add   [jump_real+3], bx
   shl   ebx, 4
   add   [jump_prot+2], ebx
   add   [gdtinfo+2], ebx

   ; switch to protected mode
   lgdt  [gdtinfo]
   mov   eax, cr0
   or    al, 1
   mov   cr0, eax

jump_prot:   
   jmp   dword 8:pmode ; descriptor 1 (code)

pmode:
   mov   bx, 0x10 ; descriptor 2 (data)
   mov   ds, bx
   mov   es, bx

   and   al,0xFE
   mov   cr0, eax

jump_real:   
   jmp   0:real

real:
   mov   ax, 0x4f02
   mov   bx, 0x4100
   int   0x10

   xor   di, di
   mov   es, di
   mov   edi, 0xe0000000 ; LFB address

   xor   ax, ax
   mov   ecx, 640*400
.real:
   inc   ax
   db    0x67
   stosb
   db    0x67
   loop  .real

   xor   ax, ax
   int   0x16

   mov   ax, 3
   int   0x10

   ret

gdtinfo:
   dw gdt_end - gdt - 1
   dd gdt
gdt: ; L0    L1    B0    B1    B2    PR E      GD   L2     B3
   dq 0
   db 0xff, 0xff, 0x00, 0x00, 0x00, 10011010b, 10001111b, 0x00
   db 0xff, 0xff, 0x00, 0x00, 0x00, 10010010b, 10001111b, 0x00
gdt_end:

