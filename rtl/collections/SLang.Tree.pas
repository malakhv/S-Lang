{------------------------------------------------------------------------------}
{                                                                              }
{                                S-Lang Project                                }
{                                                                              }
{  Copyright (C) 1996-2024 Mikhail Malakhov <malakhv@gmail.com>                }
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License"). You may     }
{  not use this file except in compliance with the License. You may obtain     }
{  a copy of the License at                                                    }
{                                                                              }
{     http://www.apache.org/licenses/LICENSE-2.0                               }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT   }
{  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.            }
{                                                                              }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ This Unit includes basic data types' definitions and common routines to      }
{ working with it.                                                             }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: S-Lang.Collections                                                  }
{ Types:   Tree                                                                }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: [DATE]                                                              }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.Tree;                                                        { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.Collections, SLang.List;

type

    {
        The node of tree with specified element. For more details about tree
        data structure, please see
        https://en.wikipedia.org/wiki/Tree_(data_structure).
    }
    PTreeNode = ^TTreeNode;
    TTreeNode = record              // In fact, this record is 12 bytes in size.
    private
        FElement: Pointer;          // See Element property.
        FParent: PTreeNode;         // See Parent property.
        FChildren: TLinkedList;     // See Children property.
        { See Height property. }
        function GetHeight(): Integer;
        { See Deep property. }
        function GetDepth(): Integer;
        { See ChildCount property. }
        function GetChildCount(): Integer;
        { See Left property. }
        function GetLeftChild(): PTreeNode;
        { See Right property. }
        function GetRightChild(): PTreeNode;
        { See Children property. }
        function GetChild(Index: Integer): PTreeNode;
    public
        { The pointer to a real element that stored into this tree node. }
        property Element: Pointer read FElement write FElement;
        { A parent of this tree node, or nil (for root node). }
        property Parent: PTreeNode read FParent;
        { The number of child nodes for this tree node. }
        property ChildCount: Integer read GetChildCount;
        { The list of child nodes of this tree node. }
        property Children[Index: Integer]: PTreeNode read GetChild; default;
        { The first child node for this tree node. }
        property Left: PTreeNode read GetLeftChild;
        { The last child node for this tree node. }
        property Right: PTreeNode read GetRightChild;
        { The length of the path to root from this tree node. Thus the root
          node has depth zero. This is the same as level. }
        property Depth: Integer read GetDepth;
        { The length of the longest downward path to a leaf from this tree
          node. The height of the root is the height of the tree. }
        property Height: Integer read GetHeight;
        function Add(AElement: Pointer): PTreeNode;
        { Returns True, if this tree node has no child nodes. }
        function IsLeaf(): Boolean;
        { Returns True, if this tree node has the same parent as specified
          node. }
        function IsSibling(Node: PTreeNode): Boolean;
        { Removes all children nodes from this tree node. }
        procedure Clear();
    end;

    { https://en.wikipedia.org/wiki/Tree_(data_structure) }
    //TTree = class;
    TTreeNodeC = class (TObject)
    private
        //FOwner: TTree;
        FElement: Pointer;
        FParent: TTreeNodeC;
        FChildren: TLinkedList;
    protected
        function GetHeight(): Integer;
        function GetDeep(): Integer;
        function GetChildCount(): Integer;
        function GetLeftChild(): TTreeNodeC;
        function GetRightChild(): TTreeNodeC;
        function GetChild(Index: Integer): TTreeNodeC;
    public
        property Element: Pointer read FElement write FElement;
        property Parent: TTreeNodeC read FParent;
        property Height: Integer read GetHeight;
        property Deep: Integer read GetDeep;
        property Left: TTreeNodeC read GetLeftChild;
        property Right: TTreeNodeC read GetRightChild;
        property ChildCount: Integer read GetChildCount;
        property Children[Index: Integer]: TTreeNodeC read GetChild; default;
        function Add(AElement: Pointer): TTreeNodeC;
        function Remove(): Pointer; overload;
        function Remove(Index: Integer): Pointer; overload;
        function IsLeaf(): Boolean;
        function IsSibling(Node: TTreeNodeC): Boolean;
        procedure Clear();
        constructor Create(AElement: Pointer); virtual;
        destructor Destroy; override;
    end;

type

    {
        The Tree data structure.
    }
    TTree = class(TInterfacedObject, IList)
    private
        FRoot: PTreeNode;
    public

    end;

function MakeRootNode(): PTreeNode;

IMPLEMENTATION                                                { IMPLEMENTATION }

function MakeRootNode(): PTreeNode;
begin
    New(Result); Result^.FParent := nil;
end;

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

function RemoveNode(Node: PTreeNode): Pointer;
begin
    if Node = nil then Exit;
    Result := Node^.Element;
    if Node^.Parent <> nil then
        Node^.Parent^.FChildren.Remove(Node);
    Node^.Clear();
    Dispose(Node);
end;

procedure TTreeNode.Clear();
var I: Integer;
begin
    if FChildren = nil then Exit;
    for I := 0 to Self.ChildCount -1 do Self[I]^.Clear;
    FChildren.Clear();
end;

function TTreeNode.Add(AElement: Pointer): PTreeNode;
begin
    New(Result);
    Result^.Element := AElement;
    Result^.FParent := @Self;

    if Self.FChildren = nil then
        Self.FChildren := TLinkedList.Create();

    if not Self.FChildren.Add(Result) then
    begin
        Dispose(Result); Result := nil;
    end;
end;

function TTreeNode.GetChildCount(): Integer;
begin
    if FChildren = nil then Result := 0
    else Result := FChildren.Count;
end;

function TTreeNode.GetChild(Index: Integer): PTreeNode;
begin
    Result := PTreeNode(FChildren.Get(Index));
end;

function TTreeNode.GetLeftChild(): PTreeNode;
begin
    Result := PTreeNode(FChildren.First^.Element);
end;

function TTreeNode.GetRightChild(): PTreeNode;
begin
    Result := PTreeNode(FChildren.Last^.Element);
end;

function TTreeNode.GetDepth(): Integer;
begin
    if Self.FParent <> nil then
        Result := Self.FParent^.Depth + 1
    else
        Result := 0
end;

function TTreeNode.GetHeight(): Integer;
var I, H: Integer;
begin
    Result := 0;
    If Self.IsLeaf() then Exit;
    for I := 0 to Self.ChildCount - 1 do
    begin
        H := Self[I]^.Height + 1;
        if Result < H then Result := H;
    end;
end;

function TTreeNode.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

function TTreeNode.IsSibling(Node: PTreeNode): Boolean;
begin
    Result := Self.Parent = Node^.Parent;
end;

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

constructor TTreeNodeC.Create(AElement: Pointer);
begin
    inherited Create();
    FElement := AElement;
    FChildren := TLinkedList.Create;
end;

destructor TTreeNodeC.Destroy();
begin
    Clear();
    FChildren.Free();
end;

procedure TTreeNodeC.Clear();
var I: Integer;
begin
    for I := 0 to Self.ChildCount -1 do Self[I].Free();
    FChildren.Clear();
end;

function TTreeNodeC.Add(AElement: Pointer): TTreeNodeC;
var Node: TTreeNodeC;
begin
    Node := TTreeNodeC.Create(AElement);
    Node.FParent := Self;
    if FChildren.Add(Node) then
        Result := Node
    else
        Node.Free();
end;

function TTreeNodeC.Remove(Index: Integer): Pointer;
var Node: TTreeNodeC;
begin
    Result := nil;
    Node := Self[Index];
    if Node = nil then Exit;
    Result := Node.Element;
    Node.Clear();
    Node.Free();
    FChildren.Remove(Index);
end;

function TTreeNodeC.Remove(): Pointer;
begin
    Result := Self.Element;
    if Self.Parent <> nil then Self.Parent.FChildren.Remove(Self);
    Self.Clear();
    Self.Free();
end;

function TTreeNodeC.GetDeep(): Integer;
begin
    Result := 0;
    if Self.Parent <> nil then
        Result := Self.Parent.Deep + 1;
end;

function TTreeNodeC.GetHeight(): Integer;
var I, H: Integer;
begin
    Result := 0;
    If Self.IsLeaf() then Exit;
    for I := 0 to Self.ChildCount - 1 do
    begin
        H := Self[I].Height + 1;
        if Result < H then Result := H;
    end;
end;

function TTreeNodeC.GetChildCount(): Integer;
begin
    Result := FChildren.Count;
end;

function TTreeNodeC.GetChild(Index: Integer): TTreeNodeC;
begin
    Result := TTreeNodeC(FChildren.Get(Index));
end;

function TTreeNodeC.GetLeftChild(): TTreeNodeC;
begin
    Result := TTreeNodeC(FChildren.First^.Element);
end;

function TTreeNodeC.GetRightChild(): TTreeNodeC;
begin
    Result := TTreeNodeC(FChildren.Last^.Element);
end;

function TTreeNodeC.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

function TTreeNodeC.IsSibling(Node: TTreeNodeC): Boolean;
begin
    Result := Self.Parent = Node.Parent;
end;

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}
{
function TTreeNode.Add(Element: Pointer): Boolean;
begin
    if Self.Nodes = nil then Self.Nodes := TLinkedList.Create();
    Result := Self.Nodes.Add(Element);
end;

function TTreeNode.Remove(Element: Pointer): Boolean;
begin
    Result := (Self.Nodes <> nil) and (Self.Nodes.Remove(Element));
end;

function TTreeNode.IsEmpty(): Boolean;
begin
    Result := Self.Element = nil;
end;

function TTreeNode.HasNodes(): Boolean;
begin
    Result := (Self.Nodes <> nil) and not Nodes.IsEmpty();
end;

function TTreeNode.HasParent(): Boolean;
begin
    Result := Self.Parent <> nil;
end;

function TTreeNode.Deep(): Integer;
var Node: PTreeNode;
begin
    Result := 0;
    Node := Self.Parent;
    while Node <> nil do
    begin
        Inc(Result);
        Node := Node^.Parent;
    end;
end;

procedure TTreeNode.Clear();
begin
    Self.Element := nil;
    Self.Parent := nil;
    Self.Nodes.Clear();
    Self.Nodes.Free();
end;
}
{------------------------------------------------------------------------------}
{ TTreeNode<V>                                                                 }
{------------------------------------------------------------------------------}

{constructor TTreeNode<V>.Create(AValue: V);
begin
    inherited Create(V);
    FParent := nil;
end;

function TTreeNode<V>.AddNode(ANode: TTreeNode<V>): TTreeNode<V>;
var L: Integer;
begin
    L := Length(FNodes);
    SetLength(FNodes, L + 1);
    FNodes[L] := ANode;
    Result := ANode;
end;

function TTreeNode<V>.AddValue(AValue: V): TTreeNode<V>;
var N: TTreeNode<V>;
begin
    N := TTreeNode<V>.Create(V);
    Result := Self.AddNode(N);
end;

function TTreeNode<V>.GetParent(): TTreeNode<V>;
begin
    Result := FParent;
end;

function TTreeNode<V>.GetParentValue(): V;
begin
    if Self.HasParent() then
        Result := Self.Parent.Value
    else
        // TODO Exception?
        Result := nil;
end;

function TTreeNode<V>.HasParent(): Boolean;
begin
    Result := FParent <> nil;
end;

procedure TTreeNode<V>.SetParent(AParent: TTreeNode<V>);
begin
    Self.FParent := AParent;
end;

procedure TTreeNode<V>.Clear();
begin

end;}

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

END.                                                                     { END }

{------------------------------------------------------------------------------}
