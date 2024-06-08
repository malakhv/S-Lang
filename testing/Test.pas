program test;

{$MODE DELPHI}
{$H+}
{$T+}

uses Os, ListTest, TreeTest, TreeTestNext;

begin
    WriteLn('Welcome to S-Lang testing. ','Target OS is ', Os.getTargetOS);
    //ListCase.Run();
    //TreeCase.Run();
    TreeCase.Run();
end.
