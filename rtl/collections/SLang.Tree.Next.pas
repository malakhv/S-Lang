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
{ This Unit contains definitions of data types and some methods to working     }
{ with trees.                                                                  }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: S-Lang.Collections                                                  }
{ Types:   TTreeNode, TTree                                                    }
{                                                                              }
{ Dependencies: SLang.Types, SLang.Classes, SLang.Collections, SLang.List      }
{                                                                              }
{ Created: 05.06.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                  Overview                                    }
{                                                                              }
{ This module, being part of the standard library, provides basic features for }
{ working with trees - a widely used abstract data type that represents a      }
{ hierarchical tree structure with a set of connected nodes.                   }
{                                                                              }
{ Each node in the tree can be connected to many children (depending on the    }
{ type of tree), but must be connected to exactly one parent, except for the   }
{ root node, which has no parent (i.e., the root node as the top-most node in  }
{ the tree hierarchy). You could see more details about tree data structure    }
{ here: https://en.wikipedia.org/wiki/Tree_(data_structure)                    }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                 Definitions                                  }
{                                                                              }
{ Ancestor  - A node reachable by repeated proceeding from child to parent.    }
{                                                                              }
{ Degree    - For a given node, its number of children. A leaf, by definition, }
{             has degree zero.                                                 }
{                                                                              }
{ Distance  - The number of edges along the shortest path between two nodes.   }
{                                                                              }
{------------------------------------------------------------------------------}

UNIT SLang.Tree.Next;                                                   { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.Types, SLang.Classes, SLang.Collections, SLang.List;

type

    {
        The node of tree with specified element.
    }
    TTreeNode = class (TCollectionItem)
    private
        FParent: TTreeNode;         // See Parent property.
        FChildren: TLinkedList;     // See Children property.
    protected
        { See Children property. }
        function GetChild(Index: Integer): TTreeNode;
        { See ChildCount property. }
        function GetChildCount(): Integer;
        { See Deep property. }
        function GetDepth(): Integer;
        { See Height property. }
        function GetHeight(): Integer;
        { See Left property. }
        function GetLeft(): TTreeNode;
        { See Right property. }
        function GetRight(): TTreeNode;
        { See Size property. }
        function GetSize(): Integer;
        { Constructs an empty TTreeNode instance. }
        constructor Create(); override; overload;
        { Constructs a new TTreeNode instance. }
        constructor Create(const AParent: TTreeNode); virtual; overload;
    public
        { A parent of this tree node, or nil (for root node). }
        property Parent: TTreeNode read FParent;
        { The number of child nodes for this tree node. }
        property ChildCount: Integer read GetChildCount; // Maybe Count?
        { The list of child nodes of this tree node. }
        property Children[Index: Integer]: TTreeNode read GetChild; default;
        { The number of children of this tree node. A leaf node, by definition,
          has degree zero. This property is the same as ChildCount. }
        property Degree: Integer read GetChildCount;
        { The length of the path to root from this tree node. Thus the root
          node has depth zero. This is the same as level. }
        property Depth: Integer read GetDepth;
        { The length of the longest downward path to a leaf from this tree
          node. The height of the root is the height of the tree. }
        property Height: Integer read GetHeight;
        { The first child node for this tree node. }
        property Left: TTreeNode read GetLeft;
        { The last child node for this tree node. }
        property Right: TTreeNode read GetRight;
        { The number of nodes in this tree node. For leaf this value
          equals 1. }
        property Size: Integer read GetSize;
        { Add a children for this tree node. }
        // TODO Should be protected
        function Add(AElement: Pointer): TTreeNode;
        { Returns True, if this tree node has no child nodes. }
        function IsLeaf(): Boolean;
        { Returns True, if this tree node is root node in its collection. }
        function IsRoot(): Boolean;
        { Returns True, if this tree node is parent or child for specified
          node. }
        function IsNeighbor(const Node: TTreeNode): Boolean;
        { Returns True, if this tree node has the same parent as specified
          node. }
        function IsSibling(const Node: TTreeNode): Boolean;
        { Free all related resources. }
        destructor Destroy(); override;
    end;

type

    { Tree }
    TTree = class (TInterfacedObject, ITree)
    private
        FRoot: TTreeNode;
    protected
        { See Nodes property. }
        function GetNode(Index: Integer): TTreeNode;
        { Added child node for specified parent. }
        function AddNode(const Parent: TTreeNode;
            const Element: Pointer): TTreeNode; virtual;
    public
        { The root node of this tree. }
        property Root: TTreeNode read FRoot;
        { The list of tree nodes in this tree. }
        property Nodes[Index: Integer]: TTreeNode read GetNode; default;
        { Added child node for specified parent. }
        function Add(const Parent: TTreeNode;
            const Element: Pointer): Boolean; overload;
        { From ICollection interface. }
        function Add(const Element: Pointer): Boolean; overload;
        { From ICollection interface. }
        function Contains(const Element: Pointer): Boolean;
        { From ICollection interface. }
        function GetCount(): Integer;
        { From ICollection interface. }
        function IsEmpty(): Boolean;
        { From ICollection interface. }
        function Remove(const Element: Pointer): Boolean;
        { From ICollection interface. }
        function ToArray(): TPointers;
        { From ICollection interface. }
        procedure Clear();
        { Constructs a new TTree instance. }
        constructor Create(); virtual;
        { Free all related resources. }
        destructor Destroy(); override;
    end;

{
    Makes an empty tree node without data. For testing only!
}
function MakeEmptyNode(): TTreeNode;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

function MakeEmptyNode(): TTreeNode;
begin
    Result := TTreeNode.Create(TTreeNode(nil));
end;

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

constructor TTreeNode.Create();
begin
    Create(nil);
end;

constructor TTreeNode.Create(const AParent: TTreeNode);
begin
    inherited Create();
    Self.FParent := AParent;
    Self.FChildren := TLinkedList.Create();
end;

destructor TTreeNode.Destroy();
begin
    FParent := nil;
    FChildren.Clear();
    FChildren := nil;
    inherited;
end;

function TTreeNode.Add(AElement: Pointer): TTreeNode;
begin
    Result := TTreeNode.Create(Self);
    Result.Element := AElement;
    if not Self.FChildren.Add(Result) then
    begin // Is it possible?
        Result.Free();
        Result := nil;
    end;
end;

function TTreeNode.GetChild(Index: Integer): TTreeNode;
begin
    Result := FChildren.Get(Index);
end;

function TTreeNode.GetChildCount(): Integer;
begin
    Result := FChildren.Count;
end;

function TTreeNode.GetDepth(): Integer;
begin
    if Self.FParent <> nil then
        Result := Self.FParent.Depth + 1
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
        H := Self[I].Height + 1;
        if Result < H then Result := H;
    end;
end;

function TTreeNode.GetLeft(): TTreeNode;
begin
    Result := FChildren.First^.Element;
end;

function TTreeNode.GetRight(): TTreeNode;
begin
    Result := FChildren.Last^.Element;
end;

function TTreeNode.GetSize(): Integer;
var I: Integer;
begin
    Result := 1;
    for I := 0 to Self.ChildCount -1 do
        Result := Result + Self[I].Size;
end;

function TTreeNode.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

function TTreeNode.IsRoot(): Boolean;
begin
    Result := Self.Parent = nil;
end;

function TTreeNode.IsNeighbor(const Node: TTreeNode): Boolean;
begin
    Result := (Node <> nil)
        and ((Self.Parent = Node) or (Node.Parent = Self));
end;

function TTreeNode.IsSibling(const Node: TTreeNode): Boolean;
begin
    Result := (Node <> nil) and (not Self.IsRoot)
        and (Self.Parent = Node.Parent);
end;

{------------------------------------------------------------------------------}
{ TTree                                                                        }
{------------------------------------------------------------------------------}

constructor TTree.Create();
begin
    Inherited;
end;

destructor TTree.Destroy();
begin
    Self.Clear();
    inherited;
end;

function TTree.AddNode(const Parent: TTreeNode;
    const Element: Pointer): TTreeNode;
begin
    // If this tree is empty, lets create root node
    if Self.IsEmpty() then
    begin
        FRoot := TTreeNode.Create(Element);
        Result := FRoot;
        Exit;
    end;
    // If no parent, lets add node to root
    if Parent = nil then
        Result := Self.Root.Add(Element)
    else
        Result := Parent.Add(Element);
end;

function TTree.Add(const Element: Pointer): Boolean;
begin
    Result := Self.AddNode(FRoot, Element) <> nil;
end;

function TTree.Add(const Parent: TTreeNode;
    const Element: Pointer): Boolean; overload;
begin
    Result := Self.AddNode(Parent, Element) <> nil;
end;

function TTree.GetNode(Index: Integer): TTreeNode;
begin
    if index = 0 then Result := Self.Root
    else Result := Self.FRoot[Index];
end;

function TTree.Contains(const Element: Pointer): Boolean;
begin
    Result := False;
end;

function TTree.GetCount(): Integer;
begin
    Result := 0;
end;

function TTree.IsEmpty(): Boolean;
begin
    Result := Self.FRoot = nil;
end;

function TTree.Remove(const Element: Pointer): Boolean;
begin
    Result := False;
end;

function TTree.ToArray(): TPointers;
begin
    Result := nil;
end;

procedure TTree.Clear();
begin
    if Self.FRoot <> nil then Self.FRoot.Clear();
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
