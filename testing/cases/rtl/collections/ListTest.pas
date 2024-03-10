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
{ This Unit includes test cases for RTL List data structures.                  }
{                                                                              }
{ Project: S-Lang                                                              }
{ Package: S-Lang.Testing                                                      }
{ Types:   Not Applicable                                                      }
{                                                                              }
{ Dependencies: Testing, List                                                  }
{                                                                              }
{ Created: 25.02.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT ListTest;                                                          { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.System, SLang.List, Testing;

type
    TListCase = class (TTestCase)
    private
        FItems: Integer;
    public
        function Run(): Boolean; override;
        constructor Create(AName: String); override; overload;
        constructor Create(AName: String; Items: Integer); overload; virtual;
    end;

var ListCase: TListCase;

IMPLEMENTATION                                                { IMPLEMENTATION }

uses SLang.Classes;

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

const TEST_ITEM_COUNT = 10000;

procedure PrintListItem(const Item: PListItem);
begin
    if Item <> nil then
    begin
        WriteLn('   Item:    ', Integer(Item));
        WriteLn('   Prev:    ', Integer(Item^.Prev));
        WriteLn('   Next:    ', Integer(Item^.Next));
        WriteLn('   Element: ', Integer(Item^.Element));
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

procedure FillList(Count: Integer; var L: TLinkedList);
var I: Integer;
begin
    for I := 0 to Count - 1 do L.Add(Pointer(I));
end;

function CheckCount(const L: TLinkedList): Boolean;
var C: Integer;
    Item: PListItem;
begin
    Item := L.First;
    C := 0;
    while Item <> nil do
    begin
        Inc(C);
        Item := Item^.Next;
    end;
    Result := C = L.Count;
end;

{------------------------------------------------------------------------------}
{ Tests                                                                        }
{------------------------------------------------------------------------------}

function FillTest(const Input: Pointer; var Output: Pointer): Boolean;
var Count: Integer;
    Item: PListItem;
    List: TLinkedList;
begin
    List := TLinkedList(Input);
    List.Clear();
    Count := 0;
    FillList(TEST_ITEM_COUNT, List);
    Item := List.First;
    repeat
        Inc(Count);
        Item := Item^.Next;
    until Item = nil;
    Result := (Count = TEST_ITEM_COUNT) and (Count = List.Count);
    Output := List;
end;

function AddTest(const Input: Pointer; var Output: Pointer): Boolean;
var I: Integer;
    List: TLinkedList;
begin
    List := TLinkedList(Input);
    List.Clear();

    List.Add(Pointer(3));
    List.Add(Pointer(4));
    List.Add(Pointer(5));
    List.Add(Pointer(6));
    List.AddFirst(Pointer(2));
    List.AddFirst(Pointer(1));
    List.Add(Pointer(7));
    List.Add(Pointer(8));
    List.Add(Pointer(9));
    List.AddFirst(Pointer(0));

    Result := CheckCount(List);
    if not Result then Exit;
    for I := 0 to List.Count - 1 do
    begin
        Result := Pointer(I) = List.Get(I);
        if not Result then Break;
    end;

    Output := List;
end;

function InsertTest(const Input: Pointer; var Output: Pointer): Boolean;
var I: Integer;
    List: TLinkedList;
begin
    List := TLinkedList(Input);
    List.Clear();

    List.Add(Pointer(7));                   // 7
    List.Insert(0, Pointer(0));             // 0 7
    List.Insert(1, Pointer(6));             // 0 6 7
    List.Insert(1, Pointer(4));             // 0 4 6 7
    List.Insert(2, Pointer(5));             // 0 4 5 6 7
    List.Add(Pointer(9));                   // 0 4 5 6 7 9
    List.Insert(List.Count -1, Pointer(8)); // 0 4 5 6 7 8 9
    List.Insert(1, Pointer(1));             // 0 1 4 5 6 7 8 9
    List.Insert(2, Pointer(2));             // 0 1 2 4 5 6 7 8 9
    List.Insert(3, Pointer(3));             // 0 1 2 3 4 5 6 7 8 9

    Result := CheckCount(List);
    if not Result then Exit;
    for I := 0 to List.Count - 1 do
    begin
        Result := Pointer(I) = List.Get(I);
        if not Result then Break;
    end;

    Output := List;
end;

function RemoveTest(const Input: Pointer; var Output: Pointer): Boolean;
var List: TLinkedList;
begin
    List := TLinkedList(Input);
    List.Clear();

    FillList(10, List);
    List.RemoveLast();
    List.RemoveFirst();
    List.Remove(Pointer(2));
    List.Remove(Pointer(5));
    List.Remove(2);
    List.Remove(3);
    List.Remove(3);
    List.Remove(1);

    Result := CheckCount(List);
    Result := Result and (List.Count = 2)
        and (List.First^.Element = Pointer(1))
        and (List.Last^.Element = Pointer(6));

    Output := List;
end;

function MoveTestTwo(const Input: Pointer; var Output: Pointer): Boolean;
var List: TLinkedList;
begin
    List := TLinkedList(Input);
    List.Clear();

    List.Add(Pointer(1));
    List.Add(Pointer(5));
    List.MoveToLast(0);

    Result := (List.Get(0) = Pointer(5)) and (List.Last^.Element = Pointer(1));
    Output := List;
end;

function MoveTestMany(const Input: Pointer; var Output: Pointer): Boolean;
var I: Integer;
    List: TLinkedList;
begin
    List := TLinkedList(Input);

    List.AddFirst(Pointer(3));          // 3 5 1
    List.Add(Pointer(0));               // 3 5 1 0

    List.MoveToFirst(List.Count - 1);   // 0 3 5 1
    List.MoveToLast(2);                 // 0 3 1 5
    List.Insert(1, Pointer(2));         // 0 2 3 1 5
    List.Move(3, 1);                    // 0 1 2 3 5
    List.Insert(4, Pointer(4));         // 0 1 2 3 4 5

    Result := CheckCount(List);
    if not Result then Exit;
    for I := 0 to List.Count - 1 do
    begin
        Result := Pointer(I) = List.Get(I);
        if not Result then Break;
    end;

    Output := List;
end;

function ArrayTest(const Input: Pointer; var Output: Pointer): Boolean;
var I: Integer;
    List: TLinkedList;
    Pointers: TPointers;
begin
    List := TLinkedList(Input);
    List.Clear();
    FillList(TEST_ITEM_COUNT, List);
    Pointers := List.ToArray();
    Result := True;
    for I := Low(Pointers) to High(Pointers) do
        if I <> Cardinal(Pointers[I]) then
        begin
            Result := False;
            Break;
        end;
    Output := List;
end;

function ReverseTestOne(const Input: Pointer; var Output: Pointer): Boolean;
var V: Pointer;
    List: TLinkedList;
begin
    Result := False;
    List := TLinkedList(Input);
    List.Clear();
    V := Pointer(1);
    List.Add(V);
    List.Reverse();

    if not CheckCount(List) then Exit;
    Result := (List.Count = 1) and (List.First = List.Last)
        and (List.Last^.Element = V);

    Output := List;
end;

function ReverseTestTwo(const Input: Pointer; var Output: Pointer): Boolean;
var V1, V2: Pointer;
    List: TLinkedList;
    First, Last: PListItem;
begin
    Result := False;

    List := TLinkedList(Input);
    List.Clear();
    V1 := Pointer(1);
    V2 := Pointer(2);
    List.Add(V1);
    List.Add(V2);
    List.Reverse();

    if not CheckCount(List) then Exit;
    First := List.First;
    Last := List.Last;
    Result := (List.Count = 2)
        and (First^.Element = V2) and (Last^.Element = V1)
        and (First^.Prev = nil) and (First^.Next = Last)
        and (Last^.Prev = First) and (Last^.Next = nil);
end;

function ReverseTestMany(const Input: Pointer; var Output: Pointer): Boolean;
var V: Pointer;
    Item: PListItem;
    List: TLinkedList;
begin
    Result := False;
    List := TLinkedList(Input);
    List.Clear();
    FillList(TEST_ITEM_COUNT, List);
    List.Reverse();

    Item := List.First;
    V := Pointer(TEST_ITEM_COUNT - 1);
    while Item <> nil do
    begin
        if Item^.Element <> V then Exit;
        Dec(V);
        Item := Item^.Next;
    end;
    Result := CheckCount(List);
end;

function SwapTest(const Input: Pointer; var Output: Pointer): Boolean;
var I, K: Integer;
    List: TLinkedList;
begin
    Result := False;
    List := TLinkedList(Input);
    List.Clear();
    FillList(10, List);

    K := List.Count - 1;
    for I := 0 to K div 2 do
    begin
        List.Swap(I, K);
        Dec(K);
    end;

    Result := CheckCount(List);
    if not Result then Exit;
    K := 0;
    for I := List.Count - 1 downto 0 do
    begin
        Result := Pointer(I) = List.Get(K);
        Inc(K);
        if not Result then Break;
    end;

    Output := List;
end;

{------------------------------------------------------------------------------}
{ TListCase                                                                    }
{------------------------------------------------------------------------------}

constructor TListCase.Create(AName: String);
begin
    Inherited Create(AName);
    FItems := 100;
end;

constructor TListCase.Create(AName: String; Items: Integer);
begin
    Inherited Create(AName);
    FItems := Items;
end;

function TListCase.Run(): Boolean;
var I: Integer;
    List: TLinkedList;
    Step: PTestStep;
    Ignore: Pointer;
    Pass: Boolean;
begin
    Result := True;
    List := TLinkedList.Create();
    for I := 0 to ListCase.Count - 1 do
    begin
        Step := ListCase.Get(I);
        Pass := Step^.Execute(List, Ignore);
        WriteLn('Test: ', Step^.Name, ' - ', Pass);
        Result := Result and Pass;
        if not Result and Self.AbortOnFail then Break;
    end;
end;

INITIALIZATION                                                { INITIALIZATION }

    ListCase := TListCase.Create('LinkedList', 100);
    ListCase.Add('FillTest', FillTest);
    ListCase.Add('AddTest', AddTest);
    ListCase.Add('InsertTest', InsertTest);
    ListCase.Add('RemoveTest', RemoveTest);
    ListCase.Add('MoveTestTwo', MoveTestTwo);
    ListCase.Add('MoveTestMany', MoveTestMany);
    ListCase.Add('SwapTest', SwapTest);
    ListCase.Add('ArryaTest', ArrayTest);
    ListCase.Add('ReverseTest One', ReverseTestOne);
    ListCase.Add('ReverseTest Two', ReverseTestTwo);
    ListCase.Add('ReverseTest Many', ReverseTestMany);

FINALIZATION                                                    { FINALIZATION }

    ListCase.Clear();

END.                                                                     { END }

{------------------------------------------------------------------------------}
