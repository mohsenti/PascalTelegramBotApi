unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fpjson, jsonparser,typinfo,fpjsonrtti,TelegramApi;

type

  { TForm1 }
  //https://api.telegram.org/bot145663160:xxxx/getMe
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    FBaseUrl:String;
  end;

var
  Form1: TForm1;

implementation


{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBaseUrl:='https://api.telegram.org/bot145663160:xxxx/';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(getMe(FBaseUrl)^.username);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Updates: PUpdateArray;
  I: Integer;
  Keyboard:TReplyKeyboardMarkup;
begin
  Updates:=getUpdates(FBaseUrl,54596141,100,0);
  SetLength(Keyboard.keyboard,2,2);
  New(Keyboard.keyboard[0][0]);
  Keyboard.keyboard[0][0]^.text:='X';
  New(Keyboard.keyboard[0][1]);
  Keyboard.keyboard[0][1]^.text:='Y';
  Keyboard.keyboard[1][0]:=nil;
  New(Keyboard.keyboard[1][1]);
  Keyboard.keyboard[1][1]^.text:='Y';

  for I:=0 to Length(Updates) -1 do begin
    WriteLn(Updates[I]^.update_id);
    WriteLn(Updates[I]^.message^.text);
    try
       if (Updates[I]^.message^.text = '') then Continue;
       sendPhoto(FBaseUrl,Updates[I]^.message^.chat^.id,'path-to-photo','This is a caption',false,0,PReplyKeyboardMarkup(nil));
    except
    end;
  end;
end;

end.

