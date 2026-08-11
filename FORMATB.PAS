{
 84 tracks, 2 sides, 3 sectors 4096 bytes each -> 2,064,384 bytes total.
 If formatting keeps failing, try running nformat first and this format after
 (some controllers apparently have something that doesn't get initialized)
}
uses crt, dos;

var
  i, j, k : word;
  written : word;
  c, h, s : byte;

procedure fdc_write_byte(data : byte);
var
  timeout : longint;
begin
  timeout := 0;
  while (timeout < 1000000) and (port[$3f4] and $c0 <> $80) do timeout := timeout + 1;
  if timeout = 1000000 then
  begin
    writeln('Error (w) occurred!');
    port[$3f2] := 1;
    halt;
  end;
  port[$3f5] := data;
end;

function fdc_read_byte : byte;
var
  timeout : longint;
begin
  timeout := 0;
  while (timeout < 1000000) and (port[$3f4] and $c0 <> $c0) do timeout := timeout + 1;
  if timeout = 1000000 then
  begin
    writeln('Error (r) occurred!');
    port[$3f2] := 1;
    halt;
  end;
  fdc_read_byte := port[$3f5];
end;

begin
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
    writeln('formatting track ', c, ', side 0');
    fdc_write_byte($4d); { format track }
    fdc_write_byte(2);   { HD, US1, US0 }
    fdc_write_byte(5);   { sector sizecode -> 4096 }
    fdc_write_byte(3);   { sectors / track }
    fdc_write_byte(10);  { format gap length }
    fdc_write_byte($e5); { fill pattern }
    for i := 1 to 3 do
    begin
      fdc_write_byte(c); { track }
      fdc_write_byte(0); { head }
      fdc_write_byte(i); { sector }
      fdc_write_byte(5); { sizecode -> 4096 }
    end;
    for i := 0 to 6 do
      fdc_read_byte;
    delay(50);

    writeln('formatting track ', c, ', side 1');
    fdc_write_byte($4d); { format track }
    fdc_write_byte(6);   { HD, US1, US0 }
    fdc_write_byte(5);   { sector sizecode -> 4096 }
    fdc_write_byte(3);   { sectors / track }
    fdc_write_byte(10);  { format gap length }
    fdc_write_byte($e5); { fill pattern }
    for i := 1 to 3 do
    begin
      fdc_write_byte(c); { track }
      fdc_write_byte(1); { head }
      fdc_write_byte(i); { sector }
      fdc_write_byte(5); { sizecode -> 4096 }
    end;
    for i := 0 to 6 do
      fdc_read_byte;
    delay(50);

    { seek to next track }
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
  writeln('**** format complete ****');
end.
