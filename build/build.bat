::
:: Build an app
::
:: Author: Mikhail.Malakhov
::

@ECHO OFF

SET COMPILER_ROOT="./../compiler"

IF EXIST build\ (
    echo Clear build directory...
    rd /s /q build\
) ELSE (
    echo The build directory not found...
)
mkdir build

fpc %COMPILER_ROOT%/Compiler.pas -FEbuild ^
    -Fu%COMPILER_ROOT%/cpu/intel ^
    -Fu%COMPILER_ROOT%/cpu/Cpu.pas ^
    -Fu%COMPILER_ROOT%/os/win ^
    -Fu%COMPILER_ROOT%/os/Os.pas ^
    -oslang.exe
