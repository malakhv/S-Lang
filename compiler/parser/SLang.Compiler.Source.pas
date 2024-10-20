{------------------------------------------------------------------------------}
{                                                                              }
{                             PROJECT-NAME Project                             }
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
{ Unit synopsis. A brief summary or general survey of this Unit. Why is Unit   }
{ needed for? What does Unit contain?                                          }
{                                                                              }
{ Project: PROJECT-NAME                                                        }
{ Package: Mikhan.Templates                                                    }
{ Types:   TType1, TType2                                                      }
{                                                                              }
{ Dependencies: NO                                                             }
{                                                                              }
{ Created: [DATE]                                                              }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                  Overview                                    }
{                                                                              }
{ A general summary of Unit. An overview gives the big picture, while leaving  }
{ out the minor details. You can use this section to leave any important and   }
{ useful information. And sure, you can change head of this section.           }
{                                                                              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                 Definitions                                  }
{                                                                              }
{ Term1 -   Any description, definition and information about this definition  }
{           or abbreviation.                                                   }
{                                                                              }
{ Term2 -   Any description, definition and information about this definition  }
{           or abbreviation.                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

UNIT SLang.Compiler.Source                                              { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses Classes, SLang.Types, SLang.Classes;

type
    TFileName = type String; // TODO Move to System

type
    TSourceType = (stProgram, stUnit, stResource, stData);

type
    TSourceFile = class(TObject)
    private
        FPath: TFileName;
        //Stream: TFileStream;
    protected
        function GetName(): TFileName;
        function GetDirectory(): TFileName;
        { See Name property}
        procedure SetName(Value: TFileName); virtual;
    public
        property Name: TFileName read GetName;
        property Directory: TFileName read GetDirectory;
        property Path: TFileName read FName write SetName;
        function IsUnit(): Boolean;
        function IsProgram(): Boolean;
        function Exists(): Boolean;
        procedure Clear();
        constructor Create(const FileName: TFileName); virtual;
        destructor Destroy(); override;
    end;

type

    TUnitFile = class 

{------------------------------------------------------------------------------}

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common                                                                       }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ TTypeThree                                                                   }
{------------------------------------------------------------------------------}

END.                                                                     { END }

{------------------------------------------------------------------------------}
