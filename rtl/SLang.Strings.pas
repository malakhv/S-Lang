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
{ The Unit contains stuff and methods to working with strings.                 }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: SLang                                                               }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 15.08.2022                                                          }
{ Authors: Mikhail.Malakhov                                                    }
{------------------------------------------------------------------------------}

UNIT SLang.Strings;                                                     { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

{
    Some character constants
}
const

    { The empty string. }
    EMPTY = '';

    { The nil character. }
    CHAR_NIL = #0;

    { The space character. }
    CHAR_SPACE = ' ';

    { The tab character. }
    CHAR_TAB = #9;

    { The dot character. }
    CHAR_DOT = '.';

    { The comma character. }
    CHAR_COMMA = ',';

    { The colon character. }
    CHAR_COLON = ':';

    { The semicolon character. }
    CHAR_SEMICOLON = ';';

    { The less-than sign. }
    CHAR_LESS_THAN = '<';

    { The equal sign. }
    CHAR_EQUAL = '=';

    { The greater-than sign. }
    CHAR_GREATER_THAN = '>';

    { The number sign. }
    CHAR_NUMBER = '#';

    { The question mark. }
    CHAR_QUESTION_MARK = '?';

    { The at sign. }
    CHAR_AT = '@';

    { The asterisk. }
    CHAR_ASTERISK = '*';

    { The special char: end of the line. }
    CHAR_NEW_LINE = '\n';

    { The special char: empty line. }
    CHAR_EMPTY_LINE = '\n\n';

    { The special char: slash. }
    CHAR_SLASH = '/';

    { The special char: back slash. }
    CHAR_BACK_SLASH = '\';

    { The special char: vertical slash. }
    CHAR_VERT_SLASH = '|';

    { The tilde char. }
    CHAR_TILDE = '~';

    { The section. }
    CHAR_SECTION = '§';

{ Converts an array of bytes to string. }
function BytesToStr(const Source: Array of Byte): String;

{ Repeats source string the specified number of times. }
function RepeatStr(const Source: String; Count: Integer): String;

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common                                                                       }
{------------------------------------------------------------------------------}

function BytesToStr(const Source: Array of Byte): String;
var I: Integer;
begin
    Result := EMPTY;
    for I := Low(Source) to High(Source) do
        Result := Result + Char(Source[I]);
end;

function RepeatStr(const Source: String; Count: Integer): String;
var I, L: Integer;
begin
    Result := EMPTY;
    if Count <= 0 then Exit;
    L := Length(Source);
    SetLength(Result, L * Count);
    for I := 0 to Count - 1 do
        Move(Source[1], Result[L * I + 1], L);
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
