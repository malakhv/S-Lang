::
:: Build an app
::
:: Author: Mikhail.Malakhov
::

@ECHO OFF

SET COMPILER_ROOT="./../compiler"

IF EXIST out\ (
    echo Clear out directory...
    rd /s /q out\
) ELSE (
    echo The out directory not found...
)
mkdir out

fpc %COMPILER_ROOT%/Compiler.pas -FEout ^
    -Fu%COMPILER_ROOT%/cpu/intel ^
    -Fu%COMPILER_ROOT%/cpu/Cpu.pas ^
    -Fu%COMPILER_ROOT%/os/win ^
    -Fu%COMPILER_ROOT%/os/ ^
    -oslang.exe
