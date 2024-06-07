uses crt, dos;

var
  dirinfo: searchrec;
  a, b, c, d, row, files: word;
  extension: string;
  nopar: byte;
  prmstr: string;
  filesize: longint;
  total: longint;
  fs: string;
  tmp: string;

begin
  a := 0;
  row := 0;
  nopar := 1;
  files := 0;
  total := 0;

  if paramcount = 0 then
  begin
    findfirst('*.*', $3f, dirinfo);
  end
  else
  begin
    nopar := 0;
    prmstr := paramstr(1);
    if prmstr = '.' then prmstr := '*.*';
    if prmstr = '*' then prmstr := '*.*';
    findfirst(prmstr, $3f, dirinfo);
  end;

  while doserror = 0 do
  begin
    textcolor(lightgray);
    if dirinfo.attr <> 8 then
    begin
      d := 0;
      extension  := '';
      c := length(dirinfo.name);
      for b := 1 to c do
      begin
        if dirinfo.name[b] = '.' then d := 1;
        if d = 1 then extension := extension + dirinfo.name[b];
      end;
      if dirinfo.attr and $10 = $10 then
      begin
        textcolor(lightmagenta);
        if nopar = 1 then write('[');
      end;
      if extension = '.BAK' then textcolor(cyan);
      if extension = '.ZIP' then textcolor(magenta);
      if extension = '.TXT' then textcolor(yellow);
      if extension = '.EXE' then textcolor(lightcyan);
      if extension = '.COM' then textcolor(lightred);
      if extension = '.PAS' then textcolor(green);
      if extension = '.ASM' then textcolor(green);
      if extension = '.C' then textcolor(green);
      write(dirinfo.name);
      if dirinfo.attr and $10 = $10 then
      begin
        if nopar = 1 then write(']');
        c := c + 2;
      end;
      for b := c to 12 do write(' ');
      if dirinfo.attr and $10 <> $10 then
      begin
        total := total + dirinfo.size;
        files := files + 1;
      end;
      if nopar = 1 then
      begin
        a := a + 1;
        if a = 6 then
        begin
          writeln;
          row := row + 1;
          a := 0;
        end;
      end
      else
      begin
        if dirinfo.attr and $10 = $10 then
        begin
          writeln('       <DIR>');
        end
        else
        begin
          write('  ');
          textcolor(white);
          str(dirinfo.size, fs);
          if length(fs) = 1 then tmp := '       ' + fs;
          if length(fs) = 2 then tmp := '      ' + fs;
          if length(fs) = 3 then tmp := '     ' + fs;
          if length(fs) = 4 then tmp :=                               '   ' + fs[1] + ',' + fs[2] + fs[3] + fs[4];
          if length(fs) = 5 then tmp :=                        '  ' + fs[1] + fs[2] + ',' + fs[3] + fs[4] + fs[5];
          if length(fs) = 6 then tmp :=                 ' ' + fs[1] + fs[2] + fs[3] + ',' + fs[4] + fs[5] + fs[6];
          if length(fs) = 7 then tmp :=         fs[1] + ',' + fs[2] + fs[3] + fs[4] + ',' + fs[5] + fs[6] + fs[7];
          if length(fs) = 8 then tmp := fs[1] + fs[2] + ',' + fs[3] + fs[4] + fs[5] + ',' + fs[6] + fs[7] + fs[8];
          writeln(tmp);
        end;
        row := row + 1;
      end;
      if row = 24 then
      begin
        textcolor(yellow);
        write('<Press enter to continue>');
        readln;
        row := 0;
      end;
    end;
    findnext(dirinfo);
  end;

  if ((nopar = 1) and (a <> 0)) then writeln;

  textcolor(white);
  str(files, fs);
  if length(fs) = 1 then tmp := '    ' + fs;
  if length(fs) = 2 then tmp := '   ' + fs;
  if length(fs) = 3 then tmp := '  ' + fs;
  if length(fs) = 4 then tmp := fs[1] + ',' + fs[2] + fs[3] + fs[4];
  write(tmp);

  textcolor(cyan);
  write(' file(s) ');
  str(total, fs);
  if length(fs) = 1 then tmp := '         ' + fs;
  if length(fs) = 2 then tmp := '        ' + fs;
  if length(fs) = 3 then tmp := '       ' + fs;
  if length(fs) = 4 then tmp :=                             '     ' + fs[1] + ',' + fs[2] + fs[3] + fs[4];
  if length(fs) = 5 then tmp :=                      '    ' + fs[1] + fs[2] + ',' + fs[3] + fs[4] + fs[5];
  if length(fs) = 6 then tmp :=               '   ' + fs[1] + fs[2] + fs[3] + ',' + fs[4] + fs[5] + fs[6];
  if length(fs) = 7 then tmp :=   ' ' + fs[1] + ',' + fs[2] + fs[3] + fs[4] + ',' + fs[5] + fs[6] + fs[7];
  if length(fs) = 8 then tmp := fs[1] + fs[2] + ',' + fs[3] + fs[4] + fs[5] + ',' + fs[6] + fs[7] + fs[8];
  textcolor(white);
  write(tmp);
  textcolor(cyan);
  write(' bytes.');
  textcolor(lightgray);
  writeln(' ');
end.
