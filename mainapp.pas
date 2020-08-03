unit mainapp;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, mtgautils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  LogDir: String;
begin
  LogDir := LocateMTGA;

  if LogDir <> EmptyStr then
    begin
      LogDir := LogDir + DirectorySeparator + 'Logs' + DirectorySeparator + 'Logs';
      Label1.Caption := LogDir;
    end
  else
    begin
      Label1.Caption := 'Log Directory not found';
    end;
end;

end.

