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
{ Project: S-Lang                                                              }
{ Package: S-Lang.RTL.Collections                                              }
{ Types:   List                                                                }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: [DATE]                                                              }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT List;                                                              { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses Classes;

type

    {
        The Item into a linked list with specified value (element).
    }
    PListItem = ^TListItem;
    TListItem = record
        { The pointer to a real element that stored into a linked list. }
        Value: Pointer;
        { A previous item in the linked list, or nil. }
        Prev: PListItem;
        { A next item in the linked list, or nil. }
        Next: PListItem;
        { Returns True if this Item has link to a real data. }
        function HasData(): Boolean;
        { Returns True if this Item is not a last element into a linked list. }
        function HasNext(): Boolean;
        { Returns True if this Item is not a first element into a linked list. }
        function HasPrev(): Boolean;
        { Clears all data in this Item. }
        procedure Clear();
    end;

    {
        The double linked list.
    }
    TLinkedList = class(TObject)
    private
        FFirst: PListItem;  // See First property
        FLast: PListItem;   // See Last property
        FCount: Integer;    // See Count property
        FUnique: Boolean;   // See Unique property
    protected
        { Appends the specified element to the end of this list. }
        function AddItem(const Value: Pointer): PListItem; virtual;
        { Inserts the specified element at the specified position in this
            list. }
        function InsertItem(Index: Integer; const Value: Pointer):
            PListItem; virtual;
        { Finds an item by its value in this list. }
        function ItemOf(const Value: Pointer): PListItem; overload;
        { Finds an item by its index in this list. }
        function ItemOf(Index: Integer): PListItem; overload;
        { Removes specified item from this list. }
        function RemoveItem(Item: PListItem): Boolean; virtual;
    public

        { The first item into this list. }
        property First: PListItem read FFirst;
        { The last item into this list. }
        property Last: PListItem read FLast;
        { The number of items into this list. }
        property Count: Integer read FCount;

        { Allows (by default) to have duplicate elements in the list. }
        property Unique: Boolean read FUnique;

        { Appends the specified element to the end of this list. }
        function Add(const Value: Pointer): Boolean;
        { Inserts the specified element at the beginning of this list. }
        function AddFirst(const Value: Pointer): Boolean;
        { Inserts the specified element at the specified position in this
            list. }
        function Insert(Index: Integer; const Value: Pointer): Boolean;

        { Returns true if this list contains the specified element. More
            formally, returns true if and only if this list contains at least
            one specified element. }
        function Contains(const Value: Pointer): Boolean;

        { Removes specified element from this list. }
        function Remove(const Value: Pointer): Boolean; overload;
        { Removes an element from this list by its index. }
        function Remove(Index: Integer): Boolean; overload;
        { Removes the first element from this linked list. }
        function RemoveFirst(): Boolean;
        { Removes the last element from this linked list. }
        function RemoveLast(): Boolean;

        { Returns the index of the first occurrence of the specified element in
            this list, or -1 if this list does not contain the element. }
        function IndexOf(const Value: Pointer): Integer;
        { Returns value in this linked list by index. }
        function ValueOf(Index: Integer): Pointer; virtual;

        { Moves element with specified index to a new position in this list. }
        function Move(OldIndex, NewIndex: Integer): Boolean; virtual;
        { Moves element with specified index to the beginning of this list. }
        function MoveToFirst(Index: Integer): Boolean;
        { Moves element with specified index to the end of this list. }
        function MoveToLast(Index: Integer): Boolean;

        { Replaces the element at the specified position in this list with the
            specified element. }
        function Update(Index: Integer; const Value: Pointer): Boolean; virtual;

        { Returns True if this linked list is empty. }
        function IsEmpty(): Boolean;

        { Returns an array containing all of the elements in this list in
            proper sequence (from first to last element). }
        function ToArray(): TPointers;

        { Reverses this list. }
        procedure Reverse();

        { Clears this linked list. }
        procedure Clear(); virtual;
        { Free all related resources. }
        destructor Destroy(); override;

    end;

type

    TStack = class(TLinkedList)
    private

    protected
        //function Remove(Item: PListItem): Boolean; override;
    public


    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{ Removes specified Items from its Linked list. }
procedure RemoveItemFromList(var Item: PListItem);
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

function TListItem.HasData(): Boolean;
begin
    Result := Self.Value = nil;
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
    Self.Value := nil; Self.Prev := nil; Self.Next := nil;
end;

{------------------------------------------------------------------------------}
{ TLinkedList                                                                  }
{------------------------------------------------------------------------------}

destructor TLinkedList.Destroy();
begin
    Clear; Inherited;
end;

procedure TLinkedList.Clear();
begin
    while FFirst <> nil do Self.RemoveFirst();
end;

function TLinkedList.IsEmpty(): Boolean;
begin
    Result := FFirst = nil;
end;

function TLinkedList.ItemOf(const Value: Pointer): PListItem;
begin
    If Self.IsEmpty() then Exit;
    Result := FFirst;
    while Result <> nil do
    begin
        if Result^.Value = Value then Exit;
        Result := Result^.Next;
    end;
end;

function TLinkedList.ItemOf(Index: Integer): PListItem;
begin
    If Self.IsEmpty() or (Index >= FCount) then Exit;
    Result := FFirst;
    while (Result <> nil) and (Index > 0) do
    begin
        Result := Result^.Next; Dec(Index);
    end;
end;

function TLinkedList.AddItem(const Value: Pointer): PListItem;
begin
    New(Result);
    Result^.Value := Value;
    Result^.Next := nil;
    if FLast <> nil then
    begin
        Result^.Prev := Last;
        Last^.Next := Result;
    end else
        FFirst := Result;
    FLast := Result;
    Inc(FCount);
end;

function TLinkedList.Add(const Value: Pointer): Boolean;
begin
    Result := Self.AddItem(Value) <> nil;
end;

function TLinkedList.AddFirst(const Value: Pointer): Boolean;
begin
    Result := Self.Insert(0, Value);
end;

function TLinkedList.InsertItem(Index: Integer; const Value: Pointer):
    PListItem;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    if Item = nil then Exit;
    New(Result);
    Result^.Value := Value;
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

function TLinkedList.Insert(Index: Integer; const Value: Pointer): Boolean;
begin
    Result := Self.InsertItem(Index, Value) <> nil;
end;

function TLinkedList.Contains(const Value: Pointer): Boolean;
begin
    Result := Self.ItemOf(Value) <> nil;
end;

function TLinkedList.RemoveItem(Item: PListItem): Boolean;
begin
    Result := Item <> nil;
    if not Result then Exit;
    if FFirst = Item then FFirst := Item^.Next;
    if FLast = Item then FLast := Item^.Prev;
    RemoveItemFromList(Item);
    Dec(FCount);
end;

function TLinkedList.Remove(const Value: Pointer): Boolean;
begin
    Result := Self.RemoveItem(Self.ItemOf(Value));
end;

function TLinkedList.Remove(Index: Integer): Boolean;
begin
    Result := Self.RemoveItem(Self.ItemOf(Index));
end;

function TLinkedList.RemoveFirst(): Boolean;
begin
    Result := Self.RemoveItem(FFirst);
end;

function TLinkedList.RemoveLast(): Boolean;
begin
    Result := Self.RemoveItem(FLast);
end;

function TLinkedList.IndexOf(const Value: Pointer): Integer;
var Item: PListItem;
begin
    Result := -1;
    If Self.IsEmpty() then Exit;
    Item := FFirst;
    while Item <> nil do
    begin
        Inc(Result);
        if Item^.Value = Value then Break;
        Item := Item^.Next;
    end;
end;

function TLinkedList.ValueOf(Index: Integer): Pointer;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    if Item <> nil then
        Result := Item.Value
    else
        Result := nil;
end;

function TLinkedList.Move(OldIndex, NewIndex: Integer): Boolean;
var Item: PListItem;
begin
    Result := False;
    If (OldIndex = NewIndex) or (NewIndex >= FCount) then Exit;
    Item := Self.ItemOf(OldIndex);
    if Item = nil then Exit;
    if NewIndex < FCount - 1 then
        Result := Self.Insert(NewIndex, Item^.Value)
    else
        Result := Self.Add(Item^.Value);
    Self.Remove(Item);
end;

function TLinkedList.MoveToFirst(Index: Integer): Boolean;
begin
    Result := Self.Move(Index, 0);
end;

function TLinkedList.MoveToLast(Index: Integer): Boolean;
begin
    Result := Self.Move(Index, FCount - 1);
end;

function TLinkedList.Update(Index: Integer; const Value: Pointer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    Result := (Item <> nil) and (Item^.Value <> Value);
    if Result then Item^.Value := Value;
end;

function TLinkedList.ToArray(): TPointers;
var I: Integer;
    Item: PListItem;
begin
    SetLength(Result, Self.Count);
    Item := Self.First; I := 0;
    while Item <> nil do
    begin
        Result[I] := Item^.Value;
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

END.                                                                     { END }

{------------------------------------------------------------------------------}
