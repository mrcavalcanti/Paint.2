unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, Buttons, Printers, MccsAbout;

type
  TForm1 = class(TForm)
    Image1: TImage;
    PopupMenu1: TPopupMenu;
    Fechar1: TMenuItem;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Panel1: TPanel;
    ImgPrincipal: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    LImprimir1: TLabel;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    LImprimir2: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Image23: TImage;
    LSalvar1: TLabel;
    LSalvar2: TLabel;
    ImgSobre1: TImage;
    ImgAjuda1: TImage;
    ImgSobre2: TImage;
    MccsAbout1: TMccsAbout;
    ImgAjuda2: TImage;
    ImgSair1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    sd: TSaveDialog;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure ImgPrincipalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure Image15Click(Sender: TObject);
    procedure Image19Click(Sender: TObject);
    procedure Image18Click(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Image16Click(Sender: TObject);
    procedure Image22Click(Sender: TObject);
    procedure Image21Click(Sender: TObject);
    procedure Image20Click(Sender: TObject);
    procedure LImprimir1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure LSalvar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image11Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ImgSobre2Click(Sender: TObject);
    procedure ImgSobre1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgAjuda1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgSair1Click(Sender: TObject);
    procedure Image23Click(Sender: TObject);
    procedure ImgAjuda2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    Int, IntImg: Integer;
    XResolucao, YResolucao: Integer;
    Img: array[1..9999] of TImage;
    ImgCount: Integer;
    PicPath: String;
    Lista: TStrings;
    CorCount: Integer;
    Cor1, Cor2: TColor;
    ShapeSelect2: TShape; // sempre será o segundo shape selecionado;

    procedure CreateImageList(Path: String);
    procedure BlendColor(AColor: TColor);
    procedure CreateSelectShape;
    procedure VisibleSelectShape(AImage: TImage);


  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
    // Números finais das imagens de cores e seus shapes
    IndexImg: array[0..19] of Integer = (2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,22);

implementation


{$R *.DFM}


// Cria uma lista de imagens com seus nomes para o path
procedure TForm1.CreateImageList(Path: String);
var
  SearchRec : TSearchRec;
  Result    : Integer;
begin
  ChDir(Path);
  Result := FindFirst('Imagem*.bmp', faAnyFile, SearchRec);
  While (Result = 0) do
  begin
    if (SearchRec.Size <= 2530000) then
      Lista.Add(SearchRec.Name);
    Result := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
  ImgCount := Lista.Count;
end;



function PrintImage(Origem: String):Boolean;
// imprime um bitmap selecionado retornando falso em caso negativo
// requer as units Graphics e printers declaradas na clausula Uses
var
  Imagem: TBitmap;
begin
  if fileExists(Origem) then
  begin
    Imagem := TBitmap.Create;
    Imagem.LoadFromFile(Origem);
    with Printer do
    begin
      BeginDoc;
      Canvas.Draw((PageWidth - Imagem.Width) div 2,
                  (PageHeight - Imagem.Height) div 2,
                  Imagem);
      EndDoc;
    end;
    Imagem.Free;
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;



function TrocaResolucao(X, Y: word): Boolean;
var
  lpDevMode: TDeviceMode;
begin
  if EnumDisplaySettings(nil, 0, lpDevMode) then
    lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
  lpDevMode.dmPelsWidth := X;
  lpDevMode.dmPelsHeight:= Y;
  Result := ChangeDisplaySettings(lpDevMode, 0) = DISP_CHANGE_SUCCESSFUL;
end;


procedure TForm1.BlendColor(AColor: TColor);
var
    r, g, b,
    r1, g1, b1,
    r2, g2, b2: Byte;
begin
    inc(CorCount);

    if ((CorCount mod 2) = 0) then
        Cor2 := AColor
    else
        Cor1 := AColor;

    r1 := GetRValue(Cor1);
    g1 := GetGValue(Cor1);
    b1 := GetBValue(Cor1);
    r2 := GetRValue(Cor2);
    g2 := GetGValue(Cor2);
    b2 := GetBValue(Cor2);

    r := (r2 div 2)+ (r1 div 2);
    g := (g2 div 2) + (g1 div 2);
    b := (b2 div 2) + (b1 div 2);

    Shape1.Brush.Color := RGB(r, g, b);
end;

procedure TForm1.CreateSelectShape;
var
    Img: TImage;
    I: Integer;
begin
    for I := low(IndexImg) to high(IndexImg) do
    begin
        Img := TImage(FindComponent('Image' + IntToStr(IndexImg[I])));
        if Assigned(Img) then
        begin
            with TShape.Create(Self) do
            begin
                Parent := Self;
                Brush.Style := bsClear;
                Pen.Color := clRed;
                Pen.Width := 2;
                Visible := False;
                Name := 'Shp' + IntToStr(IndexImg[I]);
                SetBounds(Img.Left, Img.Top, Img.Width, Img.Height);
            end;
        end;
    end;
end;

procedure TForm1.VisibleSelectShape(AImage: TImage);
var
    Index: String;
    Shp: TShape;
    I: Integer;
begin
    for I := low(IndexImg) to high(IndexImg) do
    begin
        Shp := TShape(FindComponent('Shp' + IntToStr(IndexImg[I])));
        if Assigned(Shp) and Assigned(ShapeSelect2) and (Shp <> ShapeSelect2) then
        begin
            Shp.Visible := False;
        end;
    end;

    Index := Copy(AImage.Name, 6, Length(AImage.Name));
    Shp := TShape(FindComponent('Shp' + Index));
    if Assigned(Shp) then
    begin
        Shp.Visible := True;
        ShapeSelect2 := Shp;
    end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LImprimir2.Visible := False;
  LImprimir1.Visible := True;
  LSalvar2.Visible := False;
  LSalvar1.Visible := True;
  ImgSobre1.Visible := True;
  ImgSobre2.Visible := False;
  ImgAjuda1.Visible := True;
  ImgAjuda2.Visible := False;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  x,y : integer;
begin
  Lista := TStringList.Create;
  y := GetDeviceCaps(Getdc(0),VERTRES);
  x := GetDeviceCaps(Getdc(0),HORZRES);
  XResolucao := X;
  YResolucao := Y;
  if ((X > 640) or (Y > 480)) then
  begin
    TrocaResolucao(640, 480);
  end;
  PicPath := ExtractFilePath(Application.Exename) + 'imagens';
  if ((Length(PicPath) > 0) and (PicPath[Length(PicPath)] <> '\')) then
    PicPath := PicPath + '\' ;
  CreateImageList(PicPath);

  ImgSair1.Picture.Bitmap.TransparentColor := clWhite;
  try
    for i := Low(Img) to ImgCount do
    begin
      Img[i] := TImage.Create (Self);
      Img[i].Parent := Self;
      Img[i].AutoSize := True;
      Img[i].Visible := False;
      Img[i].Picture.Bitmap.LoadFromFile(Lista.Strings[i - 1]);
    end;
  except on EFOpenError do
    ShowMessage('Não foi possível carregar outras imagens');
  end;
  Int := 0;
  IntImg := 1;
  CorCount := 0;
  Cor1 := clWhite;
  Cor2 := clWhite;
  CreateSelectShape;
  ShapeSelect2 := nil;
end;

procedure TForm1.Fechar1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ImgPrincipalMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Cor: Tcolor;
begin
  if (Timer1.Enabled = True) or (Timer2.Enabled = True) then
  begin
    ShowMessage('Imagem não disponível para pintura.');
  end
  else
    if (ImgPrincipal.Canvas.Pixels [X, Y] = clBlack) then
      ImgPrincipal.Canvas.Pixels [X, Y] := clBlack
    else
    begin
      Cor := ImgPrincipal.Canvas.Pixels [X, Y];
      ImgPrincipal.Canvas.Brush.Color := Shape1.Brush.Color;
      ImgPrincipal.Canvas.Brush.Style := bsSolid;
      ImgPrincipal.Canvas.Pen.Color := clNone;
      ImgPrincipal.Canvas.Pen.Style := psClear;
      ImgPrincipal.Canvas.FloodFill(X, Y, Cor, fsSurface);
    end;
  Img[IntImg].Picture.Bitmap := ImgPrincipal.Picture.Bitmap;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  VisibleSelectShape(Image3);
  BlendColor(clRed);
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
  VisibleSelectShape(Image5);
  BlendColor(clWhite);
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  VisibleSelectShape(Image4);
  BlendColor(clYellow);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  VisibleSelectShape(Image2);
  BlendColor(RGB(1,1,1));
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
  VisibleSelectShape(Image6);
  BlendColor(clGreen);
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
  VisibleSelectShape(Image7);
  BlendColor(clAqua);
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
  VisibleSelectShape(Image8);
  BlendColor(clSilver);
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
  VisibleSelectShape(Image9);
  BlendColor(clBlue);
end;

procedure TForm1.Image10Click(Sender: TObject);
begin
  VisibleSelectShape(Image10);
  BlendColor(clGray);
end;

procedure TForm1.Image12Click(Sender: TObject);
begin
  VisibleSelectShape(Image12);
  BlendColor(RGB(128,64,0));
end;

procedure TForm1.Image13Click(Sender: TObject);
begin
  VisibleSelectShape(Image13);
  BlendColor(RGB(255,128,192));
end;

procedure TForm1.Image14Click(Sender: TObject);
begin
  VisibleSelectShape(Image14);
  BlendColor(RGB(0,128,255));
end;

procedure TForm1.Image15Click(Sender: TObject);
begin
  VisibleSelectShape(Image15);
  BlendColor(RGB(255,128,0));
end;

procedure TForm1.Image19Click(Sender: TObject);
begin
  VisibleSelectShape(Image19);
  BlendColor(clTeal);
end;

procedure TForm1.Image18Click(Sender: TObject);
begin
  VisibleSelectShape(Image18);
  BlendColor(clFuchsia);
end;

procedure TForm1.Image17Click(Sender: TObject);
begin
  VisibleSelectShape(Image17);
  BlendColor(clLime);
end;

procedure TForm1.Image16Click(Sender: TObject);
begin
  VisibleSelectShape(Image16);
  BlendColor(clMaroon);
end;

procedure TForm1.Image22Click(Sender: TObject);
begin
  VisibleSelectShape(Image22);
  BlendColor(clPurple);
end;

procedure TForm1.Image21Click(Sender: TObject);
begin
  VisibleSelectShape(Image21);
  BlendColor(clNavy);
end;

procedure TForm1.Image20Click(Sender: TObject);
begin
  VisibleSelectShape(Image20);
  BlendColor(clOlive);
end;

procedure TForm1.LImprimir1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LImprimir2.Visible := True;
  LImprimir1.Visible := False;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if (IntImg < ImgCount) then
  begin
    Int := 0;
    Inc(IntImg);
    If (IntImg <= ImgCount) then
    begin
      if (Int > 100) then
        Timer1.Enabled := False
      else
        Timer1.Enabled := True;
    end;
    SpeedButton1.Enabled := False;
    SpeedButton2.Enabled := False;
    ImgPrincipal.Enabled := False;
  end;
end;


procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if (IntImg > Low(Img)) then
  begin
    Int := 0;
    Dec(IntImg);
    If (IntImg <= ImgCount) then
    begin
      if (Int > 100) then
        Timer2.Enabled := False
      else
        Timer2.Enabled := True;
    end;
    SpeedButton1.Enabled := False;
    SpeedButton2.Enabled := False;
    ImgPrincipal.Enabled := False;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  X, Y, W, H: Integer;
  R1: TRect;
begin
  W := ImgPrincipal.Width;
  H := ImgPrincipal.Height;
  SetRect(R1, 0, 0, W, H);
  if (W >= H) then
  begin
    X := MulDiv(W, Int, 100);
    R1.Left := w - x;
    ImgPrincipal.Canvas.StretchDraw(R1, Img[IntImg].Picture.Bitmap);
  end
  else
  begin
    Y := MulDiv(H, Int, 100);
    X := MulDiv(Y, W, H);
    R1.Left := w - x;
    ImgPrincipal.Canvas.StretchDraw(R1, Img[IntImg].Picture.Bitmap);
  end;
  Inc(Int);
  if (Int > 100) then
  begin
    Timer1.Enabled := False;
    SpeedButton1.Enabled := True;
    SpeedButton2.Enabled := True;
    ImgPrincipal.Enabled := True;
  end;
end;


procedure TForm1.Timer2Timer(Sender: TObject);
var
  X, Y, W, H: Integer;
  R1: TRect;
begin
  W := ImgPrincipal.Width;
  H := ImgPrincipal.Height;
  SetRect(R1, 0, 0, W, H);
  if (W >= H) then
  begin
    X := MulDiv(W, Int, 100);
    R1.Right := x;
    ImgPrincipal.Canvas.StretchDraw(R1, Img[IntImg].Picture.Bitmap);
  end
  else
  begin
    Y := MulDiv(H, Int, 100);
    X := MulDiv(Y, W, H);
    R1.Right := x;
    ImgPrincipal.Canvas.StretchDraw(R1, Img[IntImg].Picture.Bitmap);
  end;
  Inc(Int);
  if (Int > 100) then
  begin
    Timer2.Enabled := False;
    SpeedButton1.Enabled := True;
    SpeedButton2.Enabled := True;
    ImgPrincipal.Enabled := True;
  end;
end;

procedure TForm1.LSalvar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LSalvar2.Visible := True;
  LSalvar1.Visible := False;
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
  PrintImage(ImgPrincipal.Picture.GetNamePath);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TrocaResolucao(XResolucao, YResolucao);
end;

procedure TForm1.ImgSobre2Click(Sender: TObject);
begin
  MccsAbout1.Execute;
end;

procedure TForm1.ImgSobre1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ImgSobre1.Visible := False;
  ImgSobre2.Visible := True;
end;

procedure TForm1.ImgAjuda1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ImgAjuda1.Visible := False;
  ImgAjuda2.Visible := True;
end;

procedure TForm1.ImgSair1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Image23Click(Sender: TObject);
begin
  sd.DefaultExt := GraphicExtension(TBitmap);
  sd.Filter := GraphicFilter(TBitmap);
  if sd.Execute then
    imgPrincipal.Picture.Bitmap.SaveToFile(sd.FileName);
end;

procedure TForm1.ImgAjuda2Click(Sender: TObject);
begin
  Application.MessageBox('Em construção!', 'Pintin - Pintura Infantil',
    MB_OK + MB_ICONEXCLAMATION);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Lista.Free;
end;

end.
