{ Statement:
    Block
        program
        unit
            interface
            implementation
            initialization
            finalization
        with
        begin/end;
        type
        var
        const

    Variable
    Constant
        typed
        untyped
    Operation
        unary operation
        binary operation
        Arithmetic operations
            Addition (+)
            Subtraction (-)
            Multiplication (*)
            Division (/, div)
                With or without fraction
        Bitwise operations
            Shl
            Shr
            And
            Or
            Not
            Xor
        Logical operations
            And
            Or
            Not
            Xor
    Control
        If
        Case
        For
        While
    Nil
}

type

    TStName: String[15];
    TStType = (stBlock, stVar, stConst, stOp, stControl);

type

    TStatement = class();
    private
        FName: TStName;
        FType: TStType;
    public
        property StatementType: TStatementType read FType;
        function isBlock(): Boolean;
        function isVar(): Boolean;
        function isConst(): Boolean;
        function isOp(): Boolean;
        function isControl(): Boolean;

        { Generate code for this Statement. }
        function CodeGen(): String; abstract; virtual;
        
        constructor Create(AName: TStName; AType: TStType); virtual;
    end;

    TVariable = class(TStatement);

    protected
        function GetSize(): Integer; virtual;
        function GetValue():
    public
        property Size: Integer read GetSize();
        constructor Create(AName: TStName); virtual;
    end;

