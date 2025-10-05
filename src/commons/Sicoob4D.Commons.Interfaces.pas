unit Sicoob4D.Commons.Interfaces;

interface

uses
  System.Generics.Collections;

type
  iSicoobParams = interface
    ['{67134622-78C4-4CBB-B5B2-D712BFC31F47}']
    function Add(const Key: string; const Value: Variant): iSicoobParams;
    function &End: TDictionary<string, Variant>;
  end;

implementation

end.
