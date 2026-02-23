{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Horse,
  Horse.CORS,
  SysUtils;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Pong');
end;

begin
  THorse.Use(CORS);

  THorse.Get('/ping', GetPing);

  THorse.Listen(9000);
end.