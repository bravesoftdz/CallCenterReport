unit func;

interface

uses Windows, System.Classes, System.SysUtils, Vcl.Grids, Vcl.Graphics, System.DateUtils, RegularExpressions, System.IniFiles,
  System.Win.Registry, TDictionary, Generics.Collections, Vcl.Forms, System.Variants, System.Win.ComObj;

Type
  //: Tipo de Dat de la columna por la que queremos ordenar.
  TGridData = (gdString, gdInteger, gdFloat, gdTime);
  //: Tipos de ordenación.
  TSortOrder = (soASC, soDESC);

  TArrayOfString = array of String;

const
  cSegundosPorDia = 24 * 60 * 60;
  //cSegundosPorDia = 60;


procedure Sortgrid(Grid : TStringGrid; SortCol:integer);
procedure marcaordgrid(Grid : TStringGrid; col:integer);
function SplitString(const aSeparator, aString: String; aMax: Integer = 0): TArrayOfString;
function SegToFormatHour(Segundos: Integer): String;
function HourToFormatSeg(tirmpo:string): string;
function StringsToStr(list: TStrings): string;
procedure SortStringGrid(var GenStrGrid: TStringGrid;
    ThatCol: Integer;
    ColData:TGridData=gdString;
    SortOrder:TSortOrder=soASC);
procedure GuardarRegistroSistema(Sender: TObject);
procedure CargarRegistroSistema(Sender: TObject);
function RefToCell(ARow, ACol: Integer): string;
function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string): Boolean;
procedure XlsBeginStream(XlsStream: TStream; const BuildNumber: Word);
procedure XlsEndStream(XlsStream: TStream);
procedure XlsWriteCellLabel(XlsStream: TStream; const ACol, ARow: Word;
  const AValue: string);
procedure XlsWriteCellNumber(XlsStream: TStream; const ACol,
  ARow: Word; const AValue: Double);
procedure XlsWriteCellRk(XlsStream: TStream; const ACol, ARow: Word;
  const AValue: Integer);
function AScan(const Ar: array of string; const Value: string): Integer; overload;
function arrayunicostr(int: TArrayofstring): TArrayofstring;
procedure log(Mensaje: String);


var
  CXlsBof   : array[0..5] of Word = ($809, 8, 00, $10, 0, 0);
  CXlsEof   : array[0..1] of Word = ($0A, 00);
  CXlsLabel : array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  CXlsRk    : array[0..4] of Word = ($27E, 10, 0, 0, 0);
  SettingsFile: TCustomIniFile;
  BasedeDatos, Parser, Theme, Path: string;

implementation

uses
  Main;

function AScan(const Ar: array of string; const Value: string): Integer; overload;
var
  i: Integer;
begin
  Result := -1;
  for i := Low(Ar) to High(Ar) do
    if SameText(Ar[i], Value) then
    begin
      Result := i;
      Break
    end;
end;

function RefToCell(ARow, ACol: Integer): string;
begin
  Result := Chr(Ord('A') + ACol - 1) + IntToStr(ARow);
end;

function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string): Boolean;
const
  xlWBATWorksheet = -4167;
var
  XLApp, Sheet, Data: Variant;
  i, j: Integer;
begin
  // Prepare Data
  Data := VarArrayCreate([1, AGrid.RowCount, 1, AGrid.ColCount], varVariant);
  for i := 0 to AGrid.ColCount - 1 do
    for j := 0 to AGrid.RowCount - 1 do
      Data[j + 1, i + 1] := AGrid.Cells[i, j];
  // Create Excel-OLE Object
  Result := False;
  XLApp := CreateOleObject('soffice.Application');
  try
    // Hide Excel
    XLApp.Visible := False;
    // Add new Workbook
    XLApp.Workbooks.Add(xlWBatWorkSheet);
    Sheet := XLApp.Workbooks.WorkSheets[1];
    Sheet.Name := ASheetName;
    // Fill up the sheet
    Sheet.Range[RefToCell(1, 1), RefToCell(AGrid.RowCount,
      AGrid.ColCount)] := Data;
    // Save Excel Worksheet
    try
      XLApp.Workbooks.SaveAs(AFileName);
      Result := True;
    except
      // Error ?
    end;
  finally
    // Quit Excel
    if not VarIsEmpty(XLApp) then
    begin
      XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLAPP := Unassigned;
      Sheet := Unassigned;
    end;
  end;
end;


function SplitString(const aSeparator, aString: String; aMax: Integer = 0): TArrayOfString;
var
  i, strt, cnt: Integer;
  sepLen: Integer;

  procedure AddString(aEnd: Integer = -1);
  var
    endPos: Integer;
  begin
    if (aEnd = -1) then
      endPos := i
    else
      endPos := aEnd + 1;

    if (strt < endPos) then
      result[cnt] := Copy(aString, strt, endPos - strt)
    else
      result[cnt] := '';

    Inc(cnt);
  end;

begin
  if (aString = '') or (aMax < 0) then
  begin
    SetLength(result, 0);
    EXIT;
  end;

  if (aSeparator = '') then
  begin
    SetLength(result, 1);
    result[0] := aString;
    EXIT;
  end;

  sepLen := Length(aSeparator);
  SetLength(result, (Length(aString) div sepLen) + 1);

  i     := 1;
  strt  := i;
  cnt   := 0;
  while (i <= (Length(aString)- sepLen + 1)) do
  begin
    if (aString[i] = aSeparator[1]) then
      if (Copy(aString, i, sepLen) = aSeparator) then
      begin
        AddString;

        if (cnt = aMax) then
        begin
          SetLength(result, cnt);
          EXIT;
        end;

        Inc(i, sepLen - 1);
        strt := i + 1;
      end;

    Inc(i);
  end;

  AddString(Length(aString));

  SetLength(result, cnt);
end;

function SegToFormatHour(Segundos: Integer): String;
var
  dias,
  horas,
  minutos: Integer;
begin
  dias := Segundos div 86400;
  horas :=  Segundos div 3600;
  minutos := Segundos div 60 mod 60;
  //minutos := minutos * 24;
  segundos := Segundos mod 60;
  Result:= format('%3d:%2d:%2d', [horas, minutos, segundos]);
  //Result1:= EncodeTime(horas, minutos, segundos, 0);
  //Result := TimeToStr(Result1);
end;

function HourToFormatSeg(tirmpo:String): string;
var
  partes: TArrayofString;
  conttirmpo:integer;
begin

  partes := SplitString(':', tirmpo);
  tirmpo := Trim(partes[0])+':'+Trim(partes[1])+':'+Trim(partes[2]);
  conttirmpo:= (StrToInt(partes[0])*3600)+(StrToInt(partes[1])*60)+StrToInt(partes[2]);

  Result := inttostr(conttirmpo);
end;

function StringsToStr(list: TStrings): string;
var i: integer;
begin
   result := '';
   for i := 0 to list.Count - 1 do
   begin
     if i > 0 then
       result := result + ',';
     //end{if};
     result := result + list[i];
   end{for};
end;

procedure Sortgrid(Grid : TStringGrid; SortCol:integer);
var
   i,j  : Integer;
   temp : TStringList;
begin
Temp:= TStringList.Create;
with Grid
do begin
   for i := FixedRows to RowCount - 2
   do begin
      for j:= i+1 to rowcount-1
      do begin
         if AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) > 0
         then begin
              temp.assign(rows[j]);
              rows[j].assign(rows[i]);
              rows[i].assign(temp);
              end;
         end;
      end;
   end;
temp.free;
end;

procedure marcaordgrid(Grid : TStringGrid; col:integer);
var
  i,j: Integer;
  //triangulo:tbitmap;
begin

  grid.Refresh;
  //triangulo:=tbitmap.Create;
  i:=(col*(grid.DefaultColWidth))+(grid.DefaultColWidth div 2);
  j:=((grid.DefaultRowHeight div 3)*4);
  grid.Canvas.MoveTo(i,j);
  grid.Canvas.LineTo(i+5,j-5);
  grid.Canvas.LineTo(i-5,j-5);
  grid.Canvas.LineTo(i,j);

  //Grid.Font.Color := clGreen;   // la pintamos de azul
  //Grid.Font.Style := [fsBold];  // y negrita

end;

procedure SortStringGrid(var GenStrGrid: TStringGrid;
    ThatCol: Integer;
    ColData:TGridData=gdString;
    SortOrder:TSortOrder=soASC);
const
  TheSeparator = '@';
var
  CountItem, I, J, K, ThePosition: integer;
  MyList: TStringList;
  MyString, TempString: string;
  str:string;
  vali:Integer;
  valf:Double;
begin
  CountItem := GenStrGrid.RowCount;
  MyList := TStringList.Create;
  MyList.Sorted := False;
  try
    begin
      for I := 1 to (CountItem - 1) do begin
        Str := GenStrGrid.Rows[I].Strings[ThatCol];
        //ColData:= Grd.Val;

        if (ColData = gdInteger) then begin
          vali := StrToIntDef(Str, 0);
          Str := Format('%*d', [15,vali]);
        end;
        if (ColData = gdFloat) then begin
          valf := StrToFloat(Str);
          Str := Format('%15.2f',[valf]);
        end;
        if (ColData = gdTime) then begin
          if (Str<>'') and (Str<>' ') then begin
            Str := HourToFormatSeg(Str);
            vali := StrToIntDef(Str, 0);
            Str := Format('%*d', [15,vali]);
            //Str := IntToStr(d+(h * 60 * 60)+(m * 60)+(s));
          end;
        end;
        MyList.Add(Str + TheSeparator + GenStrGrid.Rows[I].Text);
      end;
      Mylist.Sort;

      for K := 1 to Mylist.Count do begin
        MyString := MyList.Strings[(K - 1)];
        ThePosition := Pos(TheSeparator, MyString);
        TempString := '';
        {Eliminate the Text of the column on which we have
          sorted the StringGrid}
        TempString := Copy(MyString, (ThePosition + 1), Length(MyString));
        MyList.Strings[(K - 1)] := '';
        MyList.Strings[(K - 1)] := TempString;
      end;

      if (SortOrder = soASC) then begin
        for J := 1 to (CountItem - 1) do begin
            GenStrGrid.Rows[J].Text := MyList.Strings[(J - 1)];
        end;
      end
      else begin
        for J := 1 to (CountItem - 1) do begin
          I := (CountItem - J);
          GenStrGrid.Rows[I].Text := MyList.Strings[(J - 1)];
        end;
      end;
    end;

  finally
    MyList.Free;
  end;
end;

procedure GuardarRegistroSistema(Sender: TObject);
var
  SettingsFile: TCustomIniFile;
begin
  { Open an instance. }
  SettingsFile := TRegistryIniFile.Create('Software\' + Application.Title);

  {
  Store current form properties to be used in later sessions.
  }
  try

    With TForm(Sender) do begin
      SettingsFile.WriteInteger (Name, 'Top', Top);
      SettingsFile.WriteInteger (Name, 'Left', Left);
      SettingsFile.WriteInteger (Name, 'Width', Width);
      SettingsFile.WriteInteger (Name, 'Height', Height);
      //SettingsFile.WriteString  (Name, 'Caption', Caption);
      SettingsFile.WriteBool    (Name, 'InitMax', WindowState = wsMaximized );
      SettingsFile.WriteDateTime(Name, 'LastRun', Now);
      SettingsFile.WriteString  (Name, 'Theme', Theme);
      SettingsFile.WriteString  (Name, 'Path', GetEnvironmentVariable('USERPROFILE') + '\Desktop\'+'CallCenterReport');
    end;

  finally
    SettingsFile.Free;
  end;

end;

procedure CargarRegistroSistema(Sender: TObject);
begin
  { Open an instance. }
  SettingsFile := TRegistryIniFile.Create('Software\' + Application.Title);


 try
    {
    Read all saved values from the last session. The section name
    is the name of the form. Also use the form's properties as defaults.
    }
    With TForm(Sender) do begin
      Top     := SettingsFile.ReadInteger(Name, 'Top', Top );
      Left    := SettingsFile.ReadInteger(Name, 'Left', Left );
      Width   := SettingsFile.ReadInteger(Name, 'Width', Width );
      Height  := SettingsFile.ReadInteger(Name, 'Height', Height );
      //Caption := SettingsFile.ReadString (Name, 'Caption', Caption);

      { Load last window state. }
      case SettingsFile.ReadBool(Name, 'InitMax', WindowState = wsMaximized) of
        true : WindowState := wsMaximized;
        false: WindowState := wsNormal;
      end;
      BaseDeDatos:=SettingsFile.ReadString(Name, 'BaseDeDatos', '');
      Theme :=SettingsFile.ReadString(Name, 'Theme', '');
      Path :=SettingsFile.ReadString(Name, 'Path', '');
      Parser :=SettingsFile.ReadString(Name, 'Parser', '');
      //Form1.ComboBox1.ItemIndex := Form1.ComboBox1.Items.IndexOf(SettingsFile.ReadString(Name, 'Theme', ''));

    end;


  finally
    FreeAndNil(SettingsFile);
  end;

end;

function arrayunicostr(int: TArrayofstring): TArrayofstring;
var
  new:TArrayofstring;
  i, FoundIndex:integer;
begin
  TArray.Sort<string>(Int);
  for I := Low(Int) to High(int) do
    if not (TArray.BinarySearch<string>(New,Int[i],FoundIndex)) and (int[i] <> '') then
      begin
        SetLength(New,FoundIndex+1);
        New[FoundIndex]:=Int[i];
      end;

  Result:=New;
end;

procedure XlsBeginStream(XlsStream: TStream; const BuildNumber: Word);
begin
//  CXlsBof[4] := BuildNumber;
  XlsStream.WriteBuffer(CXlsBof, SizeOf(CXlsBof));
end;

procedure XlsEndStream(XlsStream: TStream);
begin
  XlsStream.WriteBuffer(CXlsEof, SizeOf(CXlsEof));
end;


procedure XlsWriteCellRk(XlsStream: TStream;
                           const ACol, ARow: Word;
                           const AValue: Integer);
var
  V: Integer;
begin
  CXlsRk[2] := ARow;
  CXlsRk[3] := ACol;
  XlsStream.WriteBuffer(CXlsRk, SizeOf(CXlsRk));
  V := (AValue shl 2) or 2;
  XlsStream.WriteBuffer(V, 4);
end;

procedure XlsWriteCellNumber(XlsStream: TStream;
                             const ACol, ARow: Word;
                             const AValue: Double);
begin
  CXlsNumber[2] := ARow;
  CXlsNumber[3] := ACol;
  XlsStream.WriteBuffer(CXlsNumber, SizeOf(CXlsNumber));
  XlsStream.WriteBuffer(AValue, 8);
end;


procedure XlsWriteCellLabel(XlsStream: TStream;
                            const ACol, ARow: Word;
                            const AValue: string);
var
  L: Word;
begin

  L := Length(AValue);
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := ARow;
  CXlsLabel[3] := ACol;
  CXlsLabel[5] := L;
  XlsStream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  XlsStream.WriteBuffer(Pointer(AValue)^, L);
end;

procedure log(Mensaje: String);
var
  F: TextFile;
  Filename: String;
  Mutex: THandle;
  SearchRec: TSearchRec;
begin
  // Insertamos la fecha y la hora
  Mensaje:= FormatDateTime('[ddd dd mmm, hh:nn] ', Now) + Mensaje;
  // El nombre del archivo es igual al del ejecutable, pero con la extension .log
  Filename:= ChangeFileExt(ParamStr(0),'.log');
  // Creamos un mutex, usando como identificador unico la ruta completa del ejecutable
  Mutex:= CreateMutex(nil,FALSE,
    PChar(StringReplace(ParamStr(0),'\','/',[rfReplaceAll])));
  if Mutex <> 0 then
  begin
    // Esperamos nuestro turno para escribir
    WaitForSingleObject(Mutex, INFINITE);
    try
      // Comprobamos el tamaño del archivo
      if FindFirst(Filename,faAnyFile,SearchRec) = 0 then
      begin
        // Si es mayor de un mega lo copiamos a (nombre).log.1
        if SearchRec.Size > (1024*1024) then
          MoveFileEx(PChar(Filename),PChar(Filename + '.1'),
            MOVEFILE_REPLACE_EXISTING);
        FindClose(SearchRec);
      end;
      try
        AssignFile(F, Filename);
        {$I-}
          Append(F);
        if IOResult <> 0 then
          Rewrite(F);
        {$I+}
        if IOResult = 0 then
        begin
          // Escribimos el mensaje
          Writeln(F,Mensaje);
          CloseFile(F);
        end;
      except
        //
      end;
    finally
      ReleaseMutex(Mutex);
      CloseHandle(Mutex);
    end;
  end;
end;

end.
