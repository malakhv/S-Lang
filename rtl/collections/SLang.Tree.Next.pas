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
{ Created: 05.06.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.Tree.Next;                                                   { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.System, SLang.Classes, SLang.Collections, SLang.List;

type

    {
        The node of tree with specified element. For more details about tree
        data structure, please see
        https://en.wikipedia.org/wiki/Tree_(data_structure).
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

END.                                                                     { END }

{------------------------------------------------------------------------------}
