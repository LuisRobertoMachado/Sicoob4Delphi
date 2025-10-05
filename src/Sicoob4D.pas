unit Sicoob4D;

interface

uses
  Sicoob4D.Interfaces,
  Sicoob4D.Auth.Interfaces,
  Sicoob4D.Resources.Interfaces,
  System.SysUtils;

type
  TSicoob4D = class(TInterfacedObject, iSicoob4D)
  private
    FConfig: iAuthConfig;
    constructor CreatePrivate;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iSicoob4D;
    function AuthConfig: iAuthConfig;
    function Resources: iSicoob;
  end;

implementation

uses
  Sicoob4D.Auth.Impl,
  Sicoob4D.Resources.Impl;

{ TSicoob4D }

function TSicoob4D.AuthConfig: iAuthConfig;
begin
  if not Assigned(FConfig) then
    FConfig := TAuthConfig.New;
  Result := FConfig;
end;

constructor TSicoob4D.Create;
begin
  raise Exception.Create('Para obter uma instancia, utiliza a função New');
end;

constructor TSicoob4D.CreatePrivate;
begin
  inherited Create;
end;

destructor TSicoob4D.Destroy;
begin

  inherited;
end;

class function TSicoob4D.New: iSicoob4D;
begin
  Result := Self.CreatePrivate;
end;

function TSicoob4D.Resources: iSicoob;
begin
  Result := TSicoob.New(FConfig);
end;

end.
