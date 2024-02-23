program slang;

{$MODE DELPHI}
{$H+}
{$T+}

uses Types, Os, Collections, List;

//type
    //TTypeInfoNode = specialize TTreeNode<TTypeInfo>;
    //TTypeInfoListItem = specialize TListItem<TTypeInfo>;

var
    Items: Array [1..5] of TTypeInfo;
    I: Integer;
    MyList: TLinkedList;
    Item: PListItem;
    Info: TTypeInfo;
    //Node: TTreeNode<TTypeInfo>;
    //Item: TTypeInfoListItem;

begin
    WriteLn('Welcome to S-Lang compiler. ','Target OS is ', Os.getTargetOS);
    WriteLn();

    Items[1] := MakeTypeInfo('Byte');
    Items[2] := MakeTypeInfo('Integer');
    Items[3] := MakeTypeInfo('Char');
    Items[4] := MakeTypeInfo('String');
    Items[5] := MakeTypeInfo('Set');

    MyList := TLinkedList.Create();
    for I := Low(Items) to High(Items) do
    begin
        Item := MyList.Add(@Items[I]);
        Info := PTypeInfo(Item^.Value)^;
        WriteLn('Name: ', Info.GetName());
        WriteLn('Simple: ', Info.IsSimple());
        WriteLn('Numeric: ', Info.IsNumeric());
        WriteLn();
    end;
    //MyList.Remove(@Items[2]);
    MyList.Remove(0);

    Item := MyList.First;
    while Item <> nil do
    begin
        Info := PTypeInfo(Item^.Value)^;
        Item := Item^.Next;
        WriteLn('Name: ', Info.GetName());
    end;

    WriteLn('MyList has ', MyList.Count, ' elements.');

end.
