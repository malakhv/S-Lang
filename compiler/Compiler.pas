program slang;

{$MODE DELPHI}
{$H+}
{$T+}

uses Types, Os, SLang.Collections, SLang.List, SLang.Tree;

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
    Info: Integer;
begin
    WriteLn();
    Item := MyList.First;
    while Item <> nil do
    begin
        Info := Integer(Item^.Element);
        Item := Item^.Next;
        WriteLn('Val: ', Info);
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
    //Dump(MyList); WriteLn();
    MyList.Add(MakeTypeInfo('Set'));
    //Dump(MyList); WriteLn();
    MyList.Remove(0);
    //Dump(MyList); WriteLn();
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();

    // Test 02
    WriteLn('===== Test 02 ====='); WriteLn();
    MyList.Add(MakeTypeInfo('Enum'));
    MyList.Add(MakeTypeInfo('Array'));
    //Dump(MyList); WriteLn();
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();

    // Test 03
    WriteLn('===== Test 03 ====='); WriteLn();
    MyList.Clear();
    FillList();
    //Dump(MyList); WriteLn();
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();

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
    //Dump(MyList); WriteLn();
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();


    // Test 05
    WriteLn('===== Test 05 ====='); WriteLn();
    MyList.Clear();
    MyList.Add(Pointer(1));
    MyList.Add(Pointer(2));
    MyList.Add(Pointer(3));
    MyList.AddFirst(Pointer(0));
    MyList.AddFirst(Pointer(-3));
    MyList.Update(0, Pointer(-5));
    MyList.MoveToLast(0);
    //Dump(MyList); WriteLn();
    WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();

    WriteLn('Index Of 2 is ', MyList.IndexOf(Pointer(2)));
    WriteLn('Index Of First is ', MyList.IndexOf(MyList.First^.Element));
    WriteLn('Index Of Last is ', MyList.IndexOf(MyList.Last^.Element));
    WriteLn();



    //Exit;


    // Test 05
    WriteLn('===== Test 06 ====='); WriteLn();
    MyList.Clear();
    //for I := 1 to 128699999 do
    for I := 1 to 100 do
    begin
        MyList.Add(Pointer(I));
    end;
    //WriteLn('(', MyList.Count, ' elements in total)');
    WriteLn();
    DumpList();
    MyList.Reverse();
    DumpList();
    //Dump(MyList);
    //WriteLn('Fill - done!');
    //ReadLn();
    //MyList.Clear();
    //WriteLn('Clear - done!');
    //WriteLn();
    //Dump(MyList); WriteLn();
    //ReadLn();
end.
