unit UAnimales;

{$mode ObjFPC}{$H+}

interface

uses
  UArchivos,Classes, SysUtils;

type

  { TEspecie }

  TEspecie= class(TArchivable)
    strict private
      type
          TEspecieFileRecord = packed record
            FatrEspecie:String[20];
            FatrRaza:String[20];
          end;
    private
      type
          TArchivoEspecie = file of TEspecieFileRecord;
    private
      atrEspecie: String;
      atrRaza: String;
    public
      constructor create(pEspecie,pRaza:String); overload;
      destructor Destroy; override;
      function getEspecie:String;
      procedure setEspecie(pEspecie:String);
      function getRaza:String;
      procedure setRaza(pRaza:String);
      function guardarEnArchivo(direccionCompleta:string):boolean; override;
      function clonar:TArchivable; override;
      class function recuperarDeArchivo(direccionCompleta,idBusqueda:string):TArchivable; override; //Se iniciara con inizialition
      class function recuperarLista(direccionCompleta:String):TListaArchivable; override; //Se iniciara con inizialitation
      property Especie:String read getEspecie write setEspecie;
      property Raza:String read getRaza write setRaza;
  end;


  { TAnimal }

  TAnimal = class(TArchivable)
    public
      type
          TGenero = (ANIMAL_MACHO,ANIMAL_HEMBRA,PERSONA_MASCULINO,PERSONA_FEMENINO);
          TGestacion = (OVIPARO,VIVIPARO);
    protected
      atrNombre:String;
      atrGenero:String;
      atrGeneroEspecifico:TGenero;
      atrEdad: byte;
      atrGestacion: String;
      atrGestacionEsp:Tgestacion;
    public


      function getFicha:string; virtual; abstract;

      constructor Create(pNOMBRE:String; pGenero:TGenero; pEdad:byte; pGestacion:TGestacion); overload;
      destructor Destroy; override;
      function getEdad: byte; virtual;
      function getGeneroEsp: TGenero; virtual;
      function getGeneroStr: String; virtual;
      function getGestacionEsp: Tgestacion; virtual;
      function getGestacionStr: String; virtual;
      function getNombre: String; virtual;
      procedure setEdad(AValue: byte); virtual;
      procedure setGenero(AValue: TGenero); virtual;
      procedure setGestacion(AValue: Tgestacion); virtual;
      procedure setNombre(AValue: String); virtual;

      property Nombre:String read getNombre write setNombre;
      property Genero:TGenero read getGeneroEsp write setGenero;
      property GeneroStr:String read getGeneroStr;
      property Edad: byte read getEdad write setEdad;
      property Gestacion: Tgestacion read getGestacionEsp write setGestacion;
      property GestacionStr: String read getGestacionStr;
  end;

  TMascota = class(TAnimal)
    private
      atrID: String;
      atrEspecie: String;

  end;



implementation

{ TEspecie }

constructor TEspecie.create(pEspecie, pRaza: String);
begin
  self.atrEspecie:=pEspecie;
  self.atrRaza:=pRaza;
end;

destructor TEspecie.Destroy;
begin
  inherited Destroy;
end;

function TEspecie.getEspecie: String;
begin
  result:=self.atrEspecie;
end;

procedure TEspecie.setEspecie(pEspecie: String);
begin
  self.atrEspecie:=pEspecie;
end;

function TEspecie.getRaza: String;
begin
  result:=self.atrRaza;
end;

procedure TEspecie.setRaza(pRaza: String);
begin
  self.atrRaza:=pRaza;
end;

function TEspecie.guardarEnArchivo(direccionCompleta: string): boolean;
var guardar:TEspecieFileRecord;
    dbEspecie:TArchivoEspecie;

  //Aqui esta un poco dificil porque solo abrira un archivo al invocar estas funciones
begin
  AssignFile(dbEspecie,direccionCompleta);
  {$I-}// Desactiva la deteccion manual de errores
  if FileExists(direccionCompleta) then
     reset(dbEspecie)
  else
     rewrite(dbEspecie);
  {$I+}//Vuelve a activar la deteccion manual de errores

  If IOResult<>0 then begin
    //Aqui salto algun error
    result:=false;
    EXIT;
  end;
  guardar.FatrRaza:=self.Raza;
  guardar.FatrEspecie:=self.Especie;

  seek(dbEspecie,FileSize(dbEspecie));
  write(dbEspecie,guardar);

  {$I-}
  Close(dbEspecie);
  {$I+}
  if IOResult<>0 then
     result:=false
  else
     result:=true;

end;

function TEspecie.clonar: TArchivable;
begin
  result := TEspecie.create(self.Especie,self.Raza);

end;

class function TEspecie.recuperarDeArchivo(direccionCompleta, idBusqueda: string
  ): TArchivable;
var dbEspecie:TArchivoEspecie;
    recoger:TEspecieFileRecord;
//El id lo tomare como si fuera el espacio del archivo
{Por ejemplo si el tamaño del archivo es menor al id significa que no existe
Y retorno NIL}
begin
  AssignFile(dbEspecie,direccionCompleta);
  if FileExists(direccionCompleta) then
     reset(dbEspecie)
  else
     rewrite(dbEspecie);
  if FileSize(dbEspecie)<=StrtoInt(idBusqueda) then begin
    result:=NIL;
    EXIT;
  end;
  seek(dbEspecie,StrtoInt(idBusqueda));
  read(dbEspecie,recoger);

  result:=TEspecie.create(recoger.FatrEspecie,recoger.FatrRaza);
  CloseFile(dbEspecie);
end;

class function TEspecie.recuperarLista(direccionCompleta: String): TListaArchivable;
var dbEspecie:TArchivoEspecie;
    recoger:TEspecieFileRecord;
    contenido:TEspecie;
begin
  result:= TListaArchivable.create;
  AssignFile(dbEspecie,direccionCompleta);
  if FileExists(direccionCompleta) then
     reset(dbEspecie)
  else
     rewrite(dbEspecie);

  seek(dbEspecie,0);
  while not eof(dbEspecie) do begin
    read(dbEspecie,recoger);
    contenido:=TEspecie.create(recoger.FatrEspecie,recoger.FatrRaza);
    result.agregar(contenido);
  end;



  Close(dbEspecie);
end;

{ TAnimal }

constructor TAnimal.Create(pNOMBRE: String; pGenero: TGenero; pEdad: byte;
  pGestacion: TGestacion);
begin
  self.atrNombre:=pNombre;
  self.atrGeneroEspecifico:=pGenero;
  self.atrEdad:=pEdad;
  self.atrGestacionEsp:=pGestacion;
  case self.atrGeneroEspecifico of
       ANIMAL_MACHO: self.atrGenero:='MACHO';
       ANIMAL_HEMBRA: self.atrGenero:='HEMBRA';
       PERSONA_MASCULINO: self.atrGenero:='MASCULINO';
       PERSONA_FEMENINO: self.atrGenero:='FEMENINO';
  end;
  case self.atrGestacionEsp of
       OVIPARO: self.atrGestacion:='OVIPARO';
       VIVIPARO: self.atrGestacion:='VIVIPARO';
  end;
end;

destructor TAnimal.Destroy;
begin
  inherited Destroy;
end;

function TAnimal.getEdad: byte;
begin
  result:=self.atrEdad;
end;

function TAnimal.getGeneroEsp: TGenero;
begin
  result:=self.atrGeneroEspecifico;
end;

function TAnimal.getGeneroStr: String;
begin
  result:=self.atrGenero;
end;

function TAnimal.getGestacionEsp: Tgestacion;
begin
  result:=self.atrGestacionEsp;
end;

function TAnimal.getGestacionStr: String;
begin
  result:=self.atrGestacion;
end;

function TAnimal.getNombre: String;
begin
  result:=self.atrNombre;
end;

procedure TAnimal.setEdad(AValue: byte);
begin
  self.atrEdad:=AValue;
end;

procedure TAnimal.setGenero(AValue: TGenero);
begin
  self.atrGeneroEspecifico:=Avalue;
  case self.atrGeneroEspecifico of
       ANIMAL_MACHO: self.atrGenero:='MACHO';
       ANIMAL_HEMBRA: self.atrGenero:='HEMBRA';
       PERSONA_MASCULINO: self.atrGenero:='MASCULINO';
       PERSONA_FEMENINO: self.atrGenero:='FEMENINO';
  end;
end;

procedure TAnimal.setGestacion(AValue: Tgestacion);
begin
  self.atrGestacionEsp:=AValue;
  case self.atrGestacionEsp of
       OVIPARO: self.atrGestacion:='OVIPARO';
       VIVIPARO: self.atrGestacion:='VIVIPARO';
  end;
end;

procedure TAnimal.setNombre(AValue: String);
begin
  self.atrNombre:=AValue;
end;





end.

