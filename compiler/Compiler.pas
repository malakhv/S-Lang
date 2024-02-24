program slang;

{$MODE DELPHI}
{$H+}
{$T+}

uses Types, Os, Collections, List;

//type
    //TTypeInfoNode = specialize TTreeNode<TTypeInfo>;
    //TTypeInfoListItem = specialize TListItem<TTypeInfo>;

var
    Items: Array [1..6] of TTypeInfo;
    I: Integer;

    MyList: TLinkedList;
    Item: PListItem;
    Info: PTypeInfo;
    //Node: TTreeNode<TTypeInfo>;
    //Item: TTypeInfoListItem;

procedure DumpList();
var Item: PListItem;
    Info: TTypeInfo;
begin
    WriteLn();
    Item := MyList.First;
    while Item <> nil do
    begin
        Info := PTypeInfo(Item^.Value)^;
        Item := Item^.Next;
        WriteLn('Name: ', Info.GetName());
    end;
    WriteLn('(', MyList.Count, ' elements in total)');
end;

procedure FillList();
var Kind: TTypeKind;
    Info: PTypeInfo;
begin
    for Kind := Low(TTypeKind) to High(TTypeKind) do
    begin
        New(Info);
        Info^.Kind := Kind;
        MyList.Add(Info);
    end;
end;

begin
    WriteLn('Welcome to S-Lang compiler. ','Target OS is ', Os.getTargetOS);
    MyList := TLinkedList.Create();

    MyList.Add(MakeTypeInfo('Set'));
    MyList.Add(MakeTypeInfo('Method'));
    DumpList();
    MyList.Remove(0);
    MyList.Remove(0);
    DumpList();
    MyList.Add(MakeTypeInfo('Enum'));
    MyList.Add(MakeTypeInfo('Array'));
    DumpList();

    MyList.Clear();
    DumpList();

    MyList.Add(MakeTypeInfo('Class'));
    MyList.Add(MakeTypeInfo('Set'));
    DumpList();

    MyList.Clear();
    FillList();
    DumpList();
    WriteLn();

    // Added
    MyList.Add(MakeTypeInfo('Set'));
    MyList.Insert(MakeTypeInfo('Pointer'), MyList.Count - 1);
    MyList.Insert(MakeTypeInfo('Array'), 0);
    DumpList();
    MyList.Add(MakeTypeInfo('Set'));
    DumpList();

    //MyList.Clear();
    //DumpList();

    //MyList.Add(MakeTypeInfo('Set'));
    //DumpList();
    //Dump(MyList);

    for I := 0 to 1000 do
    begin
        FillList();
        //WriteLn ('Fill - ', I);
    end;

    WriteLn();
    WriteLn('Done!');

    {WriteLn();
    Item := MyList.First;
    while Item <> nil do
    begin
        Info := PTypeInfo(Item^.Value)^;
        Item := Item^.Next;
        WriteLn('Name: ', Info.GetName());
    end;}
    ReadLn();
    MyList.Clear();
    WriteLn('Clear!');
    ReadLn();

end.
