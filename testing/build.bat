::
:: Build an app
::
:: Author: Mikhail.Malakhov
::

@ECHO OFF

SET RTL_ROOT="./../rtl"
SET COMPILER_ROOT="./../compiler"
SET TESTCASES_ROOT="./cases"

IF EXIST build\ (
    echo Clear build directory...
    rd /s /q build\
) ELSE (
    echo The build directory not found...
)
mkdir build

fpc ./SelfTest.pas -FEbuild ^
    -Fu%COMPILER_ROOT%/lang ^
    -Fu%COMPILER_ROOT%/cpu/intel ^
    -Fu%COMPILER_ROOT%/cpu/Cpu.pas ^
    -Fu%COMPILER_ROOT%/os/win ^
    -Fu%COMPILER_ROOT%/os/ ^
    -Fu%RTL_ROOT% ^
    -Fu%RTL_ROOT%/collections ^
    -Fu%TESTCASES_ROOT%/rtl/collections ^
    -oSelfTest.exe
