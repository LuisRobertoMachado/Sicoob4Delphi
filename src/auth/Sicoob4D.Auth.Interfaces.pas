unit Sicoob4D.Auth.Interfaces;

interface

uses
  Sicoob4D.Commons.Types;

type
  iAuthConfig = interface
    ['{D645A62B-8901-4EC8-9FC2-E5C0EAD8D787}']
    function BaseUrl(const Value : String) : iAuthConfig; overload;
    function BaseUrl : String; overload;
    function ClientId(const Value: string): iAuthConfig; Overload;
    function ClientId: string; Overload;
    function CertFile(const Value: string): iAuthConfig;Overload;
    function CertFile: string;Overload;
    function KeyFile(const Value: string): iAuthConfig;Overload;
    function KeyFile: string;Overload;
    function Scope(const Values: array of TApiScope): iAuthConfig;
    function Token: string; Overload;
  end;

implementation

end.
