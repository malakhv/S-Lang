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

    PTreeNode = ^TTreeNode;
    TTreeNode = record // Shold be a class?
        Element: Pointer;
        Parent: PTreeNode;
        Nodes: TLinkedList;
        function Add(Element: Pointer): Boolean;
        function Remove(Element: Pointer): Boolean;
        function IsEmpty(): Boolean;
        function HasNodes(): Boolean;
        function HasParent(): Boolean;
        function Deep(): Integer;
        procedure Clear();
    end;

//type

    {TTreeNode<V> = class (TNode<V>)
    private
        FParent: TTreeNode<V>;
        FNodes: Array of TTreeNode<V>;
    protected
        function GetParent(): TTreeNode<V>;
        //function GetChildNode(Index: Integer): TTreeNode<V>;
        procedure SetParent(AParent: TTreeNode<V>);
    public
        property Parent: TTreeNode<V> read GetParent write SetParent;
        //property Nodes[Integer]: Array of TTreeNode<V> read GetChildNode;
        
        function AddNode(ANode: TTreeNode<V>): TTreeNode<V>; virtual;
        function AddValue(AValue: V): TTreeNode<V>; virtual;
        
    
        function GetParentValue(): V;
        function HasParent(): Boolean;
        
        procedure Clear(); virtual;
        
        constructor Create(AValue: V); override;
    end;
    //TTreeNode = specialize TTreeNode<V>;
    //PTreeNode = ^TTreeNode;}

{type

    TTree<V> = class(TObject)
    private
        FRoot: TTreeNode<V>;
    protected
        //function Get(Index: Integer): 
    public
        //property Items[Index: Integer]: V read Get write Set; default;
    end; }

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TTreeNode                                                                    }
{------------------------------------------------------------------------------}

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
