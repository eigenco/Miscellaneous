uses crt;
var
  i, j : word;

begin
  clrscr;

  { reset }
  port[$376] := 4;
  delay(5);
  port[$376] := 0;
  delay(5);

  port[$176] := $a0 or 15; { head }
  port[$172] := 2 ;        { sectors to read/write }
  port[$173] := 62;        { sector }
  port[$174] := lo(1024);  { lo(cylinder) }
  port[$175] := hi(1024);  { hi(cylinder) }
  port[$177] := $30;       { $20 = read, $30 = write }

  while (port[$177] and $E9) <> $48 do;
  for i:=0 to 255 do
    portw[$170] := i;

  while (port[$177] and $E9) <> $48 do;
  for i:=0 to 255 do
    portw[$170] := 65535-i;

  while (port[$177] and $E9) <> $40 do;

  { read }
  port[$176] := $a0 or 15; { head }
  port[$172] := 2 ;        { sectors to read/write }
  port[$173] := 62;        { sector }
  port[$174] := lo(1024);  { lo(cylinder) }
  port[$175] := hi(1024);  { hi(cylinder) }
  port[$177] := $20;       { $20 = read, $30 = write }

  while (port[$177] and $E9) <> $48 do;
  for i:=0 to 255 do
  begin
    j := portw[$170];
    if i<20 then
    begin
      write(j);
      write(' ');
    end;
  end;
  writeln;
  writeln;

  while (port[$177] and $E9) <> $48 do;
  for i:=0 to 255 do
  begin
    j := portw[$170];
    if i<20 then
    begin
      write(j);
      write(' ');
    end;
  end;

  readln;
end.