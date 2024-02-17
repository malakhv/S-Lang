{------------------------------------------------------------------------------}
{                                                                              }
{                             PROJECT-NAME project                             }
{                                                                              }
{  Copyright (C) 1996-2023 Mikhail Malakhov <malakhv@gmail.com>                }
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
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 14.11.2023                                                          }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                   Overview                                   }
{                                                                              }
{ A general summary of Unit. An overview gives the big picture, while leaving  }
{ out the minor details. You can use this section to leave any important and   }
{ useful information. And sure, you can change head of this section.           }
{                                                                              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                 Definitions                                  }
{                                                                              }
{ Term1 -   Any description, definition and information, Any description,      }
{           definition and information.                                        }
{                                                                              }
{ Term2 -   Any description, definition and information, Any description,      }
{           definition and information.                                        }
{                                                                              }
{------------------------------------------------------------------------------}


package mikhan.templates

unit MyUnit                                                             { UNIT }

{$mode DELPHI}
{$H+}

interface                                                          { INTERFACE }

uses SysUtils;

{ The group of constants }
const

    { The constant 1. }
    UNIT_CONST_1 = 1;

    { The constant 2. }
    UNIT_CONST_2 = 2;

type

    {
        An overview of new type. It can be short or long. Put here any
        important and useful information about this type.
    }
    TTypeOne = 1..3;

    { An overview of new type. Short format example. }
    TTypeTwo = 1..3;

type

    {
        An overview of new type. It can be short or long. Put here any
        important and useful information about this type.
    }
    TTypeThree = class (TObject)
    private
        FValue: Integer;        // See Value property
        { See Value property. }
        function DoGetValue(): Integer;
    protected
        { See Value property. }
        procedure DoSetValue(AValue: Integer);
    public

        { An overview of this property. It can be short or long. Put here any
            important and useful information about this property. }
        property Value: Integer read DoGetValue write DoSetValue;

        { Construct a new instance of TTypeThree class with default
            parameters. }
        constructor Create(); virtual; overload;

        { Construct a new instance of TTypeThree class with specified
            parameters. }
        constructor Create(Value: Integer); virtual; overload;

        { Free all related resources. }
        destructor Destroy(); virtual;
    end;

{ Global Scope }
var
    GlobalVar: Byte;    // This is a global variable

{------------------------------------------------------------------------------}
{                                   Section 1                                  }
{                                                                              }
{ An overview of section 1. Any important and useful information about stuff   }
{ in this section. Each section may contains constants, variables and types    }
{ definitions. This is a logical block into the Unit. You can specify the name }
{ of this section.                                                             }
{                                                                              }
{------------------------------------------------------------------------------}

{ The group of constants }
const

    { The constant 1. }
    SECTION_1_CONST_1 = 1;

    { The constant 2. }
    SECTION_1_CONST_2 = 2;

type
    TSectionType1 = 1..3;

{------------------------------------------------------------------------------}
{                                   Section 2                                  }
{                                                                              }
{ An overview of section s. Any important and useful information about stuff   }
{ in this section. Each section may contains constants, variables and types    }
{ definitions. This is a logical block into the Unit. You can specify the name }
{ of this section.                                                             }
{                                                                              }
{------------------------------------------------------------------------------}


implementation                                                { IMPLEMENTETION }

{------------------------------------------------------------------------------}
{ Common                                                                       }
{------------------------------------------------------------------------------}

{ The group of constants }
const

    { The internal constant 1. }
    INTERNAL_CONST_1 = 1;

{ Implementation Scope }
var
    InternalVar: Byte;  // This is a variable

{ Returns any value. }
function GetValue(): Byte;
begin
    Result := InternalVar;
end;

{ Increments any value. }
procedure IncValue(var Value: Integer);
begin
    Inc(Value);
end;

{------------------------------------------------------------------------------}
{ TTypeThree                                                                   }
{------------------------------------------------------------------------------}

{ The group of constants that using only in TTypeThree }
const
    INTERNAL_CONST_FOR_TTYPETHREE =1;


{ The variables that using only in TTypeThree }
var
    TypeThreeInt: Integer;  // This is a variable

{ The integral procedure that using only in TTypeThree. }
procedure Three();
begin

end;

constructor TTypeThree.Create();
begin

end;

destructor TTypeThree.Create();
begin

end;

function TTypeThree.DoGetValue(): Integer;
begin
    Three();
    Result := FValue;
end;

procedure TTypeThree.DoSetValue(AValue: Integer);
begin
    FValue := AValue;
    Three();
end;

{------------------------------------------------------------------------------}
{ TType2                                                                       }
{------------------------------------------------------------------------------}


end.                                                                     { END }

{------------------------------------------------------------------------------}
