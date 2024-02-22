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
{ Project: S-Lang - RTL                                                        }
{ Package: S-Lang.Rtl.Collections                                              }
{ Types:   TBD                                                                 }
{                                                                              }
{ Dependencies: No                                                             }
{                                                                              }
{ Created: 22.02.24                                                            }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

UNIT Collections;                                                       { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

{

    https://wiki.freepascal.org/Generics_proposals

  type
    TListItem<T> = record
      Data: T;
      Next: TListItem;
    end;
    PListItem = ^TListItem;
 
    TList<T> = class
    private
      fHead: PListItem<T>;
      fTail: PListItem<T>;
    published
      procedure Add(Item: T);
    end;
 
  procedure TList<T>.Add(Item: T);
  var
    node: PListItem<T>;
  begin
    New(node);
    node^.Data := Item;
    node^.Next := nil;
  
    if Assigned(fTail) then begin
      fTail^.Next := node;
    end else begin
      fHead := node;
    end;
  
    fTail := node;
  end;
  
  type
    TApple = class
    end;
    TOrange = class
    end;
  
    TAppleList = TList<TApple>;
  
  var
    apples: TAppleList;
    apple: TApple;
  begin
    apples.Add(TApple.Create); // works
    apples.Add(TOrange.Create); // compile error
  
    apple := apples[0]; // works
    apple := apples[1]; // not applicable
    apple := apples[0] as TApple; // works, but unneccessary
    apple := apples[1] as TApple; // not applicable
  end;

}

type

    {
        The basic node with a value for all collections.
    }
    generic TNode<V> = class(TObject)
    private
        FValue: V;
    protected
        function GetValue(): V; virtual;
        procedure SetValue(AValue: V); virtual;
    public
        property Value: V read GetValue write SetValue;
        function HasValue(): Boolean;
        constructor Create(AValue: V); virtual;
    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ Common Stuff                                                                 }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ TNode                                                                        }
{------------------------------------------------------------------------------}

constructor TNode<V>.Create(AValue: V);
begin
    inherited Create();
    Self.Value := AValue;
end;

function TNode<V>.GetValue(): V;
begin
    Result := FValue;
end;

procedure TNode<V>.SetValue(AValue: V);
begin
    FValue := V;
end;

function TNode<V>.HasValue(): Boolean;
begin
    Result := Self.Value <> nil;
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
