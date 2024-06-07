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
{ Dependencies: SLang.Collections, SLang.List                                  }
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
{ the tree hierarchy). You could see more details about tree data structure    }                                                         }
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

uses SLang.System, SLang.Classes, SLang.Collections, SLang.List;

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
    public
        { A parent of this tree node, or nil (for root node). }
        property Parent: TTreeNode read FParent;
        { The number of child nodes for this tree node. }
        property ChildCount: Integer read GetChildCount;
        { The list of child nodes of this tree node. }
        property Children[Index: Integer]: TTreeNode read GetChild; default;
        { Returns True, if this tree node has no child nodes. }
        function IsLeaf(): Boolean;
        { Returns True, if this tree node is root node in its collection. }
        function IsRoot(): Boolean;
        { Constructs a new TTreeNode instance. }
        constructor Create(); virtual;
        { Free all related resources. }
        destructor Destroy(); override;
    end;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

constructor TTreeNode.Create();
begin
    inherited;
    FParent := nil;
    FChildren := TLinkedList.Create();
end;

destructor TTreeNode.Destroy(); override;
begin
    FParent := nil;
    FChildren.Clear();
    FChildren := nil;
end;

function TTreeNode.GetChild(Index: Integer): TTreeNode;
begin
    Result := FChildren.Get(Index);
end;

function TTreeNode.GetChildCount(): Integer;
begin
    Result := FChildren.Count;
end;

function TTreeNode.IsLeaf(): Boolean;
begin
    Result := Self.ChildCount = 0;
end;

function TTreeNode.IsRoot(): Boolean;
begin
    Result := Self.Parent = nil;
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
