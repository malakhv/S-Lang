Unit Os;

// Compiler options
{$MODE DELPHI}
{$H+}
{$T+}

interface

type

    TTargetOS = (toNix, toWin);

function getTargetOS(): TTargetOS;

function isNix(): Boolean;

function isWin(): Boolean;

implementation

var
    TargetOS: TTargetOS;

function getTargetOS(): TTargetOS;
begin
    Result := TargetOS;
end;

function isNix(): Boolean;
begin
    Result := getTargetOS() = toNix;
end;

function isWin(): Boolean;
begin
    Result := getTargetOS() = toWin;
end;

initialization

    TargetOS := toWin;

end.
