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
{  |            | 64-bit       | Unsigned 32-bit | QWord                    |  }
{  +------------+--------------+-----------------+--------------------------+  }
{                                                                              }
{------------------------------------------------------------------------------}

type

    { Unsigned Double Word. }
    DWord = LongWord;

    { Unsigned Quad Word. }
    QWord = UInt64;

    { Right now, we are using data type from external compiler, but it
        should be built-in type. }
    Float = Double;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

END.                                                                     { END }

{------------------------------------------------------------------------------}
