#!/bin/sh

RTL_ROOT="./../rtl"
COMPILER_ROOT="./../compiler"

# Clear build (out) dir
rm -R -f ./out
mkdir -p out

# Compile programm
fpc $COMPILER_ROOT/Compiler.pas -FEout \
    -Fu$COMPILER_ROOT/lang \
    -Fu$COMPILER_ROOT/cpu/intel \
    -Fu$COMPILER_ROOT/cpu/Cpu.pas \
    -Fu$COMPILER_ROOT/os/win \
    -Fu$COMPILER_ROOT/os/ \
    -Fu$RTL_ROOT \
    -Fu$RTL_ROOT/collections \
    -oslang.exe
