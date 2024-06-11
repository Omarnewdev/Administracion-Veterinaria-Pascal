unit UArchivos;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils;

const
  directorySeparation = '\';// Cambie a '/' Si quieres usarlo en linux
type
    TListaArchivable = class;

    { TArchivable }

    TArchivable = class
      protected
            const_NOMBRE_DIRECTORIO_DATABASE: string; static;
            const_NOMBRE_ARCHIVO_ESPECIES: string; static;
            const_NOMBRE_ARCHIVO_MASCOTAS: string; static;
            const_NOMBRE_ARCHIVO_PERSONAS: string; static;

      public
        class function getNDB:String;
        class function getNAE:String;
        class function getNAM:String;
        class function getNAP:String;
        //Es la carpeta donde se encuentran los archivos
        property NOMBRE_DIRECTORIO_DATABASE:string read getNDB;
        //Es donde se guardan los archivos de la clase ESPECIES
        property NOMBRE_ARCHIVO_ESPECIES:string read getNAE;
        //Es donde se guardan los archivos de la clase MASCOTAS
        property NOMBRE_ARCHIVO_MASCOTAS:string read getNAM;
        //Es donde se guardan los archivos de la clase PERSONAS
        property NOMBRE_ARCHIVO_PERSONAS:string read getNAP;

        {guardarEnArchivo: Guarda el objeto actual en un archivo.
        Cada clase que hereda de TArchivable implementa esta operación a su manera.
        Se retorna TRUE si se pudo guardar la información, FALSE si no se pudo.
        El argumento direccionCompleta indica la dirección del archivo en el que se guardará
        la información, incluyendo el nombre y la extensión del mismo}
        function guardarEnArchivo(direccionCompleta:String):boolean; virtual;abstract;
        {clonar: Crea una copia limpia del objeto y la retorna en un nuevo objeto.}
        function clonar:TArchivable; virtual; abstract;
        {recuperarDeArchivo: Busca en el archivo dado por direccionCompleta (incluye nombre y extensión)
        el registro identificado con idBusqueda y retorna un objeto con su información.
        Cada clase implementa esta operación a su manera. Si no se encuentra el registro
        se retorna NIL.}
        class function recuperarDeArchivo(dirreccionCompleta,idBusqueda:String):TArchivable; virtual; abstract;
        {recuperarLista: Busca en la dirección dada (incluye nombre y extensión) todos los registros en el archivo,
        y retorna una lista con todos los objetos creados a partir de ellos.
        Cada clase implementa esta operación a su manera. Si no hay registros para leer,
        se retorna una lista vacía.}
        class function recuperarLista(direccionCompleta:string):TListaArchivable; virtual; abstract;
    end;

    { TListaArchivable }

    TListaArchivable = class
      private
        type

            { TNodo }

            TNodo = class
              strict private
                  atrContenido:TArchivable;
                  atrNext:TNodo;
                  procedure setArchivable(AValue: TArchivable);
              public
                constructor create(AValue:TArchivable); overload;
                destructor destroy; override;
                function getContenido:TArchivable;
                procedure setNext(nod:TNodo);
                function getNext:TNodo;
                procedure setContenido(cont:TArchivable);
                property Contenido: TArchivable read getContenido write setArchivable;
                property Next: TNodo read getNext write setNext;
            end;
      strict private
        atrNodo:TNodo;
        atrIterador:TNodo;
      public
        //Crea una lista de archivables, colocando el atrNodo y atrIterador en NIL
        constructor create; overload;
        //Elimina el objeto creado
        destructor destroy; override;
        //Agrega un archivo a la lista
        procedure agregar(const a:TArchivable);
        //Revisa si existe el archivo
        function existe(const a:TArchivable):boolean;
        //elimina el archivo pasado como argumento
        procedure quitar(const a:TArchivable);
        //Revisa si la lista es vacia
        function esVacia:boolean;
        //Devuelve el archivo de donde esta posicionado atrIterador
        function get:TArchivable;
        //Mueve el iterador
        procedure siguiente;
        //Revisa si hay un nodo donde pueda moverse el iterador
        function haySiguienteNodo:boolean;
        //Mueve el iterador al inicio
        procedure reset;

        property Vacia:boolean read esVacia;
        property Actual:TArchivable read get;
        property HaySiguiente:boolean read haySiguienteNodo;
    end;


implementation

{ TArchivable }

class function TArchivable.getNDB: String;
begin
  result:=self.const_NOMBRE_DIRECTORIO_DATABASE;
end;

class function TArchivable.getNAE: String;
begin
  result:=self.const_NOMBRE_ARCHIVO_ESPECIES;
end;

class function TArchivable.getNAM: String;
begin
  result:=self.const_NOMBRE_ARCHIVO_MASCOTAS;
end;

class function TArchivable.getNAP: String;
begin
  result:=self.const_NOMBRE_ARCHIVO_PERSONAS;
end;

{ TListaArchivable }

constructor TListaArchivable.create;
begin
  self.atrIterador := NIL;
  self.atrNodo:=NIL;
end;

destructor TListaArchivable.destroy;
begin
  inherited destroy;
end;

procedure TListaArchivable.agregar(const a: TArchivable);
var novo:TNodo;
begin
  novo:= TNodo.create(a);
  if self.esVacia then begin
    //Aqui el nodo literalmente se agraga en como nodo principal
    self.atrNodo:=novo;
  end else if self.atrIterador = NIL then begin
    //Aqui lo tenemos que agregar al inicio de la lista
    novo.Next:=self.atrNodo;
    self.atrNodo:=novo;
  end else if self.atrIterador.Next<>NIL then begin
    //Aqui el iterador esta en el medio de la lista
    novo.Next:=self.atrIterador.Next;
    self.atrIterador.Next:=novo;
  end else if self.atrIterador.Next = NIL then begin
    //Aqui el iterador esta en el final de la lista
    self.atrIterador.Next:=novo;
  end;
end;

function TListaArchivable.existe(const a: TArchivable): boolean;
var apuntador:TNodo; //Lo creamos para recorrer la lista
begin
  result:=FALSE;
  if self.esVacia then EXIT;
  apuntador:=self.atrNodo;
  while apuntador<>NIL do begin
    if apuntador.Contenido = a then begin
       result:=TRUE;
       EXIT;
    end;
    apuntador:=apuntador.Next;
  end;

end;

procedure TListaArchivable.quitar(const a: TArchivable);
var anterior,apuntador:TNodo; //Creados para recorrer la lista
begin
  if not self.existe(a) then EXIT;
  //Si existe tenemos que ubicarlo donde esta guardao
  apuntador:=self.atrNodo;
  anterior:=NIL;
  while apuntador<>NIL do begin
    if apuntador.Contenido = a then break;
    anterior:=apuntador;
    apuntador:=apuntador.Next;
  end;
  //Ahora tenemos que ubicar en parte de la lista esta
  if anterior = NIL then begin
     //El nodo a eliminar esta al inicio de la lista
     self.atrNodo:=self.atrNodo.Next;
  end else if (anterior<>NIL) and (apuntador<>NIL) then begin
     //El nodo a eliminar esta en el medio de la lista
     anterior.Next:=apuntador.Next;
  end else begin
     //Aquie el nodo esta al final de la lista
     anterior.Next:= NIL;
  end;
  apuntador.destroy;

end;

function TListaArchivable.esVacia: boolean;
begin
  result:= (self.atrNodo = NIL);
end;

function TListaArchivable.get: TArchivable;
begin
  result:=self.atrIterador.Contenido;
end;

procedure TListaArchivable.siguiente;
begin
  if self.atrIterador = NIL then begin
     //Aqui lo movemos al primer nodo
     self.atrIterador:=self.atrNodo;
  end else if self.haySiguienteNodo then begin
     //Lo movemos en medio de la lista
     self.atrIterador:=self.atrIterador.Next;
  end else begin
     //Significa que recorrimos todo la lista, entonces lo volvemos NIL el Iterador
    self.atrIterador:=NIL;
  end;
end;

function TListaArchivable.haySiguienteNodo: boolean;
begin
  result:=(self.atrIterador.Next <> NIL);
end;

procedure TListaArchivable.reset;
begin
  self.atrIterador:=self.atrNodo;
end;

{ TListaArchivable.TNodo }

procedure TListaArchivable.TNodo.setArchivable(AValue: TArchivable);
begin
  self.atrContenido := AValue;
end;

constructor TListaArchivable.TNodo.create(AValue: TArchivable);
begin
  self.atrContenido := AValue;
  self.atrNext := NIL;
end;

destructor TListaArchivable.TNodo.destroy;
begin
  FreeAndNil(self);
  inherited destroy;
end;

function TListaArchivable.TNodo.getContenido: TArchivable;
begin
  result:=self.atrContenido;
end;

procedure TListaArchivable.TNodo.setNext(nod: TNodo);
begin
  self.atrNext := nod;
end;

function TListaArchivable.TNodo.getNext: TNodo;
begin
  result:=self.atrNext;
end;

procedure TListaArchivable.TNodo.setContenido(cont: TArchivable);
begin
  self.atrContenido := cont;
end;


initialization
TArchivable.const_NOMBRE_DIRECTORIO_DATABASE:= 'database';
TArchivable.const_NOMBRE_ARCHIVO_ESPECIES:= 'especies.db';
TArchivable.const_NOMBRE_ARCHIVO_MASCOTAS:= 'mascotas.db';
TArchivable.const_NOMBRE_ARCHIVO_PERSONAS:= 'personas.db';

//Primero creamos el directorio si no existe
if not DirectoryExists(TArchivable.const_NOMBRE_DIRECTORIO_DATABASE) then
   CreateDir(TArchivable.const_NOMBRE_DIRECTORIO_DATABASE);


end.

