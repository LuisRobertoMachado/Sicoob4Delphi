unit Sicoob4D.Resources.RestHttpClient;

interface

uses
  REST.Types,
  REST.Client,
  Sicoob4D.Resources.Interfaces,
  System.SysUtils;

type
  THttpClient = class(TInterfacedObject, iHttpClient)
  private
    FRestClient: TRESTClient;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;
    constructor CreatePrivate;
    procedure BeforeExecute(const Url: string);
  public
    constructor Create;
    destructor Destroy; override;
    function AddHeader(const Key, Value: String): iHttpClient;
    function AddParam(const Key, Value: String): iHttpClient;
    function Authentication(const Bearer: string): iHttpClient;
    function Body(const Value: string): iHttpClient;
    function Content: String;
    function Get(const Url: String): iHttpClient;
    function Post(const Url: String): iHttpClient;
    function Put(const Url: String): iHttpClient;
    function StatusCode: integer;
    class function New: iHttpClient;
  end;

implementation

{ THttpClient }

function THttpClient.AddHeader(const Key, Value: String): iHttpClient;
var
  LParam: TRESTRequestParameter;
begin
  Result := Self;
  LParam := FRestRequest.Params.AddItem;
  LParam.Kind := TRESTRequestParameterKind.pkHTTPHEADER;
  LParam.Name := Key;
  LParam.Value := Value;
end;

function THttpClient.AddParam(const Key, Value: String): iHttpClient;
begin
  Result := Self;
  FRestRequest.Params.AddItem(Key,Value);
end;

function THttpClient.Authentication(const Bearer: string): iHttpClient;
var
  LParam: TRESTRequestParameter;
begin
  Result := Self;
  LParam := FRestRequest.Params.AddItem;
  LParam.Name := 'Authorization';
  LParam.Kind := TRESTRequestParameterKind.pkHTTPHEADER;
  LParam.Value := 'Bearer ' + Bearer;
end;

procedure THttpClient.BeforeExecute(const Url: string);
begin
  FRestClient.Accept :=
    'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRestClient.AcceptCharset := 'UTF-8, *;q=0.8';
  FRestClient.AcceptEncoding := '';
  FRestClient.AutoCreateParams := true;
  FRestClient.AllowCookies := true;
  FRestClient.BaseURL := Url;
  FRestClient.ContentType := '';
  FRestClient.FallbackCharsetEncoding := 'utf-8';
  FRestClient.HandleRedirects := true;

  FRestResponse.ContentType := 'application/json';
  FRestRequest.Accept :=
    'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRestRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  FRestRequest.AcceptEncoding := '';
  FRestRequest.AutoCreateParams := true;
  FRestRequest.Client := FRestClient;
  FRestRequest.SynchronizedEvents := False;
  FRestRequest.Response := FRestResponse;
end;

function THttpClient.Body(const Value: string): iHttpClient;
begin
  Result := Self;
  with FRestRequest.Params.AddItem do
  begin
    ContentType := ctAPPLICATION_JSON;
    Kind := pkREQUESTBODY;
    Name := 'body';
    Value := Value;
    Options := [poDoNotEncode];
  end;
end;

function THttpClient.Content: String;
begin
  Result := FRestResponse.Content;
end;

constructor THttpClient.Create;
begin
  raise Exception.Create('Para obter uma instancia, utiliza a função New');
end;

constructor THttpClient.CreatePrivate;
begin
  inherited Create;
  FRestClient := TRESTClient.Create(nil);
  FRestRequest := TRESTRequest.Create(FRestClient);
  FRestResponse := TRESTResponse.Create(FRestClient);
end;

destructor THttpClient.Destroy;
begin
  FRestRequest.Free;
  FRestResponse.Free;
  FRestClient.Free;
  inherited;
end;

function THttpClient.Get(const Url: String): iHttpClient;
begin
  Result := Self;
  BeforeExecute(Url);
  FRestRequest.Method := rmGET;
  FRestRequest.Execute;
end;

class function THttpClient.New: iHttpClient;
begin
  Result := Self.CreatePrivate;
end;

function THttpClient.Post(const Url: String): iHttpClient;
begin
  Result := Self;
  BeforeExecute(Url);
  FRestRequest.Method := rmPOST;
  FRestRequest.Execute;
end;

function THttpClient.Put(const Url: String): iHttpClient;
begin
  Result := Self;
  BeforeExecute(Url);
  FRestRequest.Method := rmPUT;
  FRestRequest.Execute;
end;

function THttpClient.StatusCode: integer;
begin
  Result := FRestResponse.StatusCode;
end;

end.
