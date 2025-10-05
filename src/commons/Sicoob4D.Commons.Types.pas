unit Sicoob4D.Commons.Types;

interface

type
  TApiScope = (BOLETOS_CONSULTA, BOLETOS_ALTERACAO, BOLETOS_INCLUSAO);

  TApiType = (COBRANCA_BANCARIA);

  TEndPointBaseType = (BOLETO, BOLETO_SEGUNDAVIA);

  TApiScopeHelper = record helper for TApiScope
    function GetValue: string;
  end;

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

{ TApiScopeHelper }

function TApiScopeHelper.GetValue: string;
begin
  case Self of
    BOLETOS_CONSULTA: result := 'boletos_consulta';
    BOLETOS_ALTERACAO: result := 'boletos_alteracao';
    BOLETOS_INCLUSAO: result := 'boletos_inclusao';
  end;
end;

end.
