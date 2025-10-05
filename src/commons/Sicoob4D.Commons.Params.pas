unit Sicoob4D.Commons.Params;

interface

uses
  Sicoob4D.Commons.Interfaces,
  System.Generics.Collections,
  System.SysUtils;

type
  TSicoobParams = class(TInterfacedObject, iSicoobParams)
  private
    FParams: TDictionary<string, Variant>;
    constructor CreatePrivate;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Key: string; const Value: Variant): iSicoobParams;
    function &End: TDictionary<string, Variant>;
    class function New: iSicoobParams;
  end;

implementation

{ TSicoobParams }

function TSicoobParams.Add(const Key: string; const Value: Variant): iSicoobParams;
begin
  Result := Self;
  FParams.Add(Key,Value);
end;

function TSicoobParams.&End: TDictionary<string, Variant>;
begin
  Result := FParams;
end;

constructor TSicoobParams.Create;
begin
  raise Exception.Create('Para obter uma instancia, utiliza a função New');
end;

constructor TSicoobParams.CreatePrivate;
begin
  inherited Create;
  FParams := TDictionary<string, Variant>.create;
end;

destructor TSicoobParams.Destroy;
begin
  inherited;
end;

class function TSicoobParams.New: iSicoobParams;
begin
  result := Self.CreatePrivate;
end;

end.
