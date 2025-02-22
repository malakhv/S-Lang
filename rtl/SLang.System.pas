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
{ This Unit includes common definitions and routines for all programs, and its }
{ will use by default for all programs.                                        }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: SLang                                                               }
{ Unit Level: 0                                                                }
{                                                                              }
{ Dependencies: A Unit with level 0 must have no dependencies.                 }
{                                                                              }
{ Created: 07.03.2024                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT SLang.System;                                                      { UNIT }

{------------------------------------------------------------------------------}
{                                 System Unit                                  }
{                                                                              }
{ The System unit will be include as a first dependecy for all programs, by    }
{ default.                                                                     }
{                                                                              }
{ Predefined constants, types, procedures, and functions (such as True, False, }
{ Integer, or Writeln) do not have actual declarations. Instead they are built }
{ into the compiler and are treated as if they were declared at the beginning  }
{ of the System unit.                                                          }
{------------------------------------------------------------------------------}

{$ASMMODE INTEL}
{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

{ S-Lang version }
const

    { The version of S-Lang RTL. }
    RTLVersion = '0.0.1';

    { The version of S-Lang VCL. }
    VCLVersion = '0.0.1';

    { The version of S-Lang compiler. }
    CompilerVersion = '0.0.1';

{------------------------------------------------------------------------------}
{                               Simple Data Types                              }
{                                                                              }
{ A type is essentially a name for a kind of data. When you declare a variable }
{ you must specify its type, which determines the set of values the variable   }
{ can hold and the operations that can be performed on it. Every expression    }
{ returns data of a particular type, as does every function. Most functions    }
{ and procedures require parameters of specific types.                         }
{                                                                              }
{ Platform-independent integer types (signed):                                 }
{  +----------+-----------------+-------------------------------------------+  }
{  |   Type   |     Format      |              Range                        |  } 
{  +----------+-----------------+-------------------------------------------+  }
{  | ShortInt | Signed 8-bit    | -128..127                                 |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | SmallInt | Signed 16-bit   | -32768..32767                             |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | Integer  | Signed 32-bit   | -2147483648..2147483647                   |  } 
{  +----------+-----------------+-------------------------------------------+  }
{  | LongInt  | Signed 64-bit   | -9223372036854775808..9223372036854775807 |  }
{  +----------+-----------------+-------------------------------------------+  }
{                                                                              }
{ Platform-independent integer types (unsigned):                               }
{  +----------+-----------------+-------------------------------------------+  }
{  |   Type   |     Format      |              Range                        |  } 
{  +----------+-----------------+-------------------------------------------+  }
{  | Byte     | Unsigned 8-bit  | 0..255                                    |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | Word     | Unsigned 16-bit | 0..65535                                  |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | DWord    | Unsigned 32-bit | 0..4294967295                             |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | QWord    | Unsigned 64-bit | 0..18446744073709551615                   |  }
{  +----------+-----------------+-------------------------------------------+  }
{  | BigInt   | Unsigned 64-bit | 0..18446744073709551615                   |  }
{  +----------+-----------------+-------------------------------------------+  }
{                                                                              }
{ Platform-dependent integer types:                                            }
{  +------------+--------------+-----------------+--------------------------+  }
{  |    Type    |   Platform   |     Format      |              Alias       |  }
{  +------------+--------------+-----------------+--------------------------+  }
{  |            | 32-bit       | Signed 32-bit   | Integer                  |  }
{  | NativeInt  +--------------+--------------------------------------------+  }
{  |            | 64-bit       | Signed 64-bit   | LongInt                  |  }
{  +------------+--------------+-----------------+--------------------------+  }
{  |            | 32-bit       | Unsigned 32-bit | DWord                    |  }
{  | NativeWord +--------------+-----------------+--------------------------+  }
{  |            | 64-bit       | Unsigned 64-bit | QWord                    |  }
{  +------------+--------------+-----------------+--------------------------+  }
{                                                                              }
{------------------------------------------------------------------------------}

// TODO When will the compiler be able to compile itself, need to remove
//      definitions of DWord, QWord and LongInt, because these types should be
//      predefined types.

// See https://wiki.freepascal.org/Data_type

{
    Platform-independent integer types (signed). Byte and Word are
    predefined (or built-in) types.
}
type

    { Signed 64-bit integer. }
    LongInt = Int64;

    { Pointer to ShortInt. }
    PShortInt = ^ShortInt;
    { Pointer to SmallInt. }
    PSmallInt = ^SmallInt;
    { Pointer to Integer. }
    PInteger = ^Integer;
    { Pointer to LongInt. }
    PLongInt = ^LongInt;

{
    Platform-independent integer types (unsigned). Byte and Word are
    predefined (or built-in) types.
}
type

    { Unsigned Double Word. }
    DWord = LongWord;
    { Unsigned Quad Word. }
    QWord = UInt64;
    { Unsigned big integer. It's just an alias for QWord. }
    BigInt = QWord;

    { Pointer to Byte. }
    PByte = ^Byte;
    { Pointer to Word. }
    PWord = ^Word;
    { Pointer to DWord. }
    PDWord = ^DWord;
    { Pointer to QWord. }
    PQWord = ^QWord;

type

    { Right now, we are using data type from external compiler, but it
      should be built-in type. }
    Float = Real;

{------------------------------------------------------------------------------}
{                                  Endianness                                  }
{                                                                              }
{ Endianness means the order in which the bytes of a value larger than one     }
{ byte are stored in memory. This affects, e.g., integer values and pointers   }
{ while, e.g., arrays of single-byte characters are not affected. Endianness   }
{ depends on the hardware, especially the CPU.                                 }
{------------------------------------------------------------------------------}

{ Returns True for big-endian hardware platform. }
function IsBigEndian(): Boolean;

{ Returns True for little-endian hardware platform. }
function IsLittleEndian(): Boolean;

{ Swaps endianness of the Word value. }
function SwapEndian(Value: Word): Word; overload;

{ Swaps endianness of the DWord value. }
function SwapEndian(Value: DWord): DWord; overload;

{ Swaps endianness of the QWord value. }
function SwapEndian(Value: QWord): QWord; overload;

{------------------------------------------------------------------------------}
{                                Date and Time                                 }
{                                                                              }
{------------------------------------------------------------------------------}

type

    { Base type to work with date and time. }
    TDateTime = type Double;
    PDateTime = ^TDateTime;

    { The date. It represents a special type of TDateTime value that has
      no decimal part. }
    TDate = type TDateTime;

    { The time. It represents a special type of TDateTime value that has only
      a fractional part (and no integral part). }
    TTime = type TDateTime;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Endianness                                                                   }
{------------------------------------------------------------------------------}

function IsBigEndian(): Boolean;
var W: Word;
begin
    W := 1; Result := PByte(@W)^ = 0;
end;

function IsLittleEndian(): Boolean;
var W: Word;
begin
    W := 256; Result := PByte(@W)^ = 0;
end;

function SwapEndian(Value: Word): Word; overload;
begin
    Result := (Value shr 8) or (Value shl 8);
end;

function SwapEndian(Value: DWord): DWord; overload;
asm
    bswap eax
end;

function SwapEndian(Value: QWord): QWord; overload;
begin
    Result := Value;
end;

{------------------------------------------------------------------------------}

INITIALIZATION                                                { INITIALIZATION }



END.                                                                     { END }

{------------------------------------------------------------------------------}
