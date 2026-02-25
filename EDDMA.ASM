; This program enables legacy DMA1 on PCI distributed DMA (DDMA) with
; VT86C596B south bridge. Tested on FA11 motherboard.
;
; This is useful for SB compatibility on Yamaha YMF724 PCI sound card.
; 
; You need to find PCI configuration space device #
; corresponding to Vendor: 1106, Device: 0596 manually (try RBPCI119).
;
; Compilation: nasm eddma.asm -o eddma.com

org 100h

mov dx, 0xcf8
mov eax, 0x80000060 | (7 << 11) ; device 7, registers 0x60-0x63
out dx, eax
mov dx, 0xcfc
mov eax, 0x80080000 ; VT86C596B datasheet pg. 47
out dx, eax

int 0x20
