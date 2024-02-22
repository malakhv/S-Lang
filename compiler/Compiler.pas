program slang;

uses Types, Os;

var
    Items: Array [1..5] of TTypeInfo;
    I: Integer;

begin
    WriteLn('Welcome to S-Lang compiler. ','Target OS is ', Os.getTargetOS);

    Items[1] := MakeTypeInfo('Byte');
    Items[2] := MakeTypeInfo('Integer');
    Items[3] := MakeTypeInfo('Char');
    Items[4] := MakeTypeInfo('String');
    Items[5] := MakeTypeInfo('Set');

    for I := Low(Items) to High(Items) do
    begin
        WriteLn('Name: ', Items[I].GetName());
        WriteLn('Simple: ', Items[I].IsSimple());
        WriteLn('Numeric: ', Items[I].IsNumeric());
        WriteLn();
    end;

end.
