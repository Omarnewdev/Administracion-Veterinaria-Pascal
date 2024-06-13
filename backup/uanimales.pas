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

  { TMascota }

  TMascota = class(TAnimal)
    strict private
      type
          TMascotaFileRecord = packed record
              FatrID:String[10];
              FatrNombre:String[30];
              FatrGenero:string[9];
              FatrGeneroEspecifico:TGenero;
              FatrEdad:byte;
              FatrGestacion:String[8];
              FatrGestacionEsp:TGestacion;
              FatrEspecie:String[20];
              FatrRaza:String[20];
              FatrEsAdoptado:boolean;
              FatrDuenno:string[30];
          end;
          TArchivoMascota = file of TMascotaFileRecord;

    private
      atrID: String;
      atrEspecie: String;
      atrRaza: string;
      atrEsAdoptado: boolean;
      atrDuenno: String;



    public

      constructor Create(pID,pNombre:String; pGenero:Tgenero; pEdad:byte; pGestacion: Tgestacion;
        pEspecie,pRaza:String); overload;
      destructor Destroy; override;

      function getDuennoID: string;
      function getID: String;
      function getRaza: String;
      function getEspecie: String;
      function esAdoptado: boolean;

      procedure setEspecie(AValue: String);
      procedure setDuennoID(AValue: string);
      procedure setID(AValue: String);
      procedure setRaza(AValue: String);
      procedure setAdoptado(a:boolean;pidDuenno:String='');

      function getFicha:String; override;
      function guardarEnArchivo(direccionCompleta:String):boolean; override;
      function clonar:TArchivable; override;
      class function recuperarDeArchivo(direccionCompleta,idBusqueda:String):TArchivable; override;
      class function recuperarLista(direccionCompleta:String):TLIstaArchivable; override;


      property ID:String read getID write setID;
      property Especie:String read getEspecie write setEspecie;
      property Raza:String read getRaza write setRaza;
      property Adoptado:boolean read esAdoptado;
      property DuennoID:string read getDuennoID write setDuennoID;

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

{ TMascota }

function TMascota.getEspecie: String;
begin
  result:=self.atrEspecie;
end;

function TMascota.esAdoptado: boolean;
begin
  result:=self.atrEsAdoptado;
end;

procedure TMascota.setEspecie(AValue: String);
begin
  self.atrEspecie:=AValue;
end;

constructor TMascota.Create(pID, pNombre: String; pGenero: Tgenero;
  pEdad: byte; pGestacion: Tgestacion; pEspecie, pRaza: String);
begin
  inherited create(pNombre,pGenero,pEdad,pGestacion);
  self.atrID:=pID;
  self.atrEspecie:=pEspecie;
  self.atrRaza:=pRaza;
  self.atrEsAdoptado:=FALSE;
  self.atrDuenno:='';


end;

destructor TMascota.Destroy;
begin
  inherited Destroy;
end;

function TMascota.getDuennoID: string;
begin
  result:= self.atrDuenno;
end;

function TMascota.getID: String;
begin
  result:= self.atrID;
end;

function TMascota.getRaza: String;
begin
  result:= self.atrRaza;
end;

procedure TMascota.setDuennoID(AValue: string);
begin
  self.atrDuenno:=Avalue;
end;

procedure TMascota.setID(AValue: String);
begin
  self.atrID:=AValue;
end;

procedure TMascota.setRaza(AValue: String);
begin
  self.atrRaza:=AValue;
end;

procedure TMascota.setAdoptado(a: boolean; pIDDuenno: String);
begin
  self.atrEsAdoptado:=a;
  self.atrDuenno:=pIDDuenno;
end;

{Tenemos que devuelve esto en String:

ID: 568
Especie: Ave
Raza: Loro común
Nombre: Pepe
Edad: 4
Genero: Macho
Tipo: Ovíparo
Adoptado: NO}
function TMascota.getFicha: String;
var ad:String;
begin
  if self.esAdoptado then
     ad:='SI'
  else
     ad:='NO';
  result:='ID: '+self.ID+#10+'Especie: '+self.Especie+#10+'Raza: '+self.Raza+#10+
  'Nombre: '+self.Nombre+#10+'Edad: '+InttoStr(self.Edad)+#10+'Genero: '+self.GeneroStr+#10+
  'Tipo: '+self.GestacionStr+#10+'Adaptado: '+ad;
end;

function TMascota.guardarEnArchivo(direccionCompleta: String): boolean;
var guardar:TMascotaFileRecord;
    dbMascota:TArchivoMascota;

  //Aqui esta un poco dificil porque solo abrira un archivo al invocar estas funciones
begin
  AssignFile(dbMascota,direccionCompleta);
  {$I-}// Desactiva la deteccion manual de errores
  if FileExists(direccionCompleta) then
     reset(dbMascota)
  else
     rewrite(dbMascota);
  {$I+}//Vuelve a activar la deteccion manual de errores

  If IOResult<>0 then begin
    //Aqui salto algun error
    result:=false;
    EXIT;
  end;
  guardar.FatrNombre:=self.atrNombre;
  guardar.FatrEdad:=self.Edad;
  guardar.FatrDuenno:=self.atrDuenno;
  guardar.FatrEsAdoptado:=self.esAdoptado;
  guardar.FatrEspecie:=self.Especie;
  guardar.FatrGenero:=self.GeneroStr;
  guardar.FatrGeneroEspecifico:=self.Genero;
  guardar.FatrGestacion:=self.GestacionStr;
  guardar.FatrGestacionEsp:=self.Gestacion;
  guardar.FatrDuenno:=self.DuennoID;

  seek(dbMascota,FileSize(dbMascota));
  write(dbMascota,guardar);

  {$I-}
  Close(dbMascota);
  {$I+}
  if IOResult<>0 then
     result:=false
  else
     result:=true;

end;

function TMascota.clonar: TArchivable;
begin
  result:=TMascota.Create(self.ID,self.Nombre,self.Genero,self.Edad,self.Gestacion,self.Especie,self.Raza);
end;

class function TMascota.recuperarDeArchivo(direccionCompleta: String;
  idBusqueda: String): TArchivable;
var dbMascota:TArchivoMascota;
    buscar:TMascotaFileRecord;
begin
  result:=NIL;
  AssignFile(dbMascota,direccionCompleta);
  if FileExists(direccionCompleta) then
     reset(dbMascota)
  else
     rewrite(dbMascota);
  seek(dbMascota,0);
  while not eof(dbMascota) do begin
    read(dbMascota,buscar);
    if CompareStr(buscar.FatrID,idBusqueda)=0 then begin
      result:=TMascota.Create(buscar.FatrID,buscar.FatrNombre,buscar.FatrGeneroEspecifico,buscar.FatrEdad,buscar.FatrGestacionEsp,buscar.FatrEspecie,buscar.FatrRaza);
      EXIT;
    end;
  end;
end;

class function TMascota.recuperarLista(direccionCompleta: String): TLIstaArchivable;
begin

end;





end.

