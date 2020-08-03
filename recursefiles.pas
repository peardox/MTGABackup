unit recursefiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function RecursiveFileList(const SearchPath: UnicodeString; FileList: TStringList = nil): TStringList;

implementation

function RecursiveFileList(const SearchPath: UnicodeString; FileList: TStringList = nil): TStringList;
const
{$IFDEF WINDOWS}
  SearchMask = '*.*';
{$ENDIF}
{$IFDEF Darwin}
  SearchMask = '*';
{$ENDIF}
var
  Info: TUnicodeSearchRec;
begin
  if FileList = nil then
    begin
      FileList := TStringList.Create;
      FileList.OwnsObjects := True;
    end;

  if FindFirst (SearchPath + DirectorySeparator + SearchMask,faAnyFile,Info)=0 then
    begin
      repeat
      with Info do
        begin
        If (Attr and faDirectory) = faDirectory then
          begin
            FileList.Add(Name);
          end;
        FileList.Add(Name);
        end;
      until FindNext(Info)<>0;
    FindClose(Info);
    end;

  Result := FileList;
end;

end.

