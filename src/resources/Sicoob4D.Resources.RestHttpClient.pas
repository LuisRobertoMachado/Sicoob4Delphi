unit Sicoob4D.Resources.RestHttpClient;

interface

uses
  System.SysUtils,
  System.Classes,
  IdHTTP,
  IdSSLOpenSSL,
  IdGlobal,
  Sicoob4D.Resources.Interfaces,
  System.Generics.Collections;

type
  THttpClient = class(TInterfacedObject, iHttpClient)
  private
    FHTTP: TIdHTTP;
    FSSL: TIdSSLIOHandlerSocketOpenSSL;
    FHeaders: TDictionary<string, string>;
    FParams: TDictionary<string, string>;
    FBody: string;
    FResponse: string;
    FStatusCode: Integer;

    FCertFile: string;
    FKeyFile: string;
    FRootCertFile: string;
    FPfxFile: string;
    FPfxPassword: string;

    constructor CreatePrivate;
    procedure ConfigurarCertificado;
    procedure ApplyHeaders;
    function EncodeParams: string;
  public
    constructor Create;
    destructor Destroy; override;

    // Interface methods
    function AddHeader(const Key, Value: String): iHttpClient;
    function AddParam(const Key, Value: String): iHttpClient;
    function Authentication(const Bearer: string): iHttpClient;
    function Body(const Value: string): iHttpClient;
    function Content: String;
    function Get(const Url: String): iHttpClient;
    function Post(const Url: String): iHttpClient;
    function Put(const Url: String): iHttpClient;
    function StatusCode: integer;

    // Novo: configurar certificado
    function CertificadoPFX(const APfxFile, ASenha: string): iHttpClient;
    function CertificadoPEM(const ACertFile, AKeyFile, ARootCertFile: string): iHttpClient;

    class function New: iHttpClient;
  end;

implementation

uses
  IdSSLOpenSSLHeaders, System.NetEncoding, IdCoderMIME, Winapi.Windows;

{ THttpClient }

constructor THttpClient.Create;
begin
  raise Exception.Create('Use THttpClient.New para instanciar.');
end;

constructor THttpClient.CreatePrivate;
begin
  inherited Create;
  FHTTP := TIdHTTP.Create(nil);
  FSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHeaders := TDictionary<string, string>.Create;
  FParams := TDictionary<string, string>.Create;

  FHTTP.IOHandler := FSSL;
  FHTTP.Request.ContentType := 'application/json';
  FHTTP.Request.Accept := 'application/json';
  FHTTP.Request.CharSet := 'utf-8';
end;

destructor THttpClient.Destroy;
begin
  FHeaders.Free;
  FParams.Free;
  FSSL.Free;
  FHTTP.Free;
  inherited;
end;

procedure THttpClient.ConfigurarCertificado;
var
  TempDir, PEMCert, PEMKey: string;
begin
  // Configuração de certificado
  if FPfxFile <> '' then
  begin
    // Converte o PFX para PEM em tempo de execução (temporário)
    TempDir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));
    PEMCert := TempDir + 'cert.pem';
    PEMKey := TempDir + 'key.pem';

    // Usa OpenSSL instalado no sistema (opcional, pode adaptar para lib interna)
    WinExec(PAnsiChar(Format(
      'cmd /C openssl pkcs12 -in "%s" -out "%s" -clcerts -nokeys -password pass:%s',
      [FPfxFile, PEMCert, FPfxPassword])), SW_HIDE);

    WinExec(PAnsiChar(Format(
      'cmd /C openssl pkcs12 -in "%s" -out "%s" -nocerts -nodes -password pass:%s',
      [FPfxFile, PEMKey, FPfxPassword])), SW_HIDE);

    FSSL.SSLOptions.CertFile := PEMCert;
    FSSL.SSLOptions.KeyFile := PEMKey;
  end
  else if (FCertFile <> '') and (FKeyFile <> '') then
  begin
    FSSL.SSLOptions.CertFile := FCertFile;
    FSSL.SSLOptions.KeyFile := FKeyFile;
    FSSL.SSLOptions.RootCertFile := FRootCertFile;
  end;

  FSSL.SSLOptions.Method := sslvTLSv1_2;
end;

function THttpClient.AddHeader(const Key, Value: String): iHttpClient;
begin
  Result := Self;
  FHeaders.AddOrSetValue(Key, Value);
end;

function THttpClient.AddParam(const Key, Value: String): iHttpClient;
begin
  Result := Self;
  FParams.AddOrSetValue(Key, Value);
end;

procedure THttpClient.ApplyHeaders;
var
  Pair: TPair<string, string>;
begin
  for Pair in FHeaders do
    FHTTP.Request.CustomHeaders.Values[Pair.Key] := Pair.Value;
end;

function THttpClient.Authentication(const Bearer: string): iHttpClient;
begin
  Result := Self;
  AddHeader('Authorization', 'Bearer ' + Bearer);
end;

function THttpClient.Body(const Value: string): iHttpClient;
begin
  Result := Self;
  FBody := Value;
end;

function THttpClient.CertificadoPFX(const APfxFile, ASenha: string): iHttpClient;
begin
  Result := Self;
  FPfxFile := APfxFile;
  FPfxPassword := ASenha;
end;

function THttpClient.CertificadoPEM(const ACertFile, AKeyFile, ARootCertFile: string): iHttpClient;
begin
  Result := Self;
  FCertFile := ACertFile;
  FKeyFile := AKeyFile;
  FRootCertFile := ARootCertFile;
end;

function THttpClient.Content: String;
begin
  Result := FResponse;
end;

function THttpClient.EncodeParams: string;
var
  Pair: TPair<string, string>;
  Lista: TStringList;
begin
  Lista := TStringList.Create;
  try
    for Pair in FParams do
      Lista.Add(Format('%s=%s', [Pair.Key, TNetEncoding.URL.Encode(Pair.Value)]));
    Result := Lista.DelimitedText.Replace(',', '&');
  finally
    Lista.Free;
  end;
end;

function THttpClient.Get(const Url: String): iHttpClient;
var
  LParams: string;
  LFullURL: string;
begin
  Result := Self;
  ConfigurarCertificado;
  ApplyHeaders;

  LParams := EncodeParams;

  LFullURL := Url;
  if not LParams.IsEmpty then
    LFullURL := Url + '?' + LParams;

  try
    FResponse := FHTTP.Get(LFullURL);
    FStatusCode := FHTTP.ResponseCode;
  except
    on E: EIdHTTPProtocolException do
    begin
      FResponse := E.ErrorMessage;
      FStatusCode := E.ErrorCode;
    end;
  end;
end;

class function THttpClient.New: iHttpClient;
begin
  Result := CreatePrivate;
end;

function THttpClient.Post(const Url: String): iHttpClient;
var
  Params: TStringStream;
begin
  Result := Self;
  ConfigurarCertificado;
  ApplyHeaders;

  try
    if FBody <> '' then
      Params := TStringStream.Create(FBody, TEncoding.UTF8)
    else
      Params := TStringStream.Create(EncodeParams, TEncoding.UTF8);

    try
      FResponse := FHTTP.Post(Url, Params);
      FStatusCode := FHTTP.ResponseCode;
    finally
      Params.Free;
    end;

  except
    on E: EIdHTTPProtocolException do
    begin
      FResponse := E.ErrorMessage;
      FStatusCode := E.ErrorCode;
    end;
  end;
end;

function THttpClient.Put(const Url: String): iHttpClient;
var
  Params: TStringStream;
begin
  Result := Self;
  ConfigurarCertificado;
  ApplyHeaders;

  try
    Params := TStringStream.Create(FBody, TEncoding.UTF8);
    try
      FResponse := FHTTP.Put(Url, Params);
      FStatusCode := FHTTP.ResponseCode;
    finally
      Params.Free;
    end;
  except
    on E: EIdHTTPProtocolException do
    begin
      FResponse := E.ErrorMessage;
      FStatusCode := E.ErrorCode;
    end;
  end;
end;

function THttpClient.StatusCode: integer;
begin
  Result := FStatusCode;
end;

end.

