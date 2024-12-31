# S-Lang Data Types

This section describes the fundamental data types of the S-Lang language.

https://docwiki.embarcadero.com/RADStudio/Sydney/en/Data_Types,_Variables,_and_Constants_Index

## Overview

This topic presents a high-level overview of Delphi data types.

A *type* is essentially a name for a kind of data. When you declare a variable you must specify its type, which determines the set of values the variable can hold and the operations that can be performed on it. Every expression returns data of a particular type, as does every function. Most functions and procedures require parameters of specific types.

The S-Lang language is a 'strongly typed' language, which means that it distinguishes a variety of data types and does not always allow you to substitute one type for another. This is usually beneficial because it lets the compiler treat data intelligently and validate your code more thoroughly, preventing hard-to-diagnose run-time errors. When you need greater flexibility, however, there are mechanisms to circumvent strong typing. These include typecasting, pointers, variants, variant parts in records, and absolute addressing of variables.

There are several ways to categorize Delphi data types:

* Some types are **predefined** (or **built-in**); the compiler recognizes these automatically, without the need for a declaration. Almost all of the types documented in this language reference are predefined. Other types are created by declaration; these include user-defined types and the types defined in the product libraries.

* Types can be classified as either **fundamental** or **general**. The range and format of a fundamental type is the same in all implementations of the S-Lang language, regardless of the underlying CPU and operating system. The range and format of a general type is platform-specific and could vary across different implementations. Most predefined types are fundamental, but a handful of integer, character, string, and pointer types are general. It is a good idea to use general types when possible, since they provide optimal performance and portability. However, changes in storage format from one implementation of a general type to the next could cause compatibility problems - for example, if you are streaming content to a file as raw, binary data, without type and versioning information.

* Types can be classified as **simple**, **string**, **structured**, **pointer**, **procedural**, or **variant**. In addition, type identifiers themselves can be regarded as belonging to a special 'type' because they can be passed as parameters to certain functions (such as **High**, **Low**, and **SizeOf**).

* Types can be **parameterized**, or **generic**, as well. Types can be generic in that they are the basis of a structure or procedure that operates in concert with different types determined later.

The outline below shows the taxonomy of S-Lang data types:

* simple
    * ordinal
        * integer
        * character
        * boolean
        * enumerated
        * subrange
    * float
* string
* structured
    * set
    * array
    * record
    * file
    * class
    * class reference
    * interface
* pointer
* procedural
* variant
* type identifier

The standard function **SizeOf** operates on all variables and type identifiers. It returns an integer representing the amount of memory (in bytes) required to store data of the specified type. For example:

* In 32-bit platforms **SizeOf(LongInt)** returns 4, since a **LongInt** variable uses four bytes of memory.
* In 64-bit platform **SizeOf(LongInt)** returns 8, since a LongInt variable uses eight bytes of memory.

Type declarations are illustrated in the topics that follow.

## Simple Types

Simple types - which include ordinal types and float types - define ordered sets of values.

### Ordinal Types





