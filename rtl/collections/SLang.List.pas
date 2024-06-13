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
{ working with lists. This is a part of S-Lang Collections Framework.          }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: S-Lang.Collections                                                  }
{ Types:   TLinkedList, TArrayList, TStack                                     }
{                                                                              }
{ Dependencies: SLang.Types, SLang.Classes, SLang.Collections                  }
{                                                                              }
{ Created: 22.02.24                                                            }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.List;                                                        { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.Types, SLang.Classes, SLang.Collections;

type

    {
        The item into a linked list with specified element.
    }
    PListItem = ^TListItem;
    TListItem = record
        { The pointer to a real element that stored into this list item. }
        Element: Pointer;
        { A previous item in the linked list, or nil. }
        Prev: PListItem;
        { A next item in the linked list, or nil. }
        Next: PListItem;
        { Returns True if this item empty (has no element). }
        function IsEmpty(): Boolean;
        { Returns True if this item is not a last into a linked list. }
        function HasNext(): Boolean;
        { Returns True if this item is not a first into a linked list. }
        function HasPrev(): Boolean;
        { Clears data in this item, after this call, the item will be empty. }
        procedure Clear();
    end;

    {
        The double linked list.
    }
    TLinkedList = class(TInterfacedObject, IList)
    private
        FFirst: PListItem;  // See First property
        FLast: PListItem;   // See Last property
        FCount: Integer;    // See Count property
        FUnique: Boolean;   // See Unique property
        { Returns True if specified index is correct for this list. }
        function CheckIndex(Index: Integer): Boolean;
    protected
        { Appends the specified element to the end of this list. }
        function AddItem(const Element: Pointer): PListItem; virtual;
        { Inserts the specified element at the specified position. }
        function InsertItem(Index: Integer; const Element: Pointer): PListItem;
            virtual;
        { Finds an item by its element in this list. }
        function ItemOf(const Element: Pointer): PListItem; overload;
        { Finds an item by its index in this list. }
        function ItemOf(Index: Integer): PListItem; overload;
        { Removes specified item from this list. }
        function RemoveItem(Item: PListItem): Pointer; virtual;
        { From IList interface. }
        //function GetCount(): Integer;
    public

        { The first item into this list. }
        property First: PListItem read FFirst;
        { The last item into this list. }
        property Last: PListItem read FLast;
        { The number of items into this list. }
        property Count: Integer read FCount;
        { Allows (by default) to have duplicate elements in the list. }
        property Unique: Boolean read FUnique;

        { From ICollection interface. }
        function Add(const Element: Pointer): Boolean;
        { Inserts the specified element at the beginning of this list. }
        function AddFirst(const Element: Pointer): Boolean;
        { From IList interface. }
        function Insert(Index: Integer; const Element: Pointer): Boolean;

        { From ICollection interface. }
        function Contains(const Element: Pointer): Boolean;
        { From IList interface. }
        function Get(Index: Integer): Pointer;
        { From IList interface. }
        function IndexOf(const Element: Pointer): Integer;
        { From IList interface. }
        function Update(Index: Integer; const Element: Pointer): Boolean;

        { From ICollection interface. }
        function GetCount(): Integer;
        { From ICollection interface. }
        function IsEmpty(): Boolean;

        { From IList interface. }
        function Move(FromIndex, ToIndex: Integer): Boolean;
        { Moves element with specified index to the beginning of this list. }
        function MoveToFirst(FromIndex: Integer): Boolean;
        { Moves element with specified index to the end of this list. }
        function MoveToLast(FromIndex: Integer): Boolean;

        { From ICollection interface. }
        function Remove(const Element: Pointer): Boolean; overload;
        { From IList interface. }
        function Remove(Index: Integer): Pointer; overload;
        { Removes the first element from this linked list. }
        function RemoveFirst(): Pointer;
        { Removes the last element from this linked list. }
        function RemoveLast(): Pointer;

        { From IList interface. }
        function Swap(Index1, Index2: Integer): Boolean;
        { Reverses this list. }
        procedure Reverse();
        { From ICollection interface. }
        function ToArray(): TPointers;
        { From IList interface. }
        procedure Clear(); virtual;
        { Free all related resources. }
        destructor Destroy(); override;

    end;
    PLinkedList = ^TLinkedList;

type

    {
        The Stack class represents a last-in-first-out (LIFO) stack of elements.
        The usual push and pop operations are provided, as well as a method to
        peek at the top item on the stack, a method to test for whether the
        stack is empty, and a method to search the stack for an item and
        discover how far it is from the top. When a stack is first created, it
        contains no items.
    }
    // Maybe need to move it to SLang.Stack.pas ?
    TStack = class(TLinkedList)
    public

        { Looks at the element at the top of this stack without removing it
          from the stack. If this stack is empty, returns Nil. }
        function Peek(): Pointer;

        { Removes the element at the top of this stack and returns that element
          as the value of this function. If this stack is empty, returns Nil. }
        function Pop(): Pointer;

        { Pushes an element onto the top of this stack. }
        procedure Push(const Element: Pointer);

    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{ Removes specified Items from its Linked list. }
procedure RemoveFromList(var Item: PListItem);
begin
    if Item = nil then Exit;
    if Item^.HasPrev() then Item^.Prev^.Next := Item^.Next;
    if Item^.HasNext() then Item^.Next^.Prev := Item^.Prev;
    // Can we do it here?
    Dispose(Item);
end;

{------------------------------------------------------------------------------}
{ TListItem                                                                    }
{------------------------------------------------------------------------------}

function TListItem.IsEmpty(): Boolean;
begin
    Result := Self.Element = nil;
end;

function TListItem.HasNext(): Boolean;
begin
    Result := Self.Next <> nil;
end;

function TListItem.HasPrev(): Boolean;
begin
    Result := Self.Prev <> nil;
end;

procedure TListItem.Clear();
begin
    Self.Element := nil; Self.Prev := nil; Self.Next := nil;
end;

{------------------------------------------------------------------------------}
{ TLinkedList                                                                  }
{------------------------------------------------------------------------------}

destructor TLinkedList.Destroy();
begin
    Clear; Inherited;
end;

function TLinkedList.CheckIndex(Index: Integer): Boolean;
begin
    Result := (Index >= 0) and (Index < Self.FCount);
end;

function TLinkedList.AddItem(const Element: Pointer): PListItem;
begin
    New(Result);
    Result^.Element := Element;
    Result^.Next := nil;
    if FLast <> nil then
    begin
        Result^.Prev := FLast;
        FLast^.Next := Result;
    end else
        FFirst := Result;
    FLast := Result;
    Inc(FCount);
end;

function TLinkedList.InsertItem(Index: Integer; const Element: Pointer):
    PListItem;
var Item: PListItem;
begin
    Result := nil;
    Item := Self.ItemOf(Index);
    if Item = nil then Exit;
    New(Result);
    Result^.Element := Element;
    Result^.Next := Item;
    if Item^.HasPrev() then
    begin
        Result^.Prev := Item^.Prev;
        Result^.Prev^.Next := Result;
    end else
    begin
        Result^.Prev := nil;
        FFirst := Result;
    end;
    Item^.Prev := Result;
    Inc(FCount);
end;

function TLinkedList.RemoveItem(Item: PListItem): Pointer;
begin
    if Item = nil then
    begin
        Result := nil; Exit;
    end else
        Result := Item^.Element;
    if FFirst = Item then FFirst := Item^.Next;
    if FLast = Item then FLast := Item^.Prev;
    RemoveFromList(Item);
    Dec(FCount);
end;

function TLinkedList.ItemOf(const Element: Pointer): PListItem;
begin
    Result := nil;
    If Self.IsEmpty() then Exit;
    Result := FFirst;
    while Result <> nil do
    begin
        if Result^.Element = Element then Exit;
        Result := Result^.Next;
    end;
end;

function TLinkedList.ItemOf(Index: Integer): PListItem;
begin
    Result := nil;
    If Self.IsEmpty() or (Index < 0) or (Index >= FCount) then Exit;
    Result := FFirst;
    while (Result <> nil) and (Index > 0) do
    begin
        Result := Result^.Next; Dec(Index);
    end;
end;

procedure TLinkedList.Clear();
begin
    while FFirst <> nil do Self.RemoveFirst();
end;

function TLinkedList.IsEmpty(): Boolean;
begin
    Result := FFirst = nil;
end;

function TLinkedList.GetCount(): Integer;
begin
    Result := FCount;
end;

function TLinkedList.Add(const Element: Pointer): Boolean;
begin
    Result := Self.AddItem(Element) <> nil;
end;

function TLinkedList.AddFirst(const Element: Pointer): Boolean;
begin
    Result := Self.Insert(0, Element);
end;

function TLinkedList.Insert(Index: Integer; const Element: Pointer): Boolean;
begin
    Result := Self.InsertItem(Index, Element) <> nil;
end;

function TLinkedList.Contains(const Element: Pointer): Boolean;
begin
    Result := Self.ItemOf(Element) <> nil;
end;

function TLinkedList.Get(Index: Integer): Pointer;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    if Item <> nil then
        Result := Item^.Element
    else
        Result := nil;
end;

function TLinkedList.Remove(const Element: Pointer): Boolean;
begin
    Result := Self.RemoveItem(Self.ItemOf(Element)) <> nil;
end;

function TLinkedList.Remove(Index: Integer): Pointer;
begin
    Result := Self.RemoveItem(Self.ItemOf(Index));
end;

function TLinkedList.RemoveFirst(): Pointer;
begin
    Result := Self.RemoveItem(FFirst);
end;

function TLinkedList.RemoveLast(): Pointer;
begin
    Result := Self.RemoveItem(FLast);
end;

function TLinkedList.IndexOf(const Element: Pointer): Integer;
var Item: PListItem;
begin
    Result := -1;
    If Self.IsEmpty() then Exit;
    Item := FFirst;
    while Item <> nil do
    begin
        Inc(Result);
        if Item^.Element = Element then Break;
        Item := Item^.Next;
    end;
end;

function TLinkedList.Move(FromIndex, ToIndex: Integer): Boolean;
var Item: PListItem;
begin
    Result := False;
    If (FromIndex = ToIndex) or (ToIndex >= FCount) then Exit;
    Item := Self.ItemOf(FromIndex);
    if Item = nil then Exit;
    if ToIndex < FCount - 1 then
        Result := Self.Insert(ToIndex, Item^.Element)
    else
        Result := Self.Add(Item^.Element);
    Self.RemoveItem(Item);
end;

function TLinkedList.MoveToFirst(FromIndex: Integer): Boolean;
begin
    Result := Self.Move(FromIndex, 0);
end;

function TLinkedList.MoveToLast(FromIndex: Integer): Boolean;
begin
    Result := Self.Move(FromIndex, FCount - 1);
end;

function TLinkedList.Swap(Index1, Index2: Integer): Boolean;
var Item1, Item2: PListItem;
    Tmp: Pointer;
begin
    Result := (Index1 <> Index2) and Self.CheckIndex(Index1)
        and Self.CheckIndex(Index2);
    if not Result then Exit;
    Item1 := Self.ItemOf(Index1);
    Item2 := Self.ItemOf(Index2);
    Tmp := Item1^.Element;
    Item1^.Element := Item2^.Element;
    Item2^.Element := Tmp;
end;

function TLinkedList.Update(Index: Integer; const Element: Pointer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    Result := (Item <> nil) and (Item^.Element <> Element);
    if Result then Item^.Element := Element;
end;

function TLinkedList.ToArray(): TPointers;
var I: Integer;
    Item: PListItem;
begin
    SetLength(Result, Self.Count);
    Item := Self.First; I := 0;
    while Item <> nil do
    begin
        Result[I] := Item^.Element;
        Item := Item^.Next;
        Inc(I);
    end;
end;

procedure TLinkedList.Reverse();
var Item, Tmp: PListItem;
begin
    Item := Self.FFirst;
    Tmp := Self.FLast;
    Self.FLast := Self.FFirst;
    Self.FFirst := Tmp;
    while Item <> nil do
    begin
        Tmp := Item^.Next;
        Item^.Next := Item^.Prev;
        Item^.Prev := Tmp;
        Item := Tmp;
    end;
end;

{------------------------------------------------------------------------------}
{ TStack                                                                       }
{------------------------------------------------------------------------------}

function TStack.Peek(): Pointer;
begin
    Result := Self.Get(0);
end;

function TStack.Pop(): Pointer;
begin
    Result := Self.Peek(); Self.RemoveFirst();
end;

procedure TStack.Push(const Element: Pointer);
begin
    Self.AddFirst(Element);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
