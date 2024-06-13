unit UControlador;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils,UArchivos,UPersonas,UAnimales;

type
  IControlador = Interface

    ['{B2E55B52-2020-46C6-81EF-E390EFF00674}']

    function init:IControlador;

    function registrarEspecie(pEspecieNueva:String;pRazaNueva:String):boolean;
    function registrarRaza(pEspecieExistente,pRazaNueva:string):boolean;
    function registrarMascota(pid,pnombre:String;pGenero:TAnimal.TGenero;edad:byte;gest:TAnimal.TGestacion;especie,raza:String):boolean;
    function registrarPersona(pDNI,pNombre:String; pEdad:byte; pGenero:TAnimal.Tgenero;pDireccion:String):boolean;
    procedure darEnAdopcion(idMascota,DNIPersona:String);
    procedure darDeBajaMascota(idMascota:String);
    procedure darDeBajaPersona(DNI:String);
    function listaDeMascotas(especie,raza:String):TListaArchivable;
    function listaDeMascotas(DNIDuenno:String):TListaArchivable;
    function listaDeEspecies:TStrings;
    function listaDeRazas(especie:String):TStrings;
    function listaDePersonas:TListaArchivable;
  end;

  { TControlador }

  TControlador = class(IControlador)
    private
      atrListaEspeciesStr:TStringList;
      atrListaRazasStr:TStringList;
      atrListaEspeciesObj:TListaArchivable;
      atrListaMascotas:TListaArchivable;
      atrListaPersonas:TListaArchivable;
      AtrInstance:TControlador; static;
      constructor Create; overload;
    public
      class function GetInstacia:TControlador;
      function init:IControlador;
      {registrarEspecie: Registra una nueva especie vinculándola a la nueva raza
      creada. Si ya existe una especie con el nombre indicado entonces se registrará la raza
      nueva vinculada a dicha especie. En ambos casos se retorna TRUE. En caso de que ya
      exista la especie y la raza, vinculadas entre sí, no se registrará nada y se retornará
      FALSE.}
      function registrarEspecie(pEspecieNueva:String;pRazaNueva:String):boolean;
      {resgistrarRaza: Registra la nueva raza vinculada a la especie existente. Si no existe
      la especie indicada esta se registrará junto con la nueva raza invocando a
      'registrarEspecie(string,string):boolean' y se retornará TRUE. Si
      existe la especie indicada y no existe la raza, entonces se hará el registro vinculando la
      raza a la especie existente y se retornará TRUE. Si existe la especie y la raza, no se hará
      nada y se retornará FALSE.}
      function registrarRaza(pEspecieExistente,pRazaNueva:string):boolean;
      {registrarMascota: Se registra una nueva mascota en el sistema. No debe existir
      una mascota con el ID indicado; en tal caso se retorna FALSE. Si el registro se hace de
      forma exitosa se retorna TRUE}
      function registrarMascota(pid,pnombre:String;pGenero:TAnimal.TGenero;edad:byte;gest:TAnimal.TGestacion;especie,raza:String):boolean;
      {registrarPersona: Se registra una nueva persona con el DNI y el resto de datos
      indicados. No debe existir una persona dicho DNI en el sistema; en tal caso se retorna
      FALSE y no se hace nada. Si no existe en el sistema una persona con el DNI indicado
      en pDNI se hará el registro y se retornará TRUE}
      function registrarPersona(pDNI,pNombre:String; pEdad:byte; pGenero:TAnimal.Tgenero;pDireccion:String):boolean;
      procedure darEnAdopcion(idMascota,DNIPersona:String);
      procedure darDeBajaMascota(idMascota:String);
      procedure darDeBajaPersona(DNI:String);
      {listaDeMascotas: Se retorna una lista con todas las Mascotas cuya especie y raza
      sean las indicadas. La lista estará vacía si no hay mascotas que cumplan con estas
      condiciones. Las mascotas retornadas serán copias de las que están en memoria, por
      tanto podrán luego ser eliminadas sin problemas ni repercusiones en la lista de
      mascotas del sistema. Las mascotas estarán en la lista como objetos TArchivable,
      por lo cual se requerirá casteo para verlas como TMascota.}
      function listaDeMascotas(especie,raza:String):TListaArchivable;
      {listaDeMascotas: Se retorna la lista de mascotas cuyo dueño sea la persona dada
      por el DNI indicado. Si no hay mascotas que cumplan esta condición la lista estará vacía.
      Las mascotas retornadas serán copias de las que están en memoria, por tanto podrán
      luego ser eliminadas sin problemas ni repercusiones en la lista de mascotas del sistema.
      Las mascotas estarán en la lista como objetos TArchivable, por lo cual se requerirá
      casteo para verlas como TMascota.}
      function listaDeMascotas(DNIDuenno:String):TListaArchivable;
      {listaDeEspecies: Se retorna una lista de las especies existentes en el sistema, sin
      que se repitan los nombres. La lista estará vacía si no hay especies registradas}
      function listaDeEspecies:TStrings;
      {listaDeRazas: Se retorna una lista de razas en el sistema vinculadas a la especie
      indicada. Si la especie no existe, o bien, si no hay razas vinculadas a ella, la lista
      estará vacía.}
      function listaDeRazas(especie:String):TStrings;
      {listaDePersonas: Se retorna una lista con todas las personas registradas en el
      sistema. Si no hay ninguna persona registrada, la lista resultante será vacía.}
      function listaDePersonas:TListaArchivable;


  end;

implementation

{ TControlador }

constructor TControlador.Create;
var
  contEspecie: TEspecie;
begin
  contEspecie:= TEspecie.Create;
  self.atrListaEspeciesObj:=TEspecie.recuperarLista(contEspecie.NOMBRE_DIRECTORIO_DATABASE+directorySeparation+contEspecie.NOMBRE_ARCHIVO_ESPECIES);
  self.atrListaMascotas:=TMascota.recuperarLista(contEspecie.NOMBRE_DIRECTORIO_DATABASE+directorySeparation+contEspecie.NOMBRE_ARCHIVO_MASCOTAS);
  self.atrListaPersonas:=TPersona.recuperarLista(contEspecie.NOMBRE_DIRECTORIO_DATABASE+directorySeparation+contEspecie.NOMBRE_ARCHIVO_PERSONAS);
  contEspecie.Destroy;
  //Primero creamos la lista de especies y razas
  self.atrListaEspeciesStr:= TStringList.Create;
  self.atrListaRazasStr:=TStringList.Create;
  if not self.atrListaEspeciesObj.esVacia then begin
    repeat
      self.atrListaEspeciesObj.siguiente;
      contEspecie:=self.atrListaEspeciesObj.Actual as TEspecie;
      self.atrListaEspeciesStr.Add(contEspecie.Especie);
      self.atrListaRazasStr.Add(contEspecie.getRaza);
    until not self.atrListaEspeciesObj.haySiguienteNodo;
  end;
end;

class function TControlador.GetInstacia: TControlador;
begin
  result:=self.AtrInstance;
end;

function TControlador.init: IControlador;
begin
  if self.AtrInstance = NIL then
     self.AtrInstance:=TControlador.Create;
  result:=self.AtrInstance;
end;

function TControlador.registrarEspecie(pEspecieNueva: String; pRazaNueva: String): boolean;
var buscador,guardador: TEspecie;
begin
  guardador:= TEspecie.create(pEspecieNueva,pRazaNueva);

  if not self.atrListaEspeciesObj.esVacia then begin
    self.atrListaEspeciesObj.reset;
    repeat
      self.atrListaEspeciesObj.siguiente;
      buscador:=self.atrListaEspeciesObj.Actual as TEspecie;
      if (CompareStr(pEspecieNueva,buscador.Especie) = 0) and (CompareStr(pRazaNueva,buscador.Raza) = 0) then begin
        result:=False;
        EXIT;
      end else if (CompareStr(pEspecieNueva,buscador.Especie) = 0) then begin
        //Aqui solo registramos la especie a la raza
        self.atrListaEspeciesObj.agregar(guardador);
        self.atrListaRazasStr.Add(pRazaNueva);
        EXIT;
      end;
    until not self.atrListaEspeciesObj.HaySiguiente;

  end;

  self.atrListaEspeciesObj.agregar(guardador);
  self.atrListaEspeciesStr.Add(pEspecieNueva);
  self.atrListaRazasStr.Add(pRazaNueva);
  result:=true;
end;

function TControlador.registrarRaza(pEspecieExistente, pRazaNueva: string): boolean;
var buscador,guardador: TEspecie;
    i:integer;
    esta:boolean;
begin

  //primero revisamos si esta en la lista
  if  self.atrListaEspeciesStr.IndexOfName(pEspecieExistente) = -1 then begin
    result:= self.registrarEspecie(pEspecieExistente,pRazaNueva);
    EXIT;
  end;
  //Ahorra si existe la raza revisamos si existe la raza
  if self.atrListaRazasStr.IndexOfName(pRazaNueva) <> -1 then begin
     result:=False;
     EXIT;
  end;
  guardador:= TEspecie.create(pEspecieExistente,pRazaNueva);
  self.atrListaEspeciesObj.agregar(guardador);
  self.atrListaRazasStr.Add(pRazaNueva);
  result:=true;

end;

function TControlador.registrarMascota(pid, pnombre: String;
  pGenero: TAnimal.TGenero; edad: byte; gest: TAnimal.TGestacion;
  especie,raza:String): boolean;
var buscador:TMascota;
    arch: TMascota;
begin
  if not self.atrListaMascotas.esVacia then begin
    //Buscamos si existe alguna mascota con el ID
    self.atrListaMascotas.reset;
    repeat
      self.atrListaMascotas.siguiente;
      buscador:=self.atrListaMascotas.get as TMascota;
      if CompareStr(buscador.ID,pid) = 0 then begin
        //Signiffica que existe entonces nos salimos
        result:=false;
        EXIT;
      end;
    until not self.atrListaMascotas.HaySiguiente ;
  end;
  arch:=TMascota.Create(pid,pNombre,pGenero,edad,gest,especie,raza);
  self.atrListaMascotas.agregar(arch);
  result:=TRUE;

end;

function TControlador.registrarPersona(pDNI, pNombre: String; pEdad: byte;
  pGenero: TAnimal.Tgenero; pDireccion: String): boolean;
var buscador,arch:TPersona;
begin
  if not self.atrListaPersonas.esVacia then begin
    self.atrListaPersonas.reset;
    repeat
      self.atrListaPersonas.siguiente;
      buscador:=self.atrListaPersonas.get as TPersona;
      if CompareStr(pDNI,buscador.DNI) = 0 then begin
        result:=FALSE;
        EXIT;
      end;
    until not self.atrListaPersonas.HaySiguiente ;
  end;
  arch:=TPersona.Create(pDNI,pNombre,pEdad,pGenero,pDireccion);
  self.atrListaPersonas.agregar(arch);
  result:=true;

end;

procedure TControlador.darEnAdopcion(idMascota, DNIPersona: String);
begin
  writeln('Hola');
end;

procedure TControlador.darDeBajaMascota(idMascota: String);
begin
  writeln('Hola');
end;

procedure TControlador.darDeBajaPersona(DNI: String);
begin
  writeln('Hola');
end;

function TControlador.listaDeMascotas(especie, raza: String): TListaArchivable;
var buscador,nuevo: TMascota;
begin
  result:=TListaArchivable.create;
  if not self.atrListaMascotas.esVacia then begin
    self.atrListaMascotas.reset;
    repeat
      self.atrListaMascotas.siguiente;
      buscador:= self.atrListaMascotas.get as TMascota;
      if (CompareStr(buscador.Especie,especie) = 0) and (CompareStr(buscador.Raza,raza) = 0) then begin
        nuevo:=buscador.clonar as TMascota;
        result.agregar(nuevo);
      end;
    until not self.atrListaEspeciesObj.HaySiguiente ;
  end;
end;

function TControlador.listaDeMascotas(DNIDuenno: String): TListaArchivable;
var buscador,nuevo: TMascota;
begin
  result:=TListaArchivable.create;
  if not self.atrListaMascotas.esVacia then begin
    self.atrListaMascotas.reset;
    repeat
      self.atrListaMascotas.siguiente;
      buscador:= self.atrListaMascotas.get;
      if (CompareStr(buscador.DuennoID,DNIDuenno) = 0) then begin
        nuevo:=buscador.clonar;
        result.agregar(nuevo);
      end;
    until not self.atrListaEspeciesObj.HaySiguiente ;
  end;
end;

function TControlador.listaDeEspecies: TStrings;
begin
  result:=self.atrListaEspeciesStr;
end;

function TControlador.listaDeRazas(especie: String): TStrings;
begin
  result:=self.atrListaEspeciesStr ;
end;

function TControlador.listaDePersonas: TListaArchivable;
begin
  result:=self.atrListaPersonas;
end;

initialization
TControlador.AtrInstance:=NIL;

end.

