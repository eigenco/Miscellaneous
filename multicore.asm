; nasmw -fbin multicore.asm -o multicore.img
; "d:\Program Files\qemu\qemu-system-x86_64.exe" -smp 2 -fda multicore.img

	org	0x7c00

	; enable A20 bit
	mov	ax, 0x2401
	int	0x15

	mov	ax, 3
	int	0x10

	cli

	; copy code for the second core to execute at 9000:0000 
	mov	bx, cs
	mov	ds, bx
	mov	si, SecondCore
	mov	bx, 0x9000
	mov	es, bx
	xor	di, di
	mov	cx, 512
	rep	movsb

	; enable unreal mode for the first core
	mov	eax, cs
	shl	eax, 4
	add	eax, gdt
	mov	[gdtinfo+2], eax
	lgdt	[gdtinfo]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	mov	bx, 8
	mov	ds, bx
	mov	es, bx
	and	al, 0xFE
	mov	cr0, eax

	xor	ax, ax
	mov	ds, ax
	mov	es, ax

	; start the second core
	mov	edi, 0xFEE00300
	mov	[edi], dword 0x000C4500
	mov	[edi], dword (0x000C4600 + 0x90000/0x1000)

	mov	di, 0xB800
	mov	es, di
	mov	di, 4
LOOP0:
	inc	word [es:di]
	jmp	LOOP0

SecondCore:
	mov	di, 0xB800
	mov	es, di
	mov	di, 10
	inc	word [es:di]
	jmp	SecondCore

gdt:
	dd	0, 0
	dw	65535, 0
	db	0, 146, 207, 0
gdtinfo:
	dw	$ - gdt - 1
	dd	0

times 510 - ($-$$) db 0

dw 0xaa55