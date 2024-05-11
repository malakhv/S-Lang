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
{ This Unit includes test cases for RTL Tree data structures.                  }
{                                                                              }
{ Project: S-Lang                                                              }
{ Package: S-Lang.Testing                                                      }
{ Types:   Not Applicable                                                      }
{                                                                              }
{ Dependencies: SLang.Classes, SLang.Tree, Testing,                            }
{                                                                              }
{ Created: 25.03.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT TreeTest;                                                          { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.System, SLang.Tree, Testing;

type
    TTreeCase = class (TTestCase)
    private
        FItems: Integer;
    public
        function Run(): Boolean; override;
        constructor Create(AName: String); override; overload;
        constructor Create(AName: String; Items: Integer); overload; virtual;
    end;

var TreeCase: TTreeCase;

IMPLEMENTATION                                                { IMPLEMENTATION }

uses SLang.Classes;

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

const TEST_ITEM_COUNT = 10000;

procedure DumpNode(Node: PTreeNode);
var I, D: Integer;
begin
    WriteLn();
    if Node = nil then WriteLn('NIL');
    D := Node^.Depth;
    Write('':D*4); WriteLn('Node: ', Integer(Node));
    Write('':D*4); WriteLn('Parent: ', Integer(Node^.Parent));
    Write('':D*4); WriteLn('Depth: ', D);
    Write('':D*4); WriteLn('Height: ', Node^.Height);
    Write('':D*4); WriteLn('ChildCount: ', Integer(Node^.ChildCount));
    Write('':D*4); WriteLn('Size: ', Integer(Node^.Size));
    Write('':D*4); WriteLn('Element: ', Integer(Node^.Element));
    for I := 0 to Node^.ChildCount - 1 do DumpNode(Node^[i]);
end;

procedure FillNode(var Node: PTreeNode);
begin
    Node^.Add(Pointer(1));
    Node^.Add(Pointer(3));
    Node^.Add(Pointer(2));
    Node^.Add(Pointer(4));
    Node^[2]^.Add(Pointer(11));
    Node^[2]^.Add(Pointer(13));
    Node^[2]^.Add(Pointer(12));
    Node^[2]^[1]^.Add(Pointer(111));
    Node^[2]^[1]^.Add(Pointer(113));
    Node^[2]^[1]^.Add(Pointer(112));
end;

{------------------------------------------------------------------------------}
{ Tests                                                                        }
{------------------------------------------------------------------------------}

function FillTest(const Input: Pointer; var Output: Pointer): Boolean;
var Node: PTreeNode;
begin
    Node := PTreeNode(Input);
    Node^.Clear();
    FillNode(Node);
    DumpNode(Node);
    Output := Node;
end;

{------------------------------------------------------------------------------}
{ TTreeCase                                                                    }
{------------------------------------------------------------------------------}

constructor TTreeCase.Create(AName: String);
begin
    Inherited Create(AName);
    FItems := 100;
end;

constructor TTreeCase.Create(AName: String; Items: Integer);
begin
    Inherited Create(AName);
    FItems := Items;
end;

function TTreeCase.Run(): Boolean;
var I: Integer;
    Node: PTreeNode;
    Step: PTestStep;
    Ignore: Pointer;
    Pass: Boolean;
begin
    Result := True;
    Node := MakeRootNode();
    Node^.Element := 0;
    for I := 0 to TreeCase.Count - 1 do
    begin
        Step := TreeCase.Get(I);
        Pass := Step^.Execute(Node, Ignore);
        WriteLn('Test: ', Step^.Name, ' - ', Pass);
        Result := Result and Pass;
        if not Result and Self.AbortOnFail then Break;
    end;
end;

INITIALIZATION                                                { INITIALIZATION }

    TreeCase := TTreeCase.Create('S-Lang RTL Tree', 100);
    TreeCase.Add('FillTest', FillTest);

FINALIZATION                                                    { FINALIZATION }

    TreeCase.Clear();

END.                                                                     { END }

{------------------------------------------------------------------------------}
