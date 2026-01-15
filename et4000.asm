; this code configures ET4000 for 256KB address wrap around so
; games link keen 4 don't need to run with "svga compatibility"
;
; tasm et4000.asm
; tlink /t et4000

.model tiny
.code
org 100h

start:
  mov dx, 03bfh
  mov al, 3
  out dx, al
  mov dl, 0d8h
  mov al, 0a0h
  out dx, al

  mov dl, 0d4h
  mov al, 037h
  out dx, al
  inc dl
  in al, dx
  mov bl, al

  dec dl
  mov al, 037h
  inc dl
  mov al, bl
  and al, 247
  out dx, al

  int 20h
end start
