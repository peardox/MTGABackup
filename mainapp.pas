unit mainapp;

{$mode objfpc}{$H+}
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
var
  LogDir: String;
  FileList: TStringList;
  idx: Integer;
begin
  LogDir := LocateMTGA;
  Memo1.Clear;

  if LogDir <> EmptyStr then
    begin
      LogDir := LogDir + DirectorySeparator + 'Logs' + DirectorySeparator + 'Logs';
      Label1.Caption := LogDir;
      FileList := RecursiveFileList(LogDir);
      for idx := 0 to FileList.Count - 1 do
        Memo1.Lines.Add(FileList.Strings[idx]);
      FileList.Free;
    end
  else
    begin
      Label1.Caption := 'Log Directory not found';
    end;
end;

end.

