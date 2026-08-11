uses crt, dos;

var
  f : file;
  data : array [0..4096] of byte;
  i, j, k : word;
  c, h, s : byte;
  l : longint;

procedure fdc_write_byte(data : byte);
begin
  while port[$3f4] and $c0 <> $80 do;
  port[$3f5] := data;
end;

function fdc_read_byte : byte;
begin
  while (port[$3f4] and $c0) <> $c0 do;
  fdc_read_byte := port[$3f5];
end;

begin
  l := 0;
  assign(f, 'disk.img');
  reset(f, 1);

  clrscr;
  asm
    cli
  end;

  { reset FDC }
  port[$3f2] := 1;
  delay(1000);

  { select b: }
  port[$3f2] := $2d;
  fdc_write_byte(3);
  fdc_write_byte(255);
  fdc_write_byte(255);
  delay(1000);

  { recalibrate }
  for i := 0 to 2 do
  begin
    fdc_write_byte(7);
    fdc_write_byte(2);
    delay(1000);
  end;

  for c := 0 to 83 do
  begin
    for h := 0 to 1 do
    begin
      for s := 1 to 3 do
      begin
        blockread(f, data, 4096);
        write('writing track ', c, ', side ', h, ', sector ', s, '...');
        fdc_write_byte($45); { write }
        fdc_write_byte(h shl 2 or 2); { HD, US1, US0 }
        fdc_write_byte(c);   { cylinder }
        fdc_write_byte(h);   { head }
        fdc_write_byte(s);   { sector }
        fdc_write_byte(5);   { sizecode }
        fdc_write_byte(3);   { last sector }
        fdc_write_byte(5);   { gap length }
        fdc_write_byte(255); { data length }
        for i := 0 to 4095 do
          fdc_write_byte(data[i]);
        for i := 0 to 6 do
          fdc_read_byte;
        delay(50);
        l := l + 4096;
        writeln(' ', l, ' bytes in total written');
      end;
    end;

    { seek track }
    if c < 83 then
    begin
      writeln('seeking track ', c+1);
      fdc_write_byte(15);
      fdc_write_byte(2);
      fdc_write_byte(c+1);
      delay(200);
    end;
  end;

  port[$3f2] := 14;
  asm sti end;
  close(f);
  writeln('**** write complete ****');
end.