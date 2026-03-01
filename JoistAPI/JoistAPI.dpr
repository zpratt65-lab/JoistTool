program JoistAPI;

{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  sysutils, fpjson, jsonparser, Horse, Horse.CORS;

type
  TJoistRequest = record
    Series: string;
    Methodology: string; // ASD or LRFD
    Span: Double;
    DeadLoad: Double;
    LiveLoad: Double;
    Spacing: Double;
  end;

procedure AuthenticateRequest(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  ApiKey: string;
  ProvidedKey: string;
begin
  ApiKey := GetEnvironmentVariable('API_KEY');
  if ApiKey = '' then
    ApiKey := 'dev-key-change-in-production'; // Default for development
  
  ProvidedKey := Req.Headers['X-API-Key'];
  
  if ProvidedKey <> ApiKey then
  begin
    Res.Status(401);
    Res.Send('{"error": "Unauthorized: Invalid or missing API key"}')
  end
  else
  begin
    Next();
  end;
end;

procedure CalculateJoist(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  ReqJson: TJSONObject;
  ResJson: TJSONObject;
  Inputs: TJoistRequest;
  TotalDesignLoad: Double;
begin
  ReqJson := TJSONObject(GetJSON(Req.Body));
  try
    Inputs.Series := ReqJson.Get('joist_series', 'K');
    Inputs.Methodology := ReqJson.Get('design_methodology', 'ASD');
    Inputs.Span := ReqJson.Get('span', 0.0);
    Inputs.DeadLoad := ReqJson.Get('dead_load', 0.0);
    Inputs.LiveLoad := ReqJson.Get('live_load', 0.0);
    Inputs.Spacing := ReqJson.Get('joist_spacing', 0.0);

    // Engineering Logic: Total Design Load (PLF)
    // Formula: (Dead Load + Live Load) * Spacing
    TotalDesignLoad := (Inputs.DeadLoad + Inputs.LiveLoad) * Inputs.Spacing;
    
    // In LRFD, loads are typically factored (1.2D + 1.6L)
    // This is a simplified mock of that behavior
    if Inputs.Methodology = 'LRFD' then
      TotalDesignLoad := (Inputs.DeadLoad * 1.2) + (Inputs.LiveLoad * 1.6) * Inputs.Spacing;

    ResJson := TJSONObject.Create;
    
    // Mocking the Selection Logic
    if TotalDesignLoad < 250 then
    begin
      ResJson.Add('joist_designation', '12K1');
      ResJson.Add('joist_self_weight', 5.0);
      ResJson.Add('bridging_rows_required', 2);
      ResJson.Add('min_bearing_seat_depth', 2.5);
    end
    else
    begin
      ResJson.Add('joist_designation', '16K3');
      ResJson.Add('joist_self_weight', 6.5);
      ResJson.Add('bridging_rows_required', 3);
      ResJson.Add('min_bearing_seat_depth', 2.5);
    end;

    ResJson.Add('total_safe_load', TotalDesignLoad + 50); // Mock safe load capacity
    
    Res.Send(ResJson.AsJSON);
  finally
    ReqJson.Free;
    ResJson.Free;
  end;
end;

begin
  THorse.Use(CORS);
  THorse.Use(AuthenticateRequest);
  THorse.Post('/calculate-joist', CalculateJoist);
  THorse.Listen(9000);
end.