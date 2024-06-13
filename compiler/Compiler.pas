program slang;

{$MODE DELPHI}
{$H+}
{$T+}

uses Types, Os, SLang.Collections, SLang.List, SLang.Tree, SLang.Strings;


procedure DumpNode(Node: TTreeNodeC);
var I, D: Integer;
begin
    WriteLn();
    if Node = nil then WriteLn('NIL');
    //WriteLn(Node);
    D := Node.Deep;
    Write('':D*4); WriteLn('Node: ', Integer(Node));
    Write('':D*4); WriteLn('Parent: ', Integer(Node.Parent));
    Write('':D*4); WriteLn('Deep: ', D);
    Write('':D*4); WriteLn('Height: ', Node.Height);
    Write('':D*4); WriteLn('Count: ', Integer(Node.ChildCount));
    Write('':D*4); WriteLn('Element: ', Integer(Node.Element));

    for I := 0 to Node.ChildCount - 1 do
        DumpNode(Node[i]);
    //WriteLn('Element: ', Integer(Node.Element));
end;

procedure Inc(var Val: Integer);
asm
    INC Val
end;


var
    I: Integer;
    MyNode, TmpNode: TTreeNodeC;
    Rec: TTreeNode;
    List: TLinkedList;

begin
    WriteLn('Welcome to S-Lang compiler. ','Target OS is ', Os.getTargetOS);
    WriteLn();
    WriteLn(SizeOf(Rec));

    //Rec.X := 0;

    MyNode := TTreeNodeC.Create(Pointer(0));
    MyNode.Add(Pointer(1));
    MyNode.Add(Pointer(3));
    MyNode.Add(Pointer(2));
    MyNode.Add(Pointer(4));
    WriteLn();

    MyNode[2].Add(Pointer(11));
    MyNode[2].Add(Pointer(13));
    MyNode[2].Add(Pointer(12));
    MyNode[2][1].Add(Pointer(111));
    MyNode[2][1].Add(Pointer(113));
    MyNode[2][1].Add(Pointer(112));

    DumpNode(MyNode);
    WriteLn();

    MyNode[2].Clear;
    DumpNode(MyNode);
    WriteLn();

    MyNode.Clear();
    DumpNode(MyNode);
    WriteLn();

    MyNode.Add(Pointer(1));
    MyNode.Add(Pointer(2));
    MyNode.Left.Add(Pointer(11));
    MyNode.Left.Right.Add(Pointer(111));
    DumpNode(MyNode);
    WriteLn();

    MyNode.Clear();
    TmpNode := MyNode.Add(Pointer(1)).Add(Pointer(2)).Add(Pointer(3));
    TmpNode.Add(Pointer(5)).Add(Pointer(7));
    TmpNode.Add(Pointer(6));
    MyNode.Add(Pointer(8)).Add(Pointer(9));
    DumpNode(MyNode);
    WriteLn();

    TmpNode.Remove();
    DumpNode(MyNode);

end.
