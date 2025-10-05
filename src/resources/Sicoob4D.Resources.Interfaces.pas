unit Sicoob4D.Resources.Interfaces;

interface

uses
  Sicoob4D.Commons.Interfaces,
  Sicoob4D.Commons.Types,
  System.Generics.Collections,
  System.JSON;

type
  iHttpClient = interface
    ['{D90C756E-C318-46EF-94F3-9383C2F7E5D3}']
    function AddHeader(const Key, Value: String): iHttpClient;
    function AddParam(const Key, Value: String): iHttpClient;
    function Authentication(const Bearer: string): iHttpClient;
    function Body(const Value: string): iHttpClient;
    function Content: String;
    function Get(const Url: String): iHttpClient;
    function Post(const Url: String): iHttpClient;
    function Put(const Url: String): iHttpClient;
    function StatusCode: integer;
  end;

  iSicoob = interface
    ['{E3E4D182-F37D-47B3-BC75-6730CDA8A002}']
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
  end;

implementation

end.
