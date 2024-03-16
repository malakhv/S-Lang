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

    {PTreeNode = ^TTreeNode;
    TTreeNode = record // Shold be a class?
        Element: Pointer;
        Parent: PTreeNode;
        Nodes: TLinkedList;
        function Add(Element: Pointer): Boolean;
        function IsEmpty(): Boolean;
        function HasNodes(): Boolean;
        function HasParent(): Boolean;
        function Deep(): Integer;
        procedure Clear();
    end;}

    PTreeNodeRect = ^TTreeNodeRect;
    TTreeNodeRect = record
    private
        FElement: Pointer;
        FParent: PTreeNodeRect;
        FChildren: PLinkedList;
        function GetHeight(): Integer;
        function GetDeep(): Integer;
        function GetChildCount(): Integer;
        function GetLeftChild(): PTreeNodeRect;
        function GetRightChild(): PTreeNodeRect;
        function GetChild(Index: Integer): PTreeNodeRect;
    public
        property Element: Pointer read FElement write FElement;
        property Parent: PTreeNodeRect read FParent;

        function Add(AElement: Pointer): PTreeNodeRect;

        property Children[Index: Integer]: PTreeNodeRect read GetChild; default;
        property ChildCount: Integer read GetChildCount;
        property Left: PTreeNodeRect read GetLeftChild;
        property Right: PTreeNodeRect read GetRightChild;

        property Height: Integer read GetHeight;
        property Deep: Integer read GetDeep;

        function IsLeaf(): Boolean;
        procedure Clear();
    end;

    { https://en.wikipedia.org/wiki/Tree_(data_structure) }
    //TTree = class;
    TTreeNode = class (TObject)
    private
        //FOwner: TTree;
        FElement: Pointer;
        FParent: TTreeNode;
        FChildren: TLinkedList;
    protected
        function GetHeight(): Integer;
        function GetDeep(): Integer;
        function GetChildCount(): Integer;
        function GetLeftChild(): TTreeNode;
        function GetRightChild(): TTreeNode;
        function GetChild(Index: Integer): TTreeNode;
    public
        property Element: Pointer read FElement write FElement;
        property Parent: TTreeNode read FParent;
        property Height: Integer read GetHeight;
        property Deep: Integer read GetDeep;
        property Left: TTreeNode read GetLeftChild;
        property Right: TTreeNode read GetRightChild;
        property ChildCount: Integer read GetChildCount;
        property Children[Index: Integer]: TTreeNode read GetChild; default;
        function Add(AElement: Pointer): TTreeNode;
        function Remove(): Pointer; overload;
        function Remove(Index: Integer): Pointer; overload;
        function IsLeaf(): Boolean;
        function IsSibling(Node: TTreeNode): Boolean;
        procedure Clear();
        constructor Create(AElement: Pointer); virtual;
        destructor Destroy; override;
    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

function RemoveNode(Node: PTreeNodeRect): Pointer;
begin
    if Node = nil then Exit;
    Result := Node^.Element;
    if Node^.Parent <> nil then
        Node^.Parent^.FChildren^.Remove(Node);
    Node^.Clear();
    Dispose(Node);
end;

procedure TTreeNodeRect.Clear();
var I: Integer;
begin
    for I := 0 to Self.ChildCount -1 do Self[I]^.Clear;
    FChildren.Clear();
end;

function TTreeNodeRect.Add(AElement: Pointer): PTreeNodeRect;
var List: TLinkedList;
begin
    New(Result);
    Result^.Element := AElement;
    Result^.FParent := @Self;

    if Self.FChildren = nil then
    begin
        List := TLinkedList.Create();
        Self.FChildren := @(List);
    end;

    if not FChildren.Add(Result) then
    begin
        Dispose(Result); Result := nil;
    end;
end;

function TTreeNodeRect.GetChildCount(): Integer;
begin
    Result := FChildren^.Count;
end;

function TTreeNodeRect.GetChild(Index: Integer): PTreeNodeRect;
begin
    Result := PTreeNodeRect(FChildren^.Get(Index));
end;

function TTreeNodeRect.GetLeftChild(): PTreeNodeRect;
begin
    Result := PTreeNodeRect(FChildren^.First^.Element);
end;

function TTreeNodeRect.GetRightChild(): PTreeNodeRect;
begin
    Result := PTreeNodeRect(FChildren^.Last^.Element);
end;

function TTreeNodeRect.GetDeep(): Integer;
begin
    Result := 0;
    if Self.FParent <> nil then
        Result := Self.FParent^.Deep + 1;
end;

function TTreeNodeRect.GetHeight(): Integer;
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

function TTreeNodeRect.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

constructor TTreeNode.Create(AElement: Pointer);
begin
    inherited Create();
    FElement := AElement;
    FChildren := TLinkedList.Create;
end;

destructor TTreeNode.Destroy();
begin
    Clear();
    FChildren.Free();
end;

procedure TTreeNode.Clear();
var I: Integer;
    Node: TTreeNode;
begin
    for I := 0 to Self.ChildCount -1 do Self[I].Free();
    FChildren.Clear();
end;

function TTreeNode.Add(AElement: Pointer): TTreeNode;
var Node: TTreeNode;
begin
    Node := TTreeNode.Create(AElement);
    Node.FParent := Self;
    if FChildren.Add(Node) then
        Result := Node
    else
        Node.Free();
end;

function TTreeNode.Remove(Index: Integer): Pointer;
var Node: TTreeNode;
begin
    Result := nil;
    Node := Self[Index];
    if Node = nil then Exit;
    Result := Node.Element;
    Node.Clear();
    Node.Free();
    FChildren.Remove(Index);
end;

function TTreeNode.Remove(): Pointer;
begin
    Result := Self.Element;
    if Self.Parent <> nil then Self.Parent.FChildren.Remove(Self);
    Self.Clear();
    Self.Free();
end;

function TTreeNode.GetDeep(): Integer;
begin
    Result := 0;
    if Self.Parent <> nil then
        Result := Self.Parent.Deep + 1;
end;

function TTreeNode.GetHeight(): Integer;
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

function TTreeNode.GetChildCount(): Integer;
begin
    Result := FChildren.Count;
end;

function TTreeNode.GetChild(Index: Integer): TTreeNode;
begin
    Result := TTreeNode(FChildren.Get(Index));
end;

function TTreeNode.GetLeftChild(): TTreeNode;
begin
    Result := TTreeNode(FChildren.First^.Element);
end;

function TTreeNode.GetRightChild(): TTreeNode;
begin
    Result := TTreeNode(FChildren.Last^.Element);
end;

function TTreeNode.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

function TTreeNode.IsSibling(Node: TTreeNode): Boolean;
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
