unit Sicoob4D.Auth.Impl;

interface

uses
  Sicoob4D.Auth.Interfaces,
  Sicoob4D.Commons.Types,
  System.SysUtils;

type
  TAuthConfig = class(TInterfacedObject, iAuthConfig)
  private
    FAPI: TApiType;
    FBaseUrl: string;
    FClientId: string;
    FToken: string;
    constructor CreatePrivate;
  public
    constructor Create;
    destructor Destroy; override;
    function BaseUrl(const Value : String) : iAuthConfig; overload;
    function BaseUrl : String; overload;
    function ClientId(const Value: string): iAuthConfig; Overload;
    function ClientId: string; Overload;
    function Token(const Value: string): iAuthConfig; Overload;
    function Token: string; Overload;
    class function New: iAuthConfig;
  end;

implementation

{ TAuthConfig }

function TAuthConfig.ClientId(const Value: string): iAuthConfig;
begin
  Result := Self;
  FClientId := Value;
end;

function TAuthConfig.BaseUrl(const Value: String): iAuthConfig;
begin
  Result := Self;
  FBaseUrl := Value;
end;

function TAuthConfig.BaseUrl: String;
begin
  Result := FBaseUrl;
end;

function TAuthConfig.ClientId: string;
begin
  Result := FClientId;
end;

constructor TAuthConfig.Create;
begin
  raise Exception.Create('Para obter uma instancia, utiliza a função New');
end;

constructor TAuthConfig.CreatePrivate;
begin
  inherited Create;
end;

destructor TAuthConfig.Destroy;
begin

  inherited;
end;

class function TAuthConfig.New: iAuthConfig;
begin
  result := Self.CreatePrivate;
end;

function TAuthConfig.Token(const Value: string): iAuthConfig;
begin
  Result := Self;
  FToken := Value;
end;

function TAuthConfig.Token: string;
begin
  Result := FToken;
end;

end.
