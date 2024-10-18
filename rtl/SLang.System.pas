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
    VCLVersion = '0.0.1'

    { The version of S-Lang compiler. }
    CompilerVersion = '0.0.1';

{ Aliases for classical data types. }
type

    { Unsigned Double Word. }
    DWord = LongWord;

    { Unsigned Quad Word. }
    QWord = UInt64;

    {  }
    Float = Real;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

END.                                                                     { END }

{------------------------------------------------------------------------------}
