unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
i,j: Integer;
begin
 for i := 0 to Image1.Width do
  for j := 0 to Image1.Height do
   begin
    if Image1.Canvas.Pixels[i,j] = clBlack then
     begin
      ListBox1.Items.Add(IntToStr(i));
      ListBox2.Items.Add(IntToStr(j));
      ListBox3.Items.Add(IntToStr(i) + ', ' + IntToStr(j) );
     end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Canvas.Brush.Color := clBtnFace;
Canvas.Brush.Style := bsClear;
Canvas.Polyline([
 Point(3, 9),
 Point(3, 10),
 Point(3, 11),
 Point(3, 12),
 Point(4, 8),
 Point(4, 13),
 Point(5, 7),
 Point(5, 14),
 Point(6, 7),
 Point(6, 14),
 Point(7, 6),
 Point(7, 15),
 Point(8, 6),
 Point(8, 15),
 Point(9, 6),
 Point(9, 15),
 Point(10, 6),
 Point(10, 15),
 Point(11, 6),
 Point(11, 15),
 Point(12, 6),
 Point(12, 15),
 Point(13, 6),
 Point(13, 15),
 Point(14, 7),
 Point(14, 14),
 Point(15, 7),
 Point(15, 14),
 Point(16, 8),
 Point(16, 13),
 Point(17, 9),
 Point(17, 10),
 Point(17, 11),
 Point(17, 12)]);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
Pt: TPoint;
P: TPoint;
i: Integer;
begin
 for i := 0 to ListBox1.Items.Count - 1 do
  begin
   P.x := StrToInt(ListBox1.Items[i]);
   P.y := StrToInt(ListBox2.Items[i]);
   begin
    Canvas.Polyline([Point(P.x, P.y)]);
   end;
  end;
end;

end.
