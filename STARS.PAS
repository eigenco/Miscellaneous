uses crt;

var
  xs : array[0..199] of integer;
  ys : array[0..199] of integer;
  zs : array[0..199] of integer;
  i, j, k : integer;
  cnt : integer;

begin
  asm
    mov ax, 13h
    int 10h
  end;
  port[$3c8] := 0;
  for k :=0 to 255 do
  begin
    port[$3c9] := 0;
    port[$3c9] := 0;
    port[$3c9] := 0;
  end;

  port[$3c8] := 0;
  for k := 0 to 63 do
  begin
    port[$3c9] := k;
    port[$3c9] := k;
    port[$3c9] := k;
  end;
  for k := 64 to 255 do
  begin
    port[$3c9] := 63;
    port[$3c9] := 63;
    port[$3c9] := 63;
  end;

  for k := 0 to 199 do
  begin
    xs[k] := random(320) - 160;
    ys[k] := random(200) - 100;
    zs[k] := 256;
  end;

  repeat
    while port[$3da] and 8 = 8 do;
    while port[$3da] and 8 <> 8 do;

    for k := 0 to 199 do
    begin
      i := xs[k] shl 8 div zs[k] + 160;
      j := ys[k] shl 8 div zs[k] + 100;
      mem[$a000:i + j shl 6 + j shl 8] := 0;
      xs[k] := xs[k] + 1;
      zs[k] := zs[k] - 1;

      i := xs[k] shl 8 div zs[k];
      j := ys[k] shl 8 div zs[k];
      if (abs(i) > 159) or (abs(j) > 99) then
      begin
        xs[k] := random(320) - 160;
        ys[k] := random(200) - 100;
        zs[k] := 256;
        i := xs[k] shl 8 div zs[k];
        j := ys[k] shl 8 div zs[k];
      end;

      i := i + 160;
      j := j + 100;
      mem[$a000:i + j shl 6 + j shl 8] := round(64 - zs[k] shr 2);
    end;

  until keypressed;

  textmode(3);
end.