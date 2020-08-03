unit mtgautils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function LocateMTGA: String;

implementation
{$IFDEF WINDOWS}
uses
  Registry;
{$ENDIF}

function LocateMTGA: String;
var
  MTGALocalPath: String;
  {$IFDEF WINDOWS}
  Registry: TRegistry;
  {$ENDIF}
begin
  MTGALocalPath := EmptyStr;
  {$IFDEF WINDOWS}
  // HKEY_LOCAL_MACHINE\SOFTWARE\Wizards of the Coast\MTGArena
  Registry := TRegistry.Create;
  try
    // Navigate to proper "directory":
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.Access:=Registry.Access or KEY_WOW64_32KEY;
    if Registry.OpenKeyReadOnly('\SOFTWARE\Wizards of the Coast\MTGArena') then
      MTGALocalPath := IncludeTrailingPathDelimiter(Registry.ReadString('Path')) + 'MTGA_Data';
  finally
    Registry.Free;
  end;
  {$ENDIF}
  {$IFDEF Darwin}
  MTGALocalPath := IncludeTrailingPathDelimiter(GetUserDir) + 'Library/Application Support/com.wizards.mtga';
  {$ENDIF}
  Result := MTGALocalPath;
end;

end.

