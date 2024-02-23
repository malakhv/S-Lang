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
        { The pointer to a real value that stored into a linked list. }
        Value: Pointer;
        { A previous element in the linked list, or nil. }
        Prev: PListItem;
        { A next element in the linked list, or nil. }
        Next: PListItem;
        { Returns True if this Item has link to a real value. }
        function HasData(): Boolean;
        { Returns True if this Item is not a last element into a linked list. }
        function HasNext(): Boolean;
        { Returns True if this Item is not a first element into a linked list. }
        function HasPrev(): Boolean;
        { Clears all data in this Item. }
        procedure Clear();
    end;

    {
        The linked list.
    }
    TLinkedList = class(TObject)
    private
        FHead: PListItem;
    protected
        {See Count property}
        function GetCount(): Integer;
        { Returns the last element in this linked list. }
        function GetLast(): PListItem;
        { Finds an item by its value in this linked list. }
        function ItemOf(Value: Pointer): PListItem; overload;
        { Finds an item by its index in this linked list. }
        function ItemOf(Index: Integer): PListItem; overload;
    public
        { The first element in this linked list. }
        property First: PListItem read FHead;
        { The number of elements in this linked list. }
        property Count: Integer read GetCount;
        { Adds a new element to this linked list by value. }
        function Add(Value: Pointer): PListItem;
        { Removes specified element from this linked list. }
        function Remove(Value: Pointer): Boolean; overload;
        { Removes an element from this linked list by its index. }
        function Remove(Index: Integer): Boolean; overload;
        { Returns True if this linked list is empty. }
        function IsEmpty(): Boolean;
    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{ Removes specified Items from its Linked list. }
procedure RemoveItem(var Item: PListItem);
begin
    if Item = nil then Exit;
    if Item^.HasPrev() then Item^.Prev^.Next := Item^.Next;
    if Item^.HasNext() then Item^.Next^.Prev := Item^.Prev;
    // Can we do it here?
    Delete(Item);
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

function TLinkedList.IsEmpty(): Boolean;
begin
    Result := FHead = nil;
end;

function TLinkedList.GetLast(): PListItem;
begin
    if Self.IsEmpty then Exit;
    Result := FHead;
    while Result.Next <> nil do
        Result := Result.Next;
end;

function TLinkedList.ItemOf(Value: Pointer): PListItem;
begin
    If Self.IsEmpty() then Exit;
    Result := FHead;
    while Result <> nil do
    begin
        if Result^.Value = Value then Exit;
        Result := Result^.Next;
    end;
end;

function TLinkedList.ItemOf(Index: Integer): PListItem;
begin
    If Self.IsEmpty() then Exit;
    Result := FHead;
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
    Last := Self.GetLast();
    if Last <> nil then
    begin
        Result^.Prev := Last;
        Last^.Next := Result;
    end else
        FHead := Result;
end;

function TLinkedList.GetCount(): Integer;
var Item: PListItem;
begin
    Result := 0;
    If Self.IsEmpty() then Exit;
    Item := FHead;
    repeat
        Inc(Result);
        Item := Item.Next;
    until Item = nil;
end;

function TLinkedList.Remove(Value: Pointer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Value);
    Result := Item <> nil;
    if Result and (FHead = Item) then FHead = Item^.Next;
    RemoveItem(Item);
end;

function TLinkedList.Remove(Index: Integer): Boolean;
var Item: PListItem;
begin
    Item := Self.ItemOf(Index);
    Result := Item <> nil;
    if Result and (Index = 0) FHead = Item^.Next;
    RemoveItem(Item, True);
end;

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}


END.                                                                     { END }

{------------------------------------------------------------------------------}
