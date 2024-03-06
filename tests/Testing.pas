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

UNIT Testing;                                                           { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.List;

const
    PASS = 'PASS';
    FAIL = 'FAIL';

type

    { A test action with boolean (pass or not) result. }
    TTestAction = function (const Input: Pointer;
        var Output: Pointer): Boolean;
    PTestAction = TTestAction;

    { A one test step with name and one action. }
    TTestStep = record
        Name: String;
        Action: TTestAction;
        function Execute(const Input: Pointer; var Output: Pointer): Boolean;
    end;
    PTestStep = ^TTestStep;

    { The one test case with several test steps. }
    TTestCase = class(TObject)
    private
        FName: String;
        FSteps: TLinkedList;
        FAbortOnFail: Boolean;
    protected
        function GetCount(): Integer;
    public
        property Count: Integer read GetCount;
        function Add(Name: String; const Action: PTestAction): PTestStep;
        function Get(Index: Integer): PTestStep;
        function Remove(Index: Integer): Boolean;
        procedure Run();
        procedure Clear();
        constructor Create(AName: String); virtual;
        destructor Destroy; override;
    end;

    { The set of test cases. }
    TTestBucket = class(TObject)

    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ TTestStep                                                                    }
{------------------------------------------------------------------------------}

function TTestStep.Execute(const Input: Pointer; var Output: Pointer): Boolean;
begin
    if Assigned(Self.Action) then
        Result := Self.Action(Input, Output)
    else
        Result := False;
end;

{------------------------------------------------------------------------------}
{ TTestCase                                                                    }
{------------------------------------------------------------------------------}

constructor TTestCase.Create(AName: String);
begin
    Inherited Create();
    FSteps := TLinkedList.Create();
    Self.FName := AName;
end;

destructor TTestCase.Destroy;
begin
    Self.Clear(); Inherited;
end;

function TTestCase.GetCount(): Integer;
begin
    Result := FSteps.Count;
end;

function TTestCase.Add(Name: String; const Action: PTestAction): PTestStep;
begin
    New(Result);
    Result^.Name := Name;
    Result^.Action := Action;
    FSteps.Add(Result);
end;

function TTestCase.Get(Index: Integer): PTestStep;
begin
    Result := PTestStep(FSteps.ValueOf(Index));
end;

function TTestCase.Remove(Index: Integer): Boolean;
begin
    Result := False;
end;

procedure TTestCase.Run();
begin

end;

procedure TTestCase.Clear();
begin
    if FSteps <> nil then FSteps.Clear();
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
