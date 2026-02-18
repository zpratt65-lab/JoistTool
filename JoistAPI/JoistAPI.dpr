uses
  Horse, System.JSON;

begin
  THorse.Post('/calculate-joist',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Body: TJSONObject;
      Span: Double;
      Designation: string;
    begin
      Body := Req.Body<TJSONObject>;
      Span := Body.GetValue<Double>('span', 0);

      // Simple New Millennium Logic Mock: 
      // If span < 20ft, use 10K1. If > 20ft, use 12K3.
      if Span <= 20 then
        Designation := '10K1'
      else
        Designation := '12K3';

      Res.Send(TJSONObject.Create(TJSONPair.Create('recommendedJoist', Designation)));
    end);

  THorse.Listen(9000);
end.