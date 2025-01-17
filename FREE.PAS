uses crt, dos;

function prints(s : longint) : byte;
var
  a, b : byte;
  num : array[0..9] of byte;
  n : longint;
begin
  n := s;
  a := 0;
  while s > 0 do
  begin
    num[a] := s mod 10;
    s := s div 10;
    a := a + 1;
  end;
  for b := 0 to 9 do
    if b > 9 - a then
    begin
      if (b = 1) and (n>1000000000) then write(',');
      if (b = 4) and (n>1000000) then write(',');
      if (b = 7) and (n>1000) then write(',');
      write(num[9-b]);
    end;
end;

begin
  {
  clrscr;
  writeln(2147483647);
  prints(2147483647);
  prints(147483647);
  prints(47483647);
  prints(7483647);
  prints(483647);
  prints(83647);
  prints(3647);
  prints(647);
  prints(47);
  prints(7);
  }

  textcolor(white);
  prints(diskfree(0));
  textcolor(cyan);
  write(' bytes free');
  textcolor(lightgray);
  writeln;
end.
