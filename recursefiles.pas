unit recursefiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function RecursiveFileList(const SearchPath: UnicodeString; FileList: TStringList = nil): TStringList;
function RecursiveListFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0): Integer;

implementation

function RecursiveListFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0): Integer;
var
  idx: Integer;
  linecount: Integer;
begin
  if Depth = 0 then
    Listing.BeginUpdate;

  linecount := FileList.Count;

  for idx := 0 to FileList.Count - 1 do
    begin
      if Depth > 0 then
        if idx > 0 then
          Listing.Add(StringOfChar(' ', Depth * 2) + FileList.Strings[idx])
        else
          Listing.Add(StringOfChar(' ', (Depth - 1) * 2) + '+ ' + FileList.Strings[idx])
      else
        Listing.Add(FileList.Strings[idx]);
      if FileList.Objects[idx] <> nil then
        begin
          linecount += RecursiveListFiles(FileList.Objects[idx] as TStringList, Listing, Depth + 1);
        end;
    end;

  if Depth = 0 then
    Listing.EndUpdate;

  Result := linecount;
end;

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
          if (Attr and faDirectory) = faDirectory then
            begin
              if ((Name <> '.') and (Name <> '..')) then
                begin
                  FileList.AddObject(Name, RecursiveFileList(SearchPath + DirectorySeparator + Name, nil));
                end;
            end
          else
            begin
              FileList.AddObject(Name, nil);
            end;
        end;
      until FindNext(Info)<>0;
    FindClose(Info);
    end;

  Result := FileList;
end;

end.

