::
:: Build an app
::
:: Author: Mikhail.Malakhov
::

@ECHO OFF

SET RTL_ROOT="./../../rtl"
SET COMPILER_ROOT="./../../compiler"
SET TESTCASES_ROOT="./../cases"

IF EXIST out\ (
    echo Clear out directory...
    rd /s /q out\
) ELSE (
    echo The out directory not found...
)
mkdir out

fpc ./../Test.pas -FEout ^
    -Fu%COMPILER_ROOT%/lang ^
    -Fu%COMPILER_ROOT%/cpu/intel ^
    -Fu%COMPILER_ROOT%/cpu/Cpu.pas ^
    -Fu%COMPILER_ROOT%/os/win ^
    -Fu%COMPILER_ROOT%/os/ ^
    -Fu%RTL_ROOT%/collections ^
    -Fu%TESTCASES_ROOT%/rtl/collections ^
    -otest.exe
