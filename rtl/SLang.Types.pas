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
{ Dependencies: SLang.System                                                   }
{                                                                              }
{ Created: 09.06.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.Types;                                                       { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

USES SLang.System;

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

{
    Simple data types as a record.
}
type

    { Record of Word. }
    WordRec = packed record
    case Integer of
        0: (Value: Word);
        1: (Lo, Hi: Byte);
        2: (Bytes: Array [0..SizeOf(Word) - 1] of Byte);
    end;
    PWordRec = ^WordRec;

    { Record of DWord. }
    DWordRec = packed record
    case Integer of
        0: (Value: DWord);
        1: (Lo, Hi: Word);
        2: (Bytes: Array [0..SizeOf(DWord) - 1] of Byte);
    end;
    PDWordRec = ^DWordRec;

    { Record of QWord. }
    QWordRec = packed record
    case Integer of
        0: (Value: QWord);
        1: (Lo, Hi: DWord);
        2: (Bytes: Array [0..SizeOf(QWord) - 1] of Byte);
    end;
    PQWordRec = ^QWordRec;

{
    Simple data types as an object.
}
// TODO Do we want to move this to Number unit?
const

    { True as string. }
    STR_TRUE = 'true';
    { False as string. }
    STR_FALSE = 'false';

type

    { The abstract number as an object. }
    TNumber = class abstract (TObject)
    public
        { Indicates whether some TNumber instance is "equal to" this one. }
        function Equals(Number: TNumber): Boolean; virtual; abstract;
        { Returns the value of this object as a Boolean. }
        function ToBoolean(): Boolean; virtual; abstract;
        { Returns the value of this object as a Byte. }
        function ToByte(): Byte; virtual; abstract;
        { Returns the value of this object as an Integer. }
        function ToInteget(): Integer; virtual; abstract;
        { Returns the value of this object as a Float. }
        function ToFloat(): Float; virtual; abstract;
    end;

    { The object of Boolean. }
    TBoolObj = class (TObject)
    private
        FValue: Boolean;
    public
        { The real "primitive" (standard, in Pascal terms) value inside this
          object. }
        property Value: Boolean read FValue write FValue;
        { Indicates whether some TBoolObj instance is "equal to" this one. }
        function Equals(Obj: TBoolObj): Boolean; virtual;
        { Returns a string representation of the value in this object. }
        function ToString(): String; override;
        { Construct a new TBoolObj instance with default (False) value. }
        constructor Create(); overload; virtual;
        { Construct a new TBoolObj instance from specified value. }
        constructor From(Val: Boolean); overload; virtual;
        { Construct a new TBoolObj instance from specified value. }
        constructor From(Val: Integer); overload; virtual;
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
        function Equals(Obj: TByteObj): Boolean; virtual;
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
        function Equals(Obj: TIntObj): Boolean; virtual;
        { Makes a TIntObj instance from Integer value. }
        class function From(Val: Integer): TIntObj; overload;
        { Makes a TIntObj instance from Boolean value. }
        class function From(Val: Boolean): TIntObj; overload;
    end;

    { The object of Boolean. }
    TFloatObj = class (TObject)
    private
        FValue: Float;
    public
        { The real "primitive" (standard, in Pascal terms) value inside this
          object. }
        property Value: Float read FValue write FValue;
        { Indicates whether some TBoolObj instance is "equal to" this one. }
        function Equals(Obj: TFloatObj): Boolean; virtual;
        { Construct a new TFloatObj instance with default (False) value. }
        constructor Create(); overload; virtual;
        { Construct a new TFloatObj instance from specified value. }
        constructor From(Val: Float); overload; virtual;
        { Construct a new TFloatObj instance from specified value. }
        constructor From(Val: Integer); overload; virtual;
        { Construct a new TFloatObj instance from specified value. }
        constructor From(Val: Boolean); overload; virtual;
    end;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TBoolObj                                                                     }
{------------------------------------------------------------------------------}

constructor TBoolObj.Create();
begin
    Self.From(False);
end;

constructor TBoolObj.From(Val: Boolean);
begin
    inherited Create(); Self.FValue := Val;
end;

constructor TBoolObj.From(Val: Integer);
begin
    Self.From(Boolean(Val));
end;

function TBoolObj.Equals(Obj: TBoolObj): Boolean;
begin
    Result := (Obj <> nil) and (Self.FValue = Obj.FValue);
end;

function TBoolObj.ToString(): String;
begin
    if Self.FValue then Result := STR_TRUE else Result := STR_FALSE;
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

class function TIntObj.From(Val: Integer): TIntObj;
begin
    Result := TIntObj.Create(); Result.FValue := Val;
end;

class function TIntObj.From(Val: Boolean): TIntObj;
begin
    Result := TIntObj.From(Ord(Val));
end;

function TIntObj.Equals(Obj: TIntObj): Boolean;
begin
    Result := (Obj <> nil) and (Self.FValue = Obj.FValue);
end;


{------------------------------------------------------------------------------}
{ TFloatObj                                                                    }
{------------------------------------------------------------------------------}

constructor TFloatObj.Create();
begin
    Self.From(False);
end;

constructor TFloatObj.From(Val: Float);
begin
    inherited Create(); Self.FValue := Val;
end;

constructor TFloatObj.From(Val: Integer);
begin
    inherited Create(); Self.FValue := Val;
end;

constructor TFloatObj.From(Val: Boolean);
begin
    Self.From(Ord(Val));
end;

function TFloatObj.Equals(Obj: TFloatObj): Boolean;
begin
    Result := (Obj <> nil) and (Self.FValue = Obj.FValue);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
