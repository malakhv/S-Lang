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
    WriteLn();

    // Test 01
    WriteLn('===== Test 01 ====='); WriteLn();
    Dump(MyList); WriteLn();
    MyList.Add(MakeTypeInfo('Set'));
    Dump(MyList); WriteLn();
    MyList.Remove(0);
    Dump(MyList); WriteLn();

    // Test 02
    WriteLn('===== Test 02 ====='); WriteLn();
    MyList.Add(MakeTypeInfo('Enum'));
    MyList.Add(MakeTypeInfo('Array'));
    Dump(MyList); WriteLn();

    // Test 03
    WriteLn('===== Test 03 ====='); WriteLn();
    MyList.Clear();
    FillList();
    Dump(MyList); WriteLn();

    // Test 04
    WriteLn('===== Test 04 ====='); WriteLn();
    MyList.Remove(0);
    MyList.Remove(0);
    MyList.Remove(3);
    MyList.Remove(5);
    MyList.Remove(7);
    MyList.Remove(9);
    MyList.Remove(3);
    MyList.Remove(MyList.Count - 1);
    Dump(MyList); WriteLn();

    // Test 05
    WriteLn('===== Test 05 ====='); WriteLn();
    MyList.Clear();
    for I := 1 to 128699999 do
    begin
        MyList.Add(Pointer(I));
    end;
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();
    WriteLn('Fill - done!');
    ReadLn();
    MyList.Clear();
    WriteLn('Clear - done!');
    WriteLn();
    Dump(MyList); WriteLn();
    ReadLn();
end.
