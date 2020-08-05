unit recursefiles;

{$mode objfpc}{$H+}
{$define showdepth}

interface

uses
  Classes, SysUtils, ComCtrls;

function RecursiveFileList(const SearchPath: UnicodeString; FileList: TStringList = nil): TStringList;
function RecursiveListFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0): Integer;
function RecursiveListFiles(FileList: TStringList; Listing: TTreeView; ParentNode: TTreeNode = nil; Depth: Integer = 0): Integer;

implementation
uses
  mainapp;

function RecursiveListFiles(FileList: TStringList; Listing: TTreeView; ParentNode: TTreeNode = nil; Depth: Integer = 0): Integer;
const
  DebugMax = 1;
var
  idx: Integer;
  LineCount: Integer;
  ChildNode: TTreeNode;
begin
  if Depth = 0 then
    Listing.Items.BeginUpdate;

  LineCount := FileList.Count;

  DebugLine(Depth, DebugMax, '============================');
  DebugLine(Depth, DebugMax, 'Enter :  Depth = ' + IntToStr(Depth) + ', Parent = ' + HexStr(ParentNode));

  for idx := 0 to FileList.Count - 1 do
    begin
      DebugLine(Depth, DebugMax, 'FileList : Index = ' + IntToStr(idx) + ', Text = ' + FileList.Strings[idx]);
      if FileList.Objects[idx] <> nil then
        begin
          DebugLine(Depth, DebugMax, 'AddChild');
          ChildNode := Listing.Items.AddChild(ParentNode, FileList.Strings[idx] + ' (' + IntToStr(Depth) + ') [' + IntToStr(idx) + '] ***');
          LineCount += RecursiveListFiles(FileList.Objects[idx] as TStringList, Listing, ChildNode, Depth + 1);
        end
      else
        begin
          DebugLine(Depth, DebugMax, 'Add');
          Listing.Items.Add(ParentNode, FileList.Strings[idx] + ' (' + IntToStr(Depth) + ') [' + IntToStr(idx) + ']');
        end;

    end;

  if Depth = 0 then
    Listing.Items.EndUpdate;

  DebugLine(Depth, DebugMax, 'Exit : Depth = ' + IntToStr(Depth));

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
        {$ifdef showdepth}
        Listing.Add(StringOfChar(' ', Depth * 2) + '+ ' + FileList.Strings[idx] + ' (' + IntToStr(Depth) + ') ***');
        {$else}
        Listing.Add(StringOfChar(' ', Depth * 2) + '+ ' + FileList.Strings[idx]);
        {$endif}
        LineCount += RecursiveListFiles(FileList.Objects[idx] as TStringList, Listing, Depth + 1);
        end
      else
        begin
        {$ifdef showdepth}
        Listing.Add(StringOfChar(' ', Depth * 2) + '  ' + FileList.Strings[idx] + ' (' + IntToStr(Depth) + ')');
        {$else}
        Listing.Add(StringOfChar(' ', Depth * 2) + '  ' + FileList.Strings[idx]);
        {$endif}
        end;
    end;

  if Depth = 0 then
    Listing.EndUpdate;

  Result := LineCount;
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
                  FileList.AddObject(Name + ' [Node]', RecursiveFileList(SearchPath + DirectorySeparator + Name, nil));
                end;
            end
          else
            begin
              FileList.AddObject(Name + ' [Leaf]', nil);
            end;
        end;
      until FindNext(Info)<>0;
    FindClose(Info);
    end;

  Result := FileList;
end;

end.

