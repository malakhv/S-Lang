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

type

    {
        The Item into a linked list.
    }
    PListItem = ^TListItem;
    TListItem = record
        { The pointer to a real data that stored into a linked list. }
        Value: Pointer;
        { A previous element in the linked list, or nil. }
        Prev: PListItem;
        { A next element in the linked list, or nil. }
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
        FFirst: PListItem;
        FLast: PListItem;
        FCount: Integer;
    protected
        {See Count property}
        function GetCount(): Integer;
        { Returns the last element in this linked list. }
        function GetLast(): PListItem;
        { Finds an item by its value in this linked list. }
        function ItemOf(Value: Pointer): PListItem; overload;
        { Finds an item by its index in this linked list. }
        function ItemOf(Index: Integer): PListItem; overload;
        { Removes specified item from this linked list. }
        procedure Remove(Item: PListItem); overload; virtual;
    public
        { The first element into this linked list. }
        property First: PListItem read FFirst;
        { The last element into this linked list. }
        property Last: PListItem read FLast;
        { The number of elements in this linked list. }
        property Count: Integer read FCount;
        { Adds a new element to this linked list. }
        function Add(Value: Pointer): PListItem;
        function AddFirst(Value: Pointer): PListItem;
        { Inserts a new element to this linked list in specified position. }
        function Insert(Value: Pointer; Index: Integer): PListItem;
        { Returns value from this linked list by index. }
        function GetValue(Index: Integer): Pointer;
        { Sets the new value for item into this linked list. }
        procedure SetValue(Index: Integer; Value: Pointer);
        { Removes specified element from this linked list. }
        function Remove(Value: Pointer): Boolean; overload;
        { Removes an element from this linked list by its index. }
        function Remove(Index: Integer): Boolean; overload;
        function RemoveFirst(): Boolean;
        function RemoveLast(): Boolean;
        { Returns value in this linked list by index. }
        function ValueOf(Index: Integer): Pointer; virtual;
        { Returns True if this linked list is empty. }
        function IsEmpty(): Boolean;
        procedure Revert();
        { Clears this linked list. }
        procedure Clear();
        { Free all related resources. }
        destructor Destroy(); override;
    end;

{ Print all items from specified list. }
procedure Dump(AList: TLinkedList);

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{ Removes specified Items from its Linked list. }
procedure RemoveItem(var Item: PListItem);
begin
    if Item = nil then Exit;
    if Item^.HasPrev() then Item^.Prev^.Next := Item^.Next;
    if Item^.HasNext() then Item^.Next^.Prev := Item^.Prev;
    // Can we do it here?
    Dispose(Item);
end;

procedure PrintListItem(Item: PListItem);
begin
    if Item <> nil then
    begin
        WriteLn('   Item:  ', Integer(Item));
        WriteLn('   Prev:  ', Integer(Item^.Prev));
        WriteLn('   Next:  ', Integer(Item^.Next));
        WriteLn('   Value: ', Integer(Item^.Value));
    end else
        WriteLn('   Item is NIL');
end;

procedure Dump(AList: TLinkedList);
var Item: PListItem;
begin
    WriteLn('First:');
    PrintListItem(AList.First);
    WriteLn('Last:');
    PrintListItem(AList.Last);
    WriteLn('Items:');
    Item := AList.First;
    while Item <> nil do
    begin
        PrintListItem(Item);
        WriteLn();
        Item := Item^.Next;
    end;
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

function TLinkedList.IsEmpty(): Boolean;
begin
    Result := FFirst = nil;
end;

function TLinkedList.GetLast(): PListItem;
begin
    Result := FLast;
    {if Self.IsEmpty then Exit;
    Result := FFirst;
    while Result.Next <> nil do
        Result := Result.Next;}
end;

function TLinkedList.ItemOf(Value: Pointer): PListItem;
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
    If Self.IsEmpty() then Exit;
    Result := FFirst;
    while (Result <> nil) and (Index > 0) do
    begin
        Result := Result^.Next; Dec(Index);
    end;
end;

function TLinkedList.Add(Value: Pointer): PListItem;
var Last: PListItem;
begin
    New(Result);
    Result^.Value := Value;
    Result^.Next := nil;
    Last := Self.GetLast();
    if Last <> nil then
    begin
        Result^.Prev := Last;
        Last^.Next := Result;
    end else
        FFirst := Result;
    FLast := Result;
    Inc(FCount);
end;

function TLinkedList.Insert(Value: Pointer; Index: Integer): PListItem;
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

function TLinkedList.GetCount(): Integer;
var Item: PListItem;
begin
    Result := 0;
    If Self.IsEmpty() then Exit;
    Item := FFirst;
    repeat
        Inc(Result);
        Item := Item.Next;
    until Item = nil;
end;

function TLinkedList.GetValue(Index: Integer): Pointer;
begin
    Result := ValueOf(Index);
end;

procedure TLinkedList.SetValue(Index: Integer; Value: Pointer);
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    if Item <> nil then Item^.Value := Value
end;

function TLinkedList.Remove(Value: Pointer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Value);
    Result := Item <> nil;
    if Result and (FFirst = Item) then FFirst := Item^.Next;
    if Result and (FLast = Item) then FLast := Item^.Prev;
    Self.Remove(Item);
end;

function TLinkedList.Remove(Index: Integer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    Result := Item <> nil;
    if Result and (FFirst = Item) then FFirst := Item^.Next;
    if Result and (FLast = Item) then FLast := Item^.Prev;
    Self.Remove(Item);
end;

procedure TLinkedList.Remove(Item: PListItem);
begin
    RemoveItem(Item);
    Dec(FCount);
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

procedure TLinkedList.Clear();
begin
    while FFirst <> nil do Self.Remove(0);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
