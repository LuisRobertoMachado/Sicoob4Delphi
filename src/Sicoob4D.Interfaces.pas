unit Sicoob4D.Interfaces;

interface

uses
  Sicoob4D.Auth.Interfaces,
  Sicoob4D.Resources.Interfaces;

type
  iSicoob4D = interface
    ['{298EA86E-F8ED-4B96-9F16-37945D54AA6F}']
    function AuthConfig: iAuthConfig;
    function Resources: iSicoob;
  end;

implementation

end.
