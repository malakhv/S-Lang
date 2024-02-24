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
{ Package: Mikhan.S-Lang                                                       }
{ Types:   TBD                                                                 }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 22.02.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT Types;                                                             { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

{
    The kinds of data types.
}
type

    TTypeKind = (tkUnknown, tkByte, tkWord, tkInt, tkFloat, tkChar, tkString,
        tkEnum, tkSet, tkArray, tkRecord, tkInterface, tkClass, tkMethod,
        tkPointer);

    TFloatKind = (fkSingle, fkDouble);
    
    TMethodKind = (mkProcedure, mkFunction, mkConstructor, mkDestructor,
        mkClassProcedure, mkClassFunction);

type

    TTypeInfo = record
        Kind: TTypeKind;
        function GetName(): String;
        function IsNumeric(): Boolean;
        function IsSimple(): Boolean;
        function IsPointer(): Boolean;
        function ToString(): String;
    end;
    PTypeInfo = ^TTypeInfo;

function MakeTypeInfo(AName: String): PTypeInfo;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TTypeInfo                                                                    }
{------------------------------------------------------------------------------}

const
    TK_NAME_BYTE    = 'Byte';
    TK_NAME_WORD    = 'Word';
    TK_NAME_INT     = 'Integer';
    TK_NAME_FLOAT   = 'Float';

    TK_NAME_CHAR    = 'Char';
    TK_NAME_STRING  = 'String';
    
    TK_NAME_ENUM    = 'Enum';
    TK_NAME_SET     = 'Set';
    TK_NAME_ARRAY   = 'Array';
    TK_NAME_RECORD  = 'Record';
    
    TK_NAME_POINTER = 'Pointer';
    
    TK_NAME_CLASS       = 'Class';
    TK_NAME_INTERFACE   = 'Interface';
    TK_NAME_METHOD      = 'Method';
    
    TK_NAME_UNKNOWN     = 'Unknown';

    TYPE_KIND_NAMES: Array [TTypeKind] of String = ( TK_NAME_UNKNOWN,
        TK_NAME_BYTE, TK_NAME_WORD, TK_NAME_INT, TK_NAME_FLOAT, TK_NAME_CHAR,
        TK_NAME_STRING, TK_NAME_ENUM, TK_NAME_SET, TK_NAME_ARRAY,
        TK_NAME_RECORD, TK_NAME_INTERFACE, TK_NAME_CLASS, TK_NAME_METHOD,
        TK_NAME_POINTER
    );

function TypeKindToStr(AKind: TTypeKind): String;
begin
    Result := TYPE_KIND_NAMES[AKind];
end;

function StrToTypeKind(AValue: String): TTypeKind;
var I: TTypeKind;
begin
    for I := Low(TYPE_KIND_NAMES) to High(TYPE_KIND_NAMES) do
        if TYPE_KIND_NAMES[I] = AValue then
        begin
            Result := I; Exit;
        end;
    Result := tkUnknown;
end;

function TTypeInfo.GetName(): String;
begin
    Result := TypeKindToStr(Self.Kind);
end;

function TTypeInfo.IsNumeric(): Boolean;
begin
    Result := (Self.Kind > tkUnknown) and (Self.Kind <= tkFloat);
end;

function TTypeInfo.IsSimple(): Boolean;
begin
    Result := (Self.Kind > tkUnknown) and (Self.Kind <= tkChar);
end;

function TTypeInfo.IsPointer(): Boolean;
begin
    Result := Self.Kind = tkPointer;
end;

function TTypeInfo.ToString(): String;
begin
    Result := Self.GetName();
end;

{------------------------------------------------------------------------------}
{ Unit Stuff                                                                   }
{------------------------------------------------------------------------------}

function MakeTypeInfo(AName: String): PTypeInfo;
begin
    New(Result);
    Result^.Kind := StrToTypeKind(AName);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
