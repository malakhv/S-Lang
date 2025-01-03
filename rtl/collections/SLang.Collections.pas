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
{ working with collections. This is a part of S-Lang Collections Framework.    }
{                                                                              }
{ Project: S-Lang RTL                                                          }
{ Package: S-Lang.Collections                                                  }
{ Types:   ICollection, IList, ISet, ITree                                     }
{                                                                              }
{ Dependencies: SLang.Types, SLang.Classes                                     }
{                                                                              }
{ Created: 22.02.24                                                            }
{ Authors: Mikhail.Malakhov [malakhv@gmail.com|http://mikhan.me/]              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                 Collections                                  }
{                                                                              }
{ The S-Lang RTL includes a collections framework. A collection is an object   }
{ that represents a group of objects (such as the classic TLinkedList class).  }
{ A collections framework is a unified architecture for representing and ma-   }
{ nipulating collections, enabling collections to be manipulated independently }
{ of implementation details.                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{                                 Definitions                                  }
{                                                                              }
{ Element - An element in collection with real object, in other words, an item }
{           of the collection (collection item). For more details, see the     }
{           IElement interface and TElement class.                             }
{                                                                              }
{ Object  - A real data as element of a collection (inside collection item).   }
{                                                                              }
{ Value   - A link to real data (object) inside collection item. For more      }
{           details, see TElement.                                             }
{------------------------------------------------------------------------------}

UNIT SLang.Collections;                                                 { UNIT }

{$MODE DELPHI}
{$H+}
{$T+}

INTERFACE                                                          { INTERFACE }

uses SLang.Types, SLang.Classes;

{ Collection }
type

    {
        An element in collection (collection item) with real object.

        See also: TElement.
    }
    IElement = interface(IInterface)
        ['{1C609401-B669-4938-8959-6AB4394B6EE5}']

        { Returns True if this Element contains no real object. }
        function IsEmpty(): Boolean;

        { Clears this Element (remove real object from this Element). After
          this operation, Element is considered empty. }
        procedure Clear();

        { Removes itself from its collection. }
        procedure Remove();
    end;

    {
        The root interface in the collection hierarchy. A collection represents
        a group of objects, known as its elements. Some collections allow
        duplicate elements and others do not. Some are ordered and others
        unordered.
    }
    ICollection = interface(IInterface)
        ['{30A60589-647B-46F5-BBB3-0F589D8F9928}']

        { Adds specified object to this collection.

          Returns True if this collection changed as a result of the call,
          otherwise False (if this collection does not permit duplicates and
          already contains the specified object, for exemple).

          Collections that support this operation may place limitations on what
          objects may be added to this collection - some collections will
          refuse to add Nil value and others will impose restrictions on the
          type of objects that may be added. Collection classes should clearly
          specify in their documentation any restrictions on what elements may
          be added. }
        function Add(const Obj: Pointer): Boolean;

        { Returns True if this collection contains the specified object.

          More formally, returns true if and only if this collection contains
          at least one specified object. }
        function Contains(const Obj: Pointer): Boolean;

        { Returns the number of elements in this collection. }
        function GetCount(): Integer;

        { Returns True if this collection contains no elements. }
        function IsEmpty(): Boolean;

        { Removes a single instance of the specified object from this
          collection, if it is present.

          Returns true if this collection contained the specified object
          (or equivalently, if this collection changed as a result of the
          call). }
        function Remove(const Obj: Pointer): Boolean;

        { Returns an array containing all of the objects in this collection.

          If this collection makes any guarantees as to what order its
          elements, this method must return the objects in the same order. }
        function ToArray(): TPointers;

        { Removes all of the elements from this collection. The collection will
          be empty after this method returns. }
        procedure Clear();

    end;

{ List }
type

    {
        An ordered collection (also known as a sequence). This collection
        allows to precise control over where in the list each element is
        inserted. Also it allows to access elements by their integer index
        (position in the list), and search for elements in the list.

        See also: TList, TLinkedList, TArrayList, TStack
    }
    IList = interface(ICollection)
        ['{ABDF916A-8CA6-47B8-945F-0E08F5A1330E}']

        { Returns the object at the specified position in this list. }
        function Get(Index: Integer): Pointer;

        { Returns the index of the first occurrence of the specified object in
          this list, or -1 if this list does not contain the object. }
        function IndexOf(const Obj: Pointer): Integer;

        { Inserts the specified object at the specified position in this list.
          Shifts the element currently at that position (if any) and any
          subsequent elements to the right (adds one to their indices).

          Returns True if this list changed as a result of the call, otherwise
          False (if Index is invalid, for exemple). }
        function Insert(Index: Integer; const Obj: Pointer): Boolean;

        { Moves element with specified index to a new position in this list.

          Returns True if this list changed as a result of the call, otherwise
          False (if FromIndex or ToIndex is invalid, for exemple).
        }
        function Move(FromIndex, ToIndex: Integer): Boolean;

        { Removes the element at the specified position in this list. Shifts
          any subsequent elements to the left (subtracts one from their
          indices).

          Returns the element that was removed from the list. }
        function Remove(Index: Integer): Pointer; overload;

        { Swaps two elements in this collection.

          Returns True if this list changed as a result of the call, otherwise
          False (if Index1 or Index2 is invalid, for exemple). }
        function Swap(Index1, Index2: Integer): Boolean;

        { Replaces the object at the specified position in this list.

          Returns True if this list changed as a result of the call, otherwise
          False (if Index is invalid, for exemple).
        }
        function Update(Index: Integer; const Obj: Pointer): Boolean;

    end;

{ Set }
type

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

{ Tree }
type

    ITree = interface(ICollection)
        ['{812ECE41-8FAF-4496-AECF-63C757D1A784}']
    end;

type

    {
        The default implementation of IElement. This implementation
        includes one Pointer as a Value inside this collection item.

        See also: IElement.
    }
    TElement = class(TInterfacedObject, IElement)
    private
        FValue: Pointer;    // See Value property.
    protected
        { See Value property. }
        procedure SetValue(Val: Pointer);
        { Constructs an empty instance of collection item. }
        constructor Create(); virtual;
    public
        { The link to real data (object) stored into this collection item. }
        property Value: Pointer read FValue write SetValue;
        { Indicates whether some collection item is "equal to" this one. }
        function Equals(Obj: TObject): Boolean; override;
        { From IElement interface. }
        function IsEmpty(): Boolean;
        { From IElement interface. }
        procedure Clear(); virtual;
        { From IElement interface. }
        procedure Remove(); virtual;
        { Free all related resources. }
        destructor Destroy; override;
    end;

IMPLEMENTATION                                                { IMPLEMENTATION }

{------------------------------------------------------------------------------}
{ TItem                                                                        }
{------------------------------------------------------------------------------}

constructor TElement.Create();
begin
    inherited;
    FValue := nil;
end;

destructor TElement.Destroy;
begin
    Self.Clear();
    inherited;
end;

function TElement.Equals(Obj: TObject): Boolean;
begin
    Result := (Self.FValue <> nil) and (Obj <> nil)
        and (Obj is TElement)
        and (Self.FValue = (Obj as TElement).FValue);
end;

function TElement.IsEmpty(): Boolean;
begin
    Result := Self.FValue = nil;
end;

procedure TElement.SetValue(Val: Pointer);
begin
    Self.FValue := Val;
end;

procedure TElement.Clear();
begin
    Self.FValue := nil;
end;

procedure TElement.Remove();
begin
    Self.Free();
end;

END.                                                                     { END }

{------------------------------------------------------------------------------}
