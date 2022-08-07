# Miscellaneous

int13.asm: Hacked VGABIOS for Trident TVGA 9000i allowing boot from Sound Blaster AWE64 IDE.

Recently fixed buggy write routine in int13.asm that corrupted data when writing. Now everything seems to be working fine. Remember to set VGABIOS shadow option on in the BIOS. This significantly shortens load times. Currently only standard maximum CHS 1024/16/63 geometry is supported. This gives DOS the impression that the drive is 528MB in size (larger disks will work, but size is limited).
