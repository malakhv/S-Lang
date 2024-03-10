program slang;

{$MODE DELPHI}
{$H+}
{$T+}

uses Types, Os, SLang.Collections, SLang.List, SLang.Tree;


procedure DumpNode(Node: TTreeNode);
var I, D: Integer;
begin
    WriteLn();
    if Node = nil then WriteLn('NIL');
    //WriteLn(Node);
    D := Node.Deep();
    Write('':D*3); WriteLn('Deep: ', D);
    Write('':D*3); WriteLn('Count: ', Integer(Node.Count));
    Write('':D*3); WriteLn('Element: ', Integer(Node.Element));

    for I := 0 to Node.Count - 1 do
        DumpNode(Node[i]);
    //WriteLn('Element: ', Integer(Node.Element));
end;


var
    I: Integer;
    MyNode: TTreeNode;

begin
    WriteLn('Welcome to S-Lang compiler. ','Target OS is ', Os.getTargetOS);
    WriteLn();

    MyNode := TTreeNode.Create(Pointer(5));
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

end.
