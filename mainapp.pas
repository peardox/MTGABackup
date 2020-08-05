unit mainapp;

{$mode objfpc}{$H+}
// {$define usemtga}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Menus, VirtualTrees;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  recursefiles, mtgautils;

{$R *.lfm}

{ TForm1 }

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
  linecount: Integer;
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

      Memo1.Lines.Add(EmptyStr);
      linecount := RecursiveListFiles(FileList, Memo1.Lines);
      Memo1.Lines.Insert(0, IntToStr(linecount) + ' records');
      Memo1.VertScrollBar.Position := 0;

      RecursiveListFiles(FileList, TreeView1);

      FileList.Free;
    end
  else
    begin
      Label1.Caption := 'Log Directory not found';
    end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Panel1Resize(Sender: TObject);
begin
  Panel3.Height := Round(Panel1.Height / 2);
end;

end.

