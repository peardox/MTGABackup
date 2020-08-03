unit mainapp;

{$mode objfpc}{$H+}
{$define usemtga}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure PrintFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0);
  private

  public

  end;

var
  Form1: TForm1;
  linecount: Integer;

implementation

uses
  recursefiles, mtgautils;

{$R *.lfm}

{ TForm1 }

procedure TForm1.PrintFiles(FileList: TStringList; Listing: TStrings; Depth: Integer = 0);
var
  idx: Integer;
begin
  for idx := 0 to FileList.Count - 1 do
    begin
      Inc(linecount);
      Listing.Add(StringOfChar(' ', Depth * 4) + FileList.Strings[idx]);
      if FileList.Objects[idx] <> nil then
        begin
          PrintFiles(FileList.Objects[idx] as TStringList, Listing, Depth + 1);
        end;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
const
{$IFDEF WINDOWS}
  TestDir = 'C:\dev\editor\data\models';
{$ENDIF}
{$IFDEF Darwin}
  TestDir = '/Users/simon/dev/castle/editor/data/models';
{$ENDIF}
var
  LogDir: String;
  FileList: TStringList;
  idx: Integer;
begin
  linecount := 0;
  LogDir := LocateMTGA;
  Memo1.Clear;

  if LogDir <> EmptyStr then
    begin
      LogDir := LogDir + DirectorySeparator + 'Logs' + DirectorySeparator + 'Logs';
      Label1.Caption := LogDir;
      {$ifdef usemtga}
      FileList := RecursiveFileList(LogDir);
      {$else}
      FileList := RecursiveFileList(TestDir);
      {$endif}
      PrintFiles(FileList, Memo1.Lines);
      Memo1.Lines.Add('' + LineEnding + IntToStr(linecount) + ' records');
      FileList.Free;
    end
  else
    begin
      Label1.Caption := 'Log Directory not found';
    end;
end;

end.

