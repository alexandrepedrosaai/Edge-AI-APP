program HelloDelphi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Matrix: array[1..3, 1..3] of Integer;
  i, j: Integer;

begin
  Writeln('Delphi Matrix Artifact - Extended');

  { Preenche a matriz }
  Matrix[1,1] := 1; Matrix[1,2] := 2; Matrix[1,3] := 3;
  Matrix[2,1] := 4; Matrix[2,2] := 5; Matrix[2,3] := 6;
  Matrix[3,1] := 7; Matrix[3,2] := 8; Matrix[3,3] := 9;

  { Exibe os valores }
  for i := 1 to 3 do
    for j := 1 to 3 do
      Writeln('Matrix[', i, ',', j, '] = ', Matrix[i,j]);

  Readln;
end.
