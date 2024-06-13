unit UPersonas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, UAnimales, UArchivos;

type

  { TPersona }

  TPersona = class(TAnimal)
    strict private
      type
          TPersonaFileRecord = packed record
            FatrDNI:String[15];
            FatrNombre:String[30];
            FatrGenero:string[9];
            FatrGeneroEspecifico:TGenero;
            FatrEdad:byte;
            FatrDireccion:String[255];
          end;
          TArchivoPersona = file of TPersonaFileRecord;
    private
      atrDNI:String;
      atrDireccion:String;

    public
      constructor Create(pDNI,pNombre:String; pEdad:byte;pGenero:Tgenero;pDireccion:String); overload;
      Destructor Destroy; override;
      function getDireccion: String;
      function getDNI: String;
      procedure setDireccion(AValue: String);
      procedure setDNI(AValue: String);
      function getFicha:String; override;
      function clonar:TArchivable;
      function guardarEnArchivo(direccionCompleta:String):boolean; override;
      class function recuperarDeArchivo(direccionCompleta:String;idBusqueda:String):TArchivable; override;
      class function recuperarLista(direccionCompleta:String):TListaArchivable; override;



      property DNI:String read getDNI write setDNI;
      property Direccion:String read getDireccion write setDireccion;

  end;

implementation

{ TPersona }

constructor TPersona.Create(pDNI, pNombre: String; pEdad: byte;
  pGenero: Tgenero; pDireccion: String);
begin
  inherited Create(pNombre,pGenero,pEdad,VIVIPARO);
  self.atrDNI:=pDNI;
  self.atrDireccion:=pDireccion;
end;

destructor TPersona.Destroy;
begin
  inherited Destroy;
end;

function TPersona.getDireccion: String;
begin
  result:=self.atrDireccion;
end;

function TPersona.getDNI: String;
begin
  result:=self.atrDNI;
end;

procedure TPersona.setDireccion(AValue: String);
begin
  self.atrDireccion:=AValue;
end;

procedure TPersona.setDNI(AValue: String);
begin
  self.atrDNI:=AValue;
end;

function TPersona.getFicha: String;
begin
  result:='Good';
end;

function TPersona.clonar: TArchivable;
begin
  result:=TPersona.Create(self.atrDNI,self.Nombre,self.Edad,self.Genero,'VIVIPARO');
end;

function TPersona.guardarEnArchivo(direccionCompleta: String): boolean;
var guardar:TPersonaFileRecord;
    dbPersona:TArchivoPersona;

  //Aqui esta un poco dificil porque solo abrira un archivo al invocar estas funciones
begin
  AssignFile(dbPersona,direccionCompleta);
  {$I-}// Desactiva la deteccion manual de errores
  if FileExists(direccionCompleta) then
     reset(dbPersona)
  else
     rewrite(dbPersona);
  {$I+}//Vuelve a activar la deteccion manual de errores

  If IOResult<>0 then begin
    //Aqui salto algun error
    result:=false;
    EXIT;
  end;
  guardar.FatrDireccion:=self.Direccion;
  guardar.FatrDNI:=self.atrDNI;
  guardar.FatrEdad:=self.Edad;
  guardar.FatrGenero:=self.GeneroStr;
  guardar.FatrGeneroEspecifico:=self.Genero;

  seek(dbPersona,FileSize(dbPersona));
  write(dbPersona,guardar);

  {$I-}
  Close(dbPersona);
  {$I+}
  if IOResult<>0 then
     result:=false
  else
     result:=true;

end;

class function TPersona.recuperarDeArchivo(direccionCompleta: String;
  idBusqueda: String): TArchivable;
var dbPersona:TArchivoPersona;
    buscar:TPersonaFileRecord;
begin
  result:=NIL;
  AssignFile(dbPersona,direccionCompleta);
  if FileExists(direccionCompleta) then
     reset(dbPersona)
  else
     rewrite(dbPersona);
  seek(dbPersona,0);
  while not eof(dbPersona) do begin
    read(dbPersona,buscar);
    if CompareStr(buscar.FatrDNI,idBusqueda)=0 then begin
      result:=TPersona.Create(buscar.FatrDNI,buscar.FatrNombre,buscar.FatrEdad,buscar.FatrGeneroEspecifico,buscar.FatrDireccion);
      EXIT;
    end;
  end;
  CloseFile(dbPersona);
end;

class function TPersona.recuperarLista(direccionCompleta: String
  ): TListaArchivable;
var contenido:TPersona;
    buscar:TPersonaFileRecord;
    dbPersona:TArchivoPersona;
begin
  result:=TListaArchivable.create;
  AssignFile(dbPersona,direccionCompleta);
  if FileExists(direccionCompleta) then
     reset(dbPersona)
  else
     rewrite(dbPersona);
  seek(dbPersona,0);
  while not eof(dbPersona) do begin
    read(dbPersona,buscar);
    contenido:=TPersona.Create(buscar.FatrDNI,buscar.FatrNombre,buscar.FatrEdad,buscar.FatrGeneroEspecifico,buscar.FatrDireccion);
    result.agregar(contenido);
  end;

  CloseFile(dbPersona);

end;

end.

