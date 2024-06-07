unit UArchivos;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils;


type
    TListaArchivable = class;

    { TArchivable }

    TArchivable = class
      private
            const_NOMBRE_DIRECTORIO_DATABASE: string; static;
            const_NOMBRE_ARCHIVO_ESPECIES: string; static;
            const_NOMBRE_ARCHIVO_MASCOTAS: string; static;
            const_NOMBRE_ARCHIVO_PERSONAS: string; static;
            class function getNDB:String;
            class function getNAE:String;
            class function getNAM:String;
            class function getNAP:String;
      public

        property NOMBRE_DIRECTORIO_DATABASE:string read getNDB;
        property NOMBRE_ARCHIVO_ESPECIES:string read getNAE;
        property NOMBRE_ARCHIVO_MASCOTAS:string read getNAM;
        property NOMBRE_ARCHIVO_PERSONAS:string read getNAP;

        function guardarEnArchivo(direccionCompleta:String):boolean; virtual;abstract;
        function clonar:TArchivable; virtual; abstract;
        function recuperarDeArchivo(dirreccionCompleta,idBusqueda:String):TArchivable; virtual; abstract;
        function recuperarLista(direccionCompleta:string):TListaArchivable; virtual; abstract;
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
        constructor create; overload;
        destructor destroy; override;
        procedure agregar(const a:TArchivable);
        function existe(const a:TArchivable):boolean;
        procedure quitar(const a:TArchivable);
        function esVacia:boolean;
        function get:TArchivable;
        //Mueve el iterador
        procedure siguiente;
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
begin

end;

function TListaArchivable.existe(const a: TArchivable): boolean;
begin

end;

procedure TListaArchivable.quitar(const a: TArchivable);
begin

end;

function TListaArchivable.esVacia: boolean;
begin

end;

function TListaArchivable.get: TArchivable;
begin

end;

procedure TListaArchivable.siguiente;
begin

end;

function TListaArchivable.haySiguienteNodo: boolean;
begin

end;

procedure TListaArchivable.reset;
begin

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



end.

