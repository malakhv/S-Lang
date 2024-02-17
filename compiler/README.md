# Compiles Source Code

This repo contains the source code of compiler.

### Compiler Packages

// Эти пакеты не должны быть доступны приложениям? Только внутри компилятора.

// Нужен ли тут префикс? Это должно быть имя языка, или что-то еще?
// Как вариант - эо может быть просто pascal.* или совсем абстрактное lang.*


* pascal.compiler.*
* pascal.compiler.arch.arm
* pascal.compiler.arch.intel
* pascal.compiler.arch.riscv
* pascal.compiler.lang
* pascal.compiler.lexer
* pascal.compiler.nix
* pascal.compiler.os
* pascal.compiler.parser



### RTL Packages

* pascal.rtl.*
* pascal.core