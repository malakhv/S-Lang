program test;

{$MODE DELPHI}
{$H+}
{$T+}

uses Os, ListTest;

begin
    WriteLn('Welcome to S-Lang testing. ','Target OS is ', Os.getTargetOS);
    ListCase.Run();
end.
