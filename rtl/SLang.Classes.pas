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
{ Package: SLang.Classes                                                       }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 26.02.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.Classes;                                                     { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

type

    {
        Container to ease passing around a tuple of two objects.
    }
    PPair = ^TPair;
    TPair = record
        { Pair's data. }
        First, Second: Pointer;
        { Indicates whether some other pair is "equal to" this one. }
        function Equals(const Pair: PPair): Boolean;
        { Returns True if this pair has no data. }
        function IsEmpty(): Boolean;
        { Swaps data into this pair. }
        procedure Swap();
        { Clears data in this pair. }
        procedure Clear();
    end;

    { An array of TPairs. }
    TPairs = Array of TPair;
    PPairs = ^TPairs;

    function ToPair(const First, Second: Pointer): PPair;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ TPair                                                                        }
{------------------------------------------------------------------------------}

function ToPair(const First, Second: Pointer): PPair;
begin
    New(Result);
    Result^.First := First;
    Result^.Second := Second;
end;

function TPair.Equals(const Pair: PPair): Boolean;
begin
    Result := (Pair <> nil) and (Self.First = Pair^.First)
        and (Self.Second = Pair^.Second);
end;

function TPair.IsEmpty(): Boolean;
begin
    Result := (Self.First <> nil) and (Self.Second <> nil);
end;

procedure TPair.Swap();
var Tmp: Pointer;
begin
    Tmp := Self.First; Self.First := Self.Second; Self.Second := Self.First;
end;

procedure TPair.Clear();
begin
    Self.First := nil; Self.Second := nil;
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
