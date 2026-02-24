program JoistAPI;

{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  sysutils,
  fpjson,
  jsonparser,
  Horse,
  Horse.CORS;

procedure CalculateJoist(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  ReqBody: TJSONObject;
  ResBody: TJSONObject;
  Span: Double;
  Designation: string;
begin
  ReqBody := TJSONObject(GetJSON(Req.Body));
  try
    Span := ReqBody.Get('span', 0.0);

    if Span <= 20 then
      Designation := '10K1'
    else
      Designation := '12K3';

    ResBody := TJSONObject.Create;
    ResBody.Add('recommendedJoist', Designation);

    Res.Send(ResBody.AsJSON);
  finally
    ReqBody.Free;
    ResBody.Free;
  end;
end;

begin
  THorse.Use(CORS);

  THorse.Post('/calculate-joist', CalculateJoist);

  WriteLn('Joist API listening on port 9000');
  THorse.Listen(9000);
end.