%macro outp 2
	mov     dx, %1
	mov     al, %2
	out     dx, al
%endmacro

incbin "tvga9000i.bin", 0, 0x7d68

	; WaitForKey();
	outp    0x279, 2
	outp    0xA79, 2

	; SendKey();
	outp    0x279, 0
	outp    0x279, 0
	outp    0x279, 0x6A
	outp    0x279, 0xB5
	outp    0x279, 0xDA
	outp    0x279, 0xED
	outp    0x279, 0xF6
	outp    0x279, 0xFB
	outp    0x279, 0x7D
	outp    0x279, 0xBE
	outp    0x279, 0xDF
	outp    0x279, 0x6F
	outp    0x279, 0x37
	outp    0x279, 0x1B
	outp    0x279, 0x0D
	outp    0x279, 0x86
	outp    0x279, 0xC3
	outp    0x279, 0x61
	outp    0x279, 0xB0
	outp    0x279, 0x58
	outp    0x279, 0x2C
	outp    0x279, 0x16
	outp    0x279, 0x8B
	outp    0x279, 0x45
	outp    0x279, 0xA2
	outp    0x279, 0xD1
	outp    0x279, 0xE8
	outp    0x279, 0x74
	outp    0x279, 0x3A
	outp    0x279, 0x9D
	outp    0x279, 0xCE
	outp    0x279, 0xE7
	outp    0x279, 0x73
	outp    0x279, 0x39

	; Wake(0);
	outp    0x279, 3
	outp    0xA79, 0

	; WriteCsn(1);
	outp    0x279, 6
	outp    0xA79, 1

	; Wake(1);
	outp    0x279, 3
	outp    0xA79, 1

	; WriteByte(7, 3);
	outp    0x279, 7
	outp    0xA79, 3

	; reg[0x30] = 0x01;
	outp    0x279, 0x30
	outp    0xA79, 0x01

	; reg[0x60] = 0x0170;
	outp    0x279, 0x61
	outp    0xA79, 0x70
	outp    0x279, 0x60
	outp    0xA79, 0x01

	; reg[0x62] = 0x0376;
	outp    0x279, 0x63
	outp    0xA79, 0x76
	outp    0x279, 0x62
	outp    0xA79, 0x03

	xor     ax, ax
	mov     es, ax
	mov     word [es:0x13*4+0], INT13
	mov     word [es:0x13*4+2], 0xc000
	mov     word [es:0x19*4+0], INT19
	mov     word [es:0x19*4+2], 0xc000
	jmp     0x4f
INT13:
	cmp     ah, 2
	je      INT13_read_disk
	cmp     ah, 3
	je      INT13_write_disk
	cmp     ah, 8
	je      INT13_disk_type
	iret
INT13_read_disk:
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si

	mov     di, bx
	mov     si, ax

	mov	bx, cx
	and	bx, 63

	shr     cl, 6
	xchg    cl, ch

	xchg    dl, dh
	and     dx, 0x0f

	mov     al, dl
	or      al, 0xa0
	mov     dx, 0x176
	out     dx, al

	mov     ax, si
	mov     dx, 0x172
	out     dx, al

	mov     al, bl
	mov     dx, 0x173
	out     dx, al

	mov     al, cl
	mov     dx, 0x174
	out     dx, al

	mov     al, ch
	mov     dx, 0x175
	out     dx, al

	mov     al, 0x20
	mov     dx, 0x177
	out     dx, al

	mov     bx, si
INT13_keep_reading:
	mov     cx, 256
	mov     dx, 0x177
INT13_wait_ready:
	in      al, dx
	test    al, 8
	jz      INT13_wait_ready
	mov     dx, 0x170
INT13_read_word:
	in      ax, dx
	stosw
	loop    INT13_read_word
	dec     bl
	jnz     INT13_keep_reading

	pop	si
	pop     di
	pop     dx
	pop     cx
	pop	bx
	pop	ax
	iret

INT13_write_disk:
	push	ds
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si

	mov     si, es
	mov     ds, si
	mov     si, bx
	mov     di, ax

	mov     bx, cx
	and     bx, 63

	shr     cl, 6
	xchg    cl, ch

	xchg    dl, dh
	and     dx, 0x0f

	mov     al, dl
	or      al, 0xa0
	mov     dx, 0x176
	out     dx, al

	mov     ax, di
	mov     dx, 0x172
	out     dx, al

	mov     al, bl
	mov     dx, 0x173
	out     dx, al

	mov     al, cl
	mov     dx, 0x174
	out     dx, al

	mov     al, ch
	mov     dx, 0x175
	out     dx, al

	mov     al, 0x30
	mov     dx, 0x177
	out     dx, al

	mov     bx, di
INT13_keep_writing:
	mov     dx, 0x177
	in      al, dx
	and	al, 0xe9
	cmp	al, 0x48
	jne     INT13_keep_writing
	mov     cx, 256
	mov     dx, 0x170
INT13_write_word:
	lodsw
	out     dx, ax
	loop    INT13_write_word
	dec     bl
	jnz     INT13_keep_writing
	mov	dx, 0x177
INT13_write_end:
	in	al, dx
	and	al, 0xe9
	cmp	al, 0x40
	jne	INT13_write_end	

	pop	si
	pop     di
	pop     dx
	pop     cx
	pop	bx
	pop	ax
	pop	ds
	iret

INT13_disk_type: ; 1024 cylinders, 16 heads, 63 sectors
	mov     cx, 0xffff
	mov     dx, 0x0f01
	iret

INT19:
	xor	ax, ax
	mov	es, ax
	mov	ds, ax
	mov	ax, 0x0201
	mov	bx, 0x7c00
	mov	cx, 1
	mov	dx, 0x0080
	int	0x13
	jmp	0:0x7c00

times 32768-($-$$) db 0