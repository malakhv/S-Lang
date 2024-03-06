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

UNIT SLang.Collections;                                                       { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.Classes;


{
    The basic interfaces for all collections
}
type

    {
        The root interface in the collection hierarchy. A collection represents
        a group of objects, known as its elements. Some collections allow
        duplicate elements and others do not. Some are ordered and others
        unordered.
    }
    ICollection = interface(IInterface)
        ['{30A60589-647B-46F5-BBB3-0F589D8F9928}']

        { Ensures that this collection contains the specified element.
  
          Returns True if this collection changed as a result of the call,
          otherwise False (if this collection does not permit duplicates and
          already contains the specified element, for exemple).

          Collections that support this operation may place limitations on what
          elements may be added to this collection - some collections will
          refuse to add Nil elements and others will impose restrictions on the
          type of elements that may be added. Collection classes should clearly
          specify in their documentation any restrictions on what elements may
          be added. }
        function Add(const Element: Pointer): Boolean;

        { Returns True if this collection contains the specified element.

          More formally, returns true if and only if this collection contains
          at least one specified element. }
        function Contains(const Element: Pointer): Boolean;

        { Returns the number of elements in this collection. }
        function GetCount(): Integer;

        { Returns True if this collection contains no elements. }
        function IsEmpty(): Boolean;

        { Removes a single instance of the specified element from this
          collection, if it is present.

          Returns true if this collection contained the specified element (or
          equivalently, if this collection changed as a result of the call). }
        function Remove(const Element: Pointer): Boolean;

        { Returns an array containing all of the elements in this collection.

          If this collection makes any guarantees as to what order its
          elements, this method must return the elements in the same order. }
        function ToArray(): TPointers;

        { Removes all of the elements from this collection. The collection will
          be empty after this method returns. }
        procedure Clear();

    end;

    {
        An ordered collection (also known as a sequence). This collection
        allows to precise control over where in the list each element is
        inserted. Also it allows to access elements by their integer index
        (position in the list), and search for elements in the list.

        See also: TList, TLinkedList, TArrayList, TStack
    }
    IList = interface(ICollection)
        ['{ABDF916A-8CA6-47B8-945F-0E08F5A1330E}']

        { Returns the element at the specified position in this list. }
        function Get(Index: Integer): Pointer;

        { Returns the index of the first occurrence of the specified element in
          this list, or -1 if this list does not contain the element. }
        function IndexOf(const Element: Pointer): Integer;

        { Inserts the specified element at the specified position in this list.
          Shifts the element currently at that position (if any) and any
          subsequent elements to the right (adds one to their indices).

          Returns True if this list changed as a result of the call, otherwise
          False (if Index is invalid, for exemple). }
        function Insert(Index: Integer; const Element: Pointer): Boolean;

        { Moves element with specified index to a new position in this list.

          Returns True if this list changed as a result of the call, otherwise
          False (if FromIndex or ToIndex is invalid, for exemple).
        }
        function Move(FromIndex, ToIndex: Integer): Boolean;

        { Removes the element at the specified position in this list. Shifts
          any subsequent elements to the left (subtracts one from their
          indices).

          Returns True if this list contained the specified element (or
          equivalently, if this list changed as a result of the call). }
        function Remove(Index: Integer): Boolean;

        { Replaces the element at the specified position in this list.

          Returns True if this list changed as a result of the call, otherwise
          False (if Index is invalid, for exemple).
        }
        function Update(Index: Integer; const Element: Pointer): Boolean;

    end;

    {
        An unordered collection that contains no duplicate elements (and at
        most one Nil element). As implied by its name, this interface models
        the mathematical set abstraction. Basically, this interface repeats
        the ICollection interface.

        Note: Pascal has a special language construction Set. We want to have
        yet another set structure to work with it the same as abstract
        collection.

        See also: TSet, THashSet, TTreeSet.
    }
    ISet = interface(ICollection)
        ['{C870930D-333B-4CC1-834B-9426477F22C6}']
        // TODO Set Operations: difference, intersection, subset, superset,
        // equality, inequality, union
        // See https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Expressions_(Delphi)#Set_Operators
    end;

type

    {
        The basic node with a value for all collections.
    }
    TNode<V> = class(TObject)
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
