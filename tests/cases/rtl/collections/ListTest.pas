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
{ Package: S-Lang.Testing                                                      }
{ Types:   TBD                                                                 }
{                                                                              }
{ Dependencies: List                                                           }
{                                                                              }
{ Created: 25.02.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT ListTest;                                                           { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses List, Testing;

{ Executes all existing test cases. }
procedure RunAll();

IMPLEMENTATION                                                { IMPLEMENTATION }

uses Classes;

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

const TEST_ITEM_COUNT = 10000;

var
    ListCase: TTestCase;

{------------------------------------------------------------------------------}
{ Tests                                                                        }
{------------------------------------------------------------------------------}

procedure FillList(Count: Integer; var L: TLinkedList);
var I: Integer;
begin
    for I := 0 to Count - 1 do L.Add(Pointer(I));
end;

function FillTest(const Input: Pointer; var Output: Pointer): Boolean;
var Count: Integer;
    Item: PListItem;
    TestList: TLinkedList;
begin
    TestList := TLinkedList(Input);
    TestList.Clear();
    Count := 0;
    FillList(TEST_ITEM_COUNT, TestList);
    Item := TestList.First;
    repeat
        Inc(Count);
        Item := Item^.Next;
    until Item = nil;
    Result := (Count = TEST_ITEM_COUNT) and (Count = TestList.Count);
    Output := Input;
end;

function AddTest(const Input: Pointer; var Output: Pointer): Boolean;
var Item: PListItem;
    TestList: TLinkedList;
begin
    Result := False;
    Output := Input;
end;

function InsertTest(const Input: Pointer; var Output: Pointer): Boolean;
var L: TLinkedList;
begin
    Result := False;
    Output := Input;
end;

function RemoveTest(const Input: Pointer; var Output: Pointer): Boolean;
var L: TLinkedList;
begin
    Result := False;
    Output := Input;
end;

function MoveTest(const Input: Pointer; var Output: Pointer): Boolean;
var L: TLinkedList;
begin
    Result := False;
    Output := Input;
end;

function ArrayTest(const Input: Pointer; var Output: Pointer): Boolean;
var I: Integer;
    TestList: TLinkedList;
    Pointers: TPointers;
begin
    TestList := TLinkedList(Input);
    TestList.Clear();
    FillList(TEST_ITEM_COUNT, TestList);
    Pointers := TestList.ToArray();
    Result := True;
    for I := Low(Pointers) to High(Pointers) do
        if I <> Cardinal(Pointers[I]) then
        begin
            Result := False;
            Break;
        end;
    Output := Input;
end;

{------------------------------------------------------------------------------}
{ External test actions                                                        }
{------------------------------------------------------------------------------}

procedure RunAll();
var I: Integer;
    TestList: TLinkedList;
    Step: PTestStep;
    Pass: Boolean;
    Output: Pointer;
begin
    TestList := TLinkedList.Create();
    for I := 0 to ListCase.Count - 1 do
    begin
        Step := ListCase.Get(I);
        WriteLn('Test: ', Step^.Name, ' - ', Step^.Execute(TestList, Output));
    end;
end;

INITIALIZATION
    ListCase := TTestCase.Create('LinkedList');
    ListCase.Add('FillTest', FillTest);
    ListCase.Add('AddTest', AddTest);
    ListCase.Add('InsertTest', InsertTest);
    ListCase.Add('RemoveTest', RemoveTest);
    ListCase.Add('MoveTest', MoveTest);
    ListCase.Add('ArryaTest', ArrayTest);

FINALIZATION
    ListCase.Clear();

END.                                                                     { END }

{------------------------------------------------------------------------------}
