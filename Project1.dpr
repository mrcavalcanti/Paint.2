program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Pintin - Pintura Infantil';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
