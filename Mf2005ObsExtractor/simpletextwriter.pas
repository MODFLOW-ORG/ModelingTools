unit SimpleTextWriter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, streamex;

type

  { TSimpleTextWriter }

  TSimpleTextWriter = class(TObject)
  private
    FFileName: string;
    FLines: TStringList;
    FLine: string;
  public
    Constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure Write(Value: string); overload;
    procedure Write(Value: double); overload;
    procedure WriteLn;
    procedure WriteLine(const Value: string); overload;
    procedure WriteLine(Value: Integer); overload;
  end;

  { TSimpleStreamReader }

  TSimpleStreamReader = class(TStreamReader)
  private
    function GetEndOfStream: Boolean;
  public
    constructor Create(const FileName: string); reintroduce;
    property EndOfStream: Boolean read GetEndOfStream;
  end;

  { TSimpleStreamWriter }

  TSimpleStreamWriter = class(TFileStream)
  public
    Constructor Create(const AFileName: string; Append: Boolean = False);
    procedure WriteLine(Value: Ansistring);
  end;

implementation

{ TSimpleStreamWriter }

constructor TSimpleStreamWriter.Create(const AFileName: string; Append: Boolean = False);
begin
  if Append then
  begin
    inherited Create(Filename, fmOpenWrite);
    Seek(0, soEnd);
  end
  else
  begin
    inherited Create(AFileName, fmCreate or fmShareDenyWrite);
  end;

end;

procedure TSimpleStreamWriter.WriteLine(Value: Ansistring);
begin
  Value := Value + sLineBreak;
  Write(Value[1], Length(Value)*SizeOf(AnsiChar));
end;

{ TSimpleStreamReader }

function TSimpleStreamReader.GetEndOfStream: Boolean;
begin
  result := IsEof;
end;

constructor TSimpleStreamReader.Create(const FileName: string);
begin
  inherited Create(TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite),
    1024, True);
end;

{ TSimpleTextWriter }

constructor TSimpleTextWriter.Create(const FileName: string);
begin
  FFileName := FileName;
  FLines := TStringList.Create;
  FLine := '';
end;

destructor TSimpleTextWriter.Destroy;
begin
  if FLine <> '' then
  begin
    WriteLn;
  end;
  FLines.SaveToFile(FFileName);
  FLines.Free;
end;

procedure TSimpleTextWriter.Write(Value: string);
begin
  FLine := FLine + Value;
end;

procedure TSimpleTextWriter.Write(Value: double);
begin
  Write(FloatToStr(Value));
end;

procedure TSimpleTextWriter.WriteLn;
begin
  FLines.Add(FLine);
  FLine := '';
end;

procedure TSimpleTextWriter.WriteLine(const Value: string);
begin
  Write(Value);
  WriteLn;
end;

procedure TSimpleTextWriter.WriteLine(Value: Integer);
begin
  Write(Value);
  WriteLn;
end;

end.

