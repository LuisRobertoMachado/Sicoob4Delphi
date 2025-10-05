unit Sicoob4D.Resources.Impl;

interface

uses
  Sicoob4D.Commons.Interfaces,
  Sicoob4D.Commons.Types,
  Sicoob4D.Resources.Interfaces,
  System.Generics.Collections,
  System.JSON,
  Sicoob4D.Auth.Interfaces;

type
  TSicoob = class(TInterfacedObject, iSicoob)
  private
    FBody: string;
    [weak]
    FParent: iAuthConfig;
    FParams: TDictionary<string, Variant>;
    FHttpClient: iHttpClient;
    function GetFullURL(const Api: TApiType; const Endpoint: TEndPointBaseType;
      const Id: string = ''): string; Overload;
    function GetFullURL(const Api, Endpoint: string; Id: string = '')
      : string; OVerload;
    procedure BeforeExecute;
    constructor CreatePrivate(Parent: iAuthConfig);
  public
    constructor Create;
    destructor Destroy; override;
    function _Create(const Api: TApiType; const Endpoint: TEndPointBaseType)
      : iSicoob; Overload;
    function _Create(const Api: TApiType; const Endpoint: string)
      : iSicoob; Overload;
    function Get(const Api: TApiType; const Endpoint: TEndPointBaseType;
      const Id: string): iSicoob; Overload;
    function Get(const Api: TApiType; const Endpoint, Id: string)
      : iSicoob; Overload;
    function GetAll(const Api: TApiType; const Endpoint: TEndPointBaseType)
      : iSicoob; Overload;
    function GetAll(const Api: TApiType; const Endpoint: string)
      : iSicoob; Overload;
    function Update(const Api: TApiType; const Endpoint: TEndPointBaseType;
      const Id: string): iSicoob; Overload;
    function Update(const Api: TApiType; const Endpoint, Id: string)
      : iSicoob; OVerload;
    function Body(Value: string): iSicoob; Overload;
    function Body(Value: TJSONValue): iSicoob; Overload;
    function Params(const Value: iSicoobParams): iSicoob;
    function Content: String;
    function StatusCode: integer;
    class function New(Parent: iAuthConfig): iSicoob;
  end;

implementation

uses
  Sicoob4D.Resources.RestHttpClient,
  System.SysUtils;

{ TSicoob }

procedure TSicoob.BeforeExecute;
var
  LPair: TPair<string, Variant>;
begin
  FHttpClient.Authentication(FParent.Token).AddHeader('client_id',
    FParent.ClientId);

  if Assigned(FParams) then
    for LPair in FParams do
    begin
      FHttpClient.AddParam(LPair.Key, LPair.Value);
    end;

  if not FBody.IsEmpty then
    FHttpClient.Body(FBody);
end;

function TSicoob.Body(Value: TJSONValue): iSicoob;
begin
  Result := Self;
  if Assigned(Value) and (Value is TJsonObject) then
  begin
    FBody := TJsonObject(Value).ToJSON;
    Value.Free;
  end;
end;

function TSicoob.Body(Value: string): iSicoob;
begin
  Result := Self;
  FBody := Value;
end;

function TSicoob.Content: String;
begin
  Result := FHttpClient.Content;
end;

constructor TSicoob.Create;
begin
  raise Exception.Create('Para obter uma instancia, utiliza a função New');
end;

constructor TSicoob.CreatePrivate(Parent: iAuthConfig);
begin
  inherited Create;
  FParent := Parent;
  FHttpClient := THttpClient.New;
end;

destructor TSicoob.Destroy;
begin
  if Assigned(FParams) then
    FParams.Free;
  inherited;
end;

function TSicoob.Get(const Api: TApiType; const Endpoint: TEndPointBaseType;
  const Id: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Get(GetFullURL(Api, Endpoint, Id));
end;

function TSicoob.GetAll(const Api: TApiType;
  const Endpoint: TEndPointBaseType): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Get(GetFullURL(Api, Endpoint));
end;

function TSicoob.GetFullURL(const Api: TApiType;
  const Endpoint: TEndPointBaseType; const Id: string): string;
begin
  Result := GetFullURL(Api.GetValue, Endpoint.GetValue, Id);
end;

class function TSicoob.New(Parent: iAuthConfig): iSicoob;
begin
  Result := Self.CreatePrivate(Parent);
end;

function TSicoob.Params(const Value: iSicoobParams): iSicoob;
begin
  Result := Self;
  FParams := Value.&End;
end;

function TSicoob.StatusCode: integer;
begin
  Result := FHttpClient.StatusCode;
end;

function TSicoob.Update(const Api: TApiType; const Endpoint,
  Id: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Put(GetFullURL(Api.GetValue, Endpoint,Id));
end;

function TSicoob.Update(const Api: TApiType; const Endpoint: TEndPointBaseType;
  const Id: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Put(GetFullURL(Api, Endpoint,Id));
end;

function TSicoob._Create(const Api: TApiType; const Endpoint: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Post(GetFullURL(Api.GetValue, Endpoint));
end;

function TSicoob._Create(const Api: TApiType;
  const Endpoint: TEndPointBaseType): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Post(GetFullURL(Api, Endpoint));
end;

function TSicoob.Get(const Api: TApiType; const Endpoint, Id: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Get(GetFullURL(Api.GetValue, Endpoint, Id));
end;

function TSicoob.GetAll(const Api: TApiType; const Endpoint: string): iSicoob;
begin
  Result := Self;
  BeforeExecute;
  FHttpClient.Get(GetFullURL(Api.GetValue, Endpoint));
end;

function TSicoob.GetFullURL(const Api, Endpoint: string; Id: string): string;
begin
  Result := FParent.BaseUrl + Api + Endpoint;
  if not Id.IsEmpty then
    Result := Result + '\' + Id;
end;

end.
