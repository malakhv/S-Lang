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
{ This Unit includes additional data types' definitions and common routines to }
{ working with it.                                                             }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: SLang                                                               }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 09.06.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.Types;                                                       { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

{ Some Arrays }
type

    { An array of bytes. }
    TBytes = Array of Byte;
    PBytes = ^TBytes;

    { An array of integers. }
    TIntegers = Array of Integer;
    PIntegers = ^TIntegers;

    { An array of pointers. }
    TPointers = Array of Pointer;
    PPointers = ^TPointers;

{ Standard data types as an object. }
type

    { The object of Boolean. }
    TBoolObj = class (TObject)
    private
        FValue: Boolean;
    public
        { The real "primitive" (standard, in Pascal terms) value inside this
          object. }
        property Value: Boolean read FValue write FValue;
        { Indicates whether some TBoolObj instance is "equal to" this one. }
        function Equals(BoolObj: TBoolObj): Boolean;
        { Makes a TBoolObj instance from Boolean value. }
        class function From(Bool: Boolean): TBoolObj; overload;
        { Makes a TBoolObj instance from Integer value. }
        class function From(Int: Integer): TBoolObj; overload;
    end;

    { The object of Byte. }
    TByteObj = class (TObject)
    private
        FValue: Byte;
    public
        { The real "primitive" (standard, in Pascal terms) value inside this
          object. }
        property Value: Byte read FValue write FValue;
        { Indicates whether some TByteObj instance is "equal to" this one. }
        function Equals(Obj: TByteObj): Boolean;
        { Makes a TByteObj instance from Integer value. }
        class function From(Val: Byte): TByteObj; overload;
        { Makes a TByteObj instance from Boolean value. }
        class function From(Val: Boolean): TByteObj; overload;
    end;

    { The object of Integer. }
    TIntObj = class (TObject)
    private
        FValue: Integer;
    public
        { The real "primitive" (standard, in Pascal terms) value inside this
          object. }
        property Value: Integer read FValue write FValue;
        { Indicates whether some TIntObj instance is "equal to" this one. }
        function Equals(IntObj: TIntObj): Boolean;
        {function Compare(IntObj: TIntObj): Byte;}
        { Makes a TIntObj instance from Integer value. }
        class function From(Int: Integer): TIntObj; overload;
        { Makes a TIntObj instance from Boolean value. }
        class function From(Bool: Boolean): TIntObj; overload;
    end;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TBoolObj                                                                     }
{------------------------------------------------------------------------------}

class function TBoolObj.From(Bool: Boolean): TBoolObj;
begin
    Result := TBoolObj.Create(); Result.FValue := Bool;
end;

class function TBoolObj.From(Int: Integer): TBoolObj;
begin
    Result := TBoolObj.From(Boolean(Int));
end;

function TBoolObj.Equals(BoolObj: TBoolObj): Boolean;
begin
    Result := (BoolObj <> nil) and (Self.FValue = BoolObj.FValue);
end;

{------------------------------------------------------------------------------}
{ TByteObj                                                                     }
{------------------------------------------------------------------------------}

class function TByteObj.From(Val: Byte): TByteObj;
begin
    Result := TByteObj.Create(); Result.FValue := Val;
end;

class function TByteObj.From(Val: Boolean): TByteObj;
begin
    Result := TByteObj.From(Ord(Val));
end;

function TByteObj.Equals(Obj: TByteObj): Boolean;
begin
    Result := (Obj <> nil) and (Self.FValue = Obj.FValue);
end;

{------------------------------------------------------------------------------}
{ TIntObj                                                                      }
{------------------------------------------------------------------------------}

class function TIntObj.From(Int: Integer): TIntObj;
begin
    Result := TIntObj.Create(); Result.FValue := Int;
end;

class function TIntObj.From(Bool: Boolean): TIntObj;
begin
    Result := TIntObj.From(Ord(Bool));
end;

function TIntObj.Equals(IntObj: TIntObj): Boolean;
begin
    Result := (IntObj <> nil) and (Self.FValue = IntObj.FValue);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
