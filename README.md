# Miscellaneous

Hacked VGABIOS for Trident TVGA 9000i allowing boot from Sound Blaster AWE64 IDE: int13.asm

Recently fixed buggy write routine in int13.asm that corrupted data when writing. Now everything seems to be working fine. Remember to set VGABIOS shadow option on in the BIOS. This significantly shortens load times.
