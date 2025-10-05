unit Sicoob4D.Auth.Impl;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  Sicoob4D.Auth.Interfaces,
  Sicoob4D.Commons.Types,
  IdHTTP, IdSSLOpenSSL, IdGlobal;

type
  TAuthConfig = class(TInterfacedObject, iAuthConfig)
  private
    FAPI: TApiType;
    FBaseUrl: string;
    FClientId: string;
    FToken: string;
    FScope: TArray<TApiScope>;
    FCertFile: string;
    FKeyFile: string;
    FTokenExpireAt: TDateTime;
    constructor CreatePrivate;
    function IsTokenValide: boolean;
    function RenewToken: boolean;
    function BuildScopeString: string;
  public
    constructor Create;
    destructor Destroy; override;
    function BaseUrl(const Value: String): iAuthConfig; overload;
    function BaseUrl: String; overload;
    function ClientId(const Value: string): iAuthConfig; Overload;
    function ClientId: string; Overload;
    function CertFile(const Value: string): iAuthConfig;Overload;
    function CertFile: string;Overload;
    function KeyFile(const Value: string): iAuthConfig;Overload;
    function KeyFile: string;Overload;
    function Scope(const Values: array of TApiScope): iAuthConfig;
    function Token: string; Overload;
    class function New: iAuthConfig;
  end;

implementation

uses
  System.JSON, System.DateUtils;

{ TAuthConfig }

function TAuthConfig.BaseUrl(const Value: String): iAuthConfig;
begin
  Result := Self;
  FBaseUrl := Value;
end;

function TAuthConfig.BaseUrl: String;
begin
  Result := FBaseUrl;
end;

function TAuthConfig.BuildScopeString: string;
var
  S: TApiScope;
  LScopes: TArray<string>;
begin
  for S in FScope do
    LScopes := LScopes + [S.GetValue];

  Result := string.Join(' ', LScopes);
end;

function TAuthConfig.CertFile(const Value: string): iAuthConfig;
begin
  Result := Self;
  FCertFile := Value;
end;

function TAuthConfig.ClientId(const Value: string): iAuthConfig;
begin
  Result := Self;
  FClientId := Value;
end;

function TAuthConfig.CertFile: string;
begin
  Result := FCertFile;
end;

function TAuthConfig.ClientId: string;
begin
  Result := FClientId;
end;

constructor TAuthConfig.Create;
begin
  raise Exception.Create('Use TAuthConfig.New para criar uma instância');
end;

constructor TAuthConfig.CreatePrivate;
begin
  inherited Create;
end;

destructor TAuthConfig.Destroy;
begin
  inherited;
end;

function TAuthConfig.IsTokenValide: boolean;
begin
  Result := (FToken <> '') and (Now < FTokenExpireAt);
end;

function TAuthConfig.KeyFile: string;
begin
  Result := FKeyFile;
end;

function TAuthConfig.KeyFile(const Value: string): iAuthConfig;
begin
  Result := Self;
  FKeyFile := Value;
end;

class function TAuthConfig.New: iAuthConfig;
begin
  Result := Self.CreatePrivate;
end;

function TAuthConfig.RenewToken: boolean;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Params: TStringList;
  Response: string;
  ResponseJSON: TJSONObject;
  ExpireSec: Integer;
begin
  Result := False;
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Params := TStringList.Create;
  try
    // Configura SSL com o certificado do cliente
    SSL.SSLOptions.Method := sslvTLSv1_2;
    SSL.SSLOptions.Mode := sslmUnassigned;
    SSL.SSLOptions.VerifyMode := [];
    SSL.SSLOptions.VerifyDepth := 0;

    SSL.SSLOptions.CertFile := FCertFile;
    SSL.SSLOptions.KeyFile := FKeyFile;

    HTTP.IOHandler := SSL;
    Http.Request.ContentType := 'application/x-www-form-urlencoded';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.CharSet := 'utf-8';

    Params.Add('grant_type=client_credentials');
    Params.Add('client_id=' + FClientId);
    Params.Add('scope=' + BuildScopeString);

    // Faz o POST
    Response := HTTP.Post('https://auth.sicoob.com.br/auth/realms/cooperado/protocol/openid-connect/token', Params);

    // Processa o retorno
    ResponseJSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    if Assigned(ResponseJSON) then
    begin
      FToken := ResponseJSON.GetValue<string>('access_token', '');
      ExpireSec := ResponseJSON.GetValue<Integer>('expires_in', 300);
      FTokenExpireAt := IncSecond(Now, ExpireSec - 10); // margem de 10s
      Result := True;
    end;
  finally
    Params.Free;
    ResponseJSON.Free;
    HTTP.Free;
    SSL.Free;
  end;
end;

function TAuthConfig.Scope(const Values: array of TApiScope): iAuthConfig;
var
  I: Integer;
begin
  Result := Self;
  SetLength(FScope, Length(Values));
  for I := 0 to High(Values) do
    FScope[I] := Values[I];
end;

function TAuthConfig.Token: string;
begin
  if not IsTokenValide then
    if not RenewToken then
      raise Exception.Create('Falha ao renovar o token.');

  Result := FToken;
end;

end.

