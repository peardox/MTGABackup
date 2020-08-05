unit recursefiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls;

function RecursiveFileList(const SearchPath: String; FileList: TStringList = nil): TStringList;
function RecursiveListFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0): Integer;
function RecursiveListFiles(FileList: TStringList; Listing: TTreeView; ParentNode: TTreeNode = nil; Depth: Integer = 0): Integer;

implementation

function RecursiveListFiles(FileList: TStringList; Listing: TTreeView; ParentNode: TTreeNode = nil; Depth: Integer = 0): Integer;
var
  idx: Integer;
  LineCount: Integer;
  ChildNode: TTreeNode;
begin
  if Depth = 0 then
    begin
    Listing.Items.BeginUpdate;
    Listing.Items.Clear;
    end;

  LineCount := FileList.Count;

  for idx := 0 to FileList.Count - 1 do
    begin
      if FileList.Objects[idx] <> nil then
        begin
          ChildNode := Listing.Items.AddChild(ParentNode, FileList.Strings[idx]);
          if ParentNode <> nil then
            begin
            ParentNode.Expand(True);
            end;
          LineCount += RecursiveListFiles(FileList.Objects[idx] as TStringList, Listing, ChildNode, Depth + 1);
        end
      else
        begin
          if ParentNode = nil then
            begin
              Listing.Items.Add(ParentNode, FileList.Strings[idx]);
            end
          else
            begin
            ChildNode := Listing.Items.AddChild(ParentNode, FileList.Strings[idx]);
            end;
        end;

    end;

  if Depth = 0 then
    Listing.Items.EndUpdate;

  Result := LineCount;
end;

function RecursiveListFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0): Integer;
var
  idx: Integer;
  LineCount: Integer;
begin
  if Depth = 0 then
    Listing.BeginUpdate;

  LineCount := FileList.Count;

  for idx := 0 to FileList.Count - 1 do
    begin
      if FileList.Objects[idx] <> nil then
        begin
        Listing.Add(StringOfChar(' ', Depth * 2) + '+ ' + FileList.Strings[idx]);
        LineCount += RecursiveListFiles(FileList.Objects[idx] as TStringList, Listing, Depth + 1);
        end
      else
        begin
        Listing.Add(StringOfChar(' ', Depth * 2) + '  ' + FileList.Strings[idx]);
        end;
    end;

  if Depth = 0 then
    Listing.EndUpdate;

  Result := LineCount;
end;

function RecursiveFileList(const SearchPath: String; FileList: TStringList = nil): TStringList;
const
{$IFDEF WINDOWS}
  SearchMask = '*.*';
{$ENDIF}
{$IFDEF Darwin}
  SearchMask = '*';
{$ENDIF}
var
  Info: TRawbyteSearchRec;
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

