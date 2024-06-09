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

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

END.                                                                     { END }

{------------------------------------------------------------------------------}
