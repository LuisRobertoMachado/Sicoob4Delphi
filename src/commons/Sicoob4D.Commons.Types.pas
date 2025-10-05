unit Sicoob4D.Commons.Types;

interface

type
  TApiType = (COBRANCA_BANCARIA);

  TEndPointBaseType = (BOLETO, BOLETO_SEGUNDAVIA);

  TApiTypeHelper = record helper for TApiType
    function GetValue: string;
  end;

  TEndPointBaseTypeHelper = record helper for TEndPointBaseType
    function GetValue: string;
  end;

implementation

{ TApiTypeHelper }

function TApiTypeHelper.GetValue: string;
begin
  case Self of
    COBRANCA_BANCARIA: Result := '/cobranca-bancaria/v3';
  end;
end;

{ TEndPointBaseTypeHelper }

function TEndPointBaseTypeHelper.GetValue: string;
begin
  case Self of
    BOLETO: Result := '/boletos';
    BOLETO_SEGUNDAVIA: Result := '/boletos/segunda-via';
  end;
end;

end.
