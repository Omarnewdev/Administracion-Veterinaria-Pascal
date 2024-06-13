unit InterfazGrafica;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, Grids,
  UArchivos, UControlador, dialogoRegistrarRaza, UAnimales, UPersonas,
  U_dialogoRegistrarMascota, U_dialogoRegistrarPersona;

type

  { TForm1 }

  TForm1 = class(TForm)
    botonCrearEspecie: TButton;
    botonRegistrarMascota: TButton;
    botonAdoptar: TButton;
    botonDarDeBajaMascota: TButton;
    botonRegistrarPersona: TButton;
    botonDarDeBajaPersona: TButton;
    botonSalir: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Mascotas: TLabel;
    listaEspecies: TListBox;
    listaRazas: TListBox;
    areaFicha: TMemo;
    MenuPrincipal: TMainMenu;
    menuArchivo: TMenuItem;
    menuPersonas_DarDeBaja: TMenuItem;
    menuMascotas: TMenuItem;
    menuPersonas: TMenuItem;
    menuArchivo_Salir: TMenuItem;
    menuMascotas_CrearEspecie: TMenuItem;
    menuMascotas_Registrar: TMenuItem;
    menuMasctoas_Adoptar: TMenuItem;
    menuMascotas_DarDeBaja: TMenuItem;
    menuPersonas_Registrar: TMenuItem;
    tablaMascotas: TStringGrid;
    tablaMascotasDePersona: TStringGrid;
    tablaPersonas: TStringGrid;
    procedure botonAdoptarClick(Sender: TObject);
    procedure botonCrearEspecieClick(Sender: TObject);
    procedure botonDarDeBajaMascotaClick(Sender: TObject);
    procedure botonDarDeBajaPersonaClick(Sender: TObject);
    procedure botonRegistrarMascotaClick(Sender: TObject);
    procedure botonRegistrarPersonaClick(Sender: TObject);
    procedure botonSalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure listaEspeciesSelectionChange(Sender: TObject; User: boolean);
    procedure listaRazasSelectionChange(Sender: TObject; User: boolean);
    procedure menuArchivo_SalirClick(Sender: TObject);
    procedure menuMascotas_CrearEspecieClick(Sender: TObject);
    procedure menuMascotas_DarDeBajaClick(Sender: TObject);
    procedure menuMascotas_RegistrarClick(Sender: TObject);
    procedure menuMasctoas_AdoptarClick(Sender: TObject);
    procedure menuPersonas_DarDeBajaClick(Sender: TObject);
    procedure menuPersonas_RegistrarClick(Sender: TObject);
    procedure tablaMascotasSelection(Sender: TObject; aCol, aRow: Integer);
    procedure tablaPersonasSelection(Sender: TObject; aCol, aRow: Integer);
  private
      atrListaMascotasPorEspecie,
      atrListaMascotasPorDuenno,
      atrListaPersonas: TListaArchivable;
  public
      atrControlador: IControlador;
      procedure actualizarEspeciesYRazas;
      procedure actualizarTablasDeMascotas;
      procedure actualizarTablaPersonas;
      procedure reiniciarTablaPersonas;
      procedure reiniciarTablaMascotasPorEspecie;
      procedure reiniciarTablaMascotasPorPersona;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.menuArchivo_SalirClick(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TForm1.menuMascotas_CrearEspecieClick(Sender: TObject);
begin
    botonCrearEspecieClick(sender);
end;

procedure TForm1.menuMascotas_DarDeBajaClick(Sender: TObject);
begin
    botonDarDeBajaMascotaClick(sender);
end;

procedure TForm1.menuMascotas_RegistrarClick(Sender: TObject);
begin
    botonRegistrarMascotaClick(sender);
end;

procedure TForm1.menuMasctoas_AdoptarClick(Sender: TObject);
begin
    botonAdoptarClick(sender);
end;

procedure TForm1.menuPersonas_DarDeBajaClick(Sender: TObject);
begin
    botonDarDeBajaPersonaClick(sender);
end;

procedure TForm1.menuPersonas_RegistrarClick(Sender: TObject);
begin
    botonRegistrarPersonaClick(sender);
end;

procedure TForm1.tablaMascotasSelection(Sender: TObject; aCol, aRow: Integer);
var listadoMascotas: TListaArchivable;
    m: TMascota;
    especieString, razaString: string;
begin
    especieString:= listaEspecies.Items.ValueFromIndex[listaEspecies.ItemIndex];
    razaString:= listaRazas.Items.ValueFromIndex[listaRazas.ItemIndex];
    listadoMascotas:= atrControlador.listaDeMascotas(especieString,razaString);
    listadoMascotas.reset;

    m:= nil;
    while listadoMascotas.HaySiguiente do begin
        m:= listadoMascotas.Actual as TMascota;
        if (CompareText(m.ID,tablaMascotas.Cells[0,aRow])=0) then begin
            break;
        end;
        m:= nil;
        listadoMascotas.siguiente;
    end;

    if m<>nil then areaFicha.Text:= m.getFicha;
end;

procedure TForm1.tablaPersonasSelection(Sender: TObject; aCol, aRow: Integer);
var misMascotas: TListaArchivable;
begin
    actualizarTablasDeMascotas
    {misMascotas:= atrControlador.listaDeMascotas(tablaPersonas.Cells[3,tablaPersonas.Row]);
    misMascotas.reset;
    while misMascotas.HaySiguiente do begin
        actualizarTablasDeMascotas;
        misMascotas.siguiente;
    end;  }
end;

procedure TForm1.actualizarEspeciesYRazas;
var especieGuardada, especieEnLista: string;
    agregarAListaVisible: boolean;
begin
    for especieGuardada in atrControlador.listaDeEspecies do begin
        agregarAListaVisible:= true;
        for especieEnLista in listaEspecies.Items do begin
            if CompareText(especieGuardada,especieEnLista)=0 then begin
                agregarAListaVisible:= false;
                break;
            end;
        end;

        if agregarAListaVisible then
           listaEspecies.Items.Add(especieGuardada);
    end;
end;

procedure TForm1.actualizarTablasDeMascotas;
var especieString, razaString, personaID: string;
    listaMascotas: TListaArchivable;
    i: integer;
    m: TMascota;
begin
    if (listaEspecies.ItemIndex>0) and (listaRazas.ItemIndex>0) then begin;
        especieString:= listaEspecies.Items.ValueFromIndex[listaEspecies.ItemIndex];
        razaString:= listaRazas.Items.ValueFromIndex[listaRazas.ItemIndex];
        listaMascotas:= atrControlador.listaDeMascotas(especieString,razaString);
        listaMascotas.reset;
        reiniciarTablaMascotasPorEspecie;
        i:= 1;
        while listaMascotas.HaySiguiente do begin
            m:= listaMascotas.Actual as TMascota;
            tablaMascotas.InsertRowWithValues(i,[m.ID,m.Nombre]);
            i+= 1;
            listaMascotas.siguiente;
        end;
        FreeAndNil(listaMascotas);
    end;

    if (tablaPersonas.Row>0) then begin
        personaID:= tablaPersonas.Cells[0,tablaPersonas.row];
        listaMascotas:= atrControlador.listaDeMascotas(personaID);
        listaMascotas.reset;
        reiniciarTablaMascotasPorPersona;
        i:= 1;
        while listaMascotas.HaySiguiente do begin
            m:= listaMascotas.Actual as TMascota;
            tablaMascotasDePersona.InsertRowWithValues(i,[m.ID,m.Nombre]);
            i+= 1;
            listaMAscotas.siguiente;
        end;
        FreeAndNil(listaMascotas);
    end;
end;

procedure TForm1.actualizarTablaPersonas;
var p: TPersona;
    i: integer;
begin
    atrListaPersonas.reset;
    reiniciarTablaPersonas;

    i:=1;
    while atrListaPersonas.HaySiguiente do begin
        p:= atrListaPersonas.Actual as TPersona;

        tablaPersonas.InsertRowWithValues(i,[p.Nombre,IntToStr(p.Edad),p.GeneroStr,p.DNI,p.Direccion]);

        i+= 1;
        atrListaPersonas.siguiente;
    end;
end;

procedure TForm1.reiniciarTablaPersonas;
begin
    while tablaPersonas.RowCount>1 do begin
        tablaPersonas.DeleteRow(1);
    end;
end;

procedure TForm1.reiniciarTablaMascotasPorEspecie;
begin
    while tablaMascotas.RowCount>1 do begin
        tablaMascotas.DeleteRow(1);
    end;
end;

procedure TForm1.reiniciarTablaMascotasPorPersona;
begin
    while tablaMascotasDePersona.RowCount>1 do begin
        tablaMascotasDePersona.DeleteRow(1);
    end;
end;

procedure TForm1.botonSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.botonRegistrarMascotaClick(Sender: TObject);
begin
    Application.CreateForm(TdialogoRegistrarMascota,dialogoRegistrarMascota);
    if dialogoRegistrarMascota.ShowModal=mrOK then begin
        reiniciarTablaMascotasPorEspecie;
        actualizarTablasDeMascotas;
    end;
    FreeAndNil(dialogoRegistrarMascota);
end;

procedure TForm1.botonRegistrarPersonaClick(Sender: TObject);
begin
    Application.CreateForm(TcuadroRegistrarPersona,cuadroRegistrarPersona);
    if cuadroRegistrarPersona.ShowModal=mrOK then begin
        reiniciarTablaPersonas;
        actualizarTablaPersonas;
    end;
    FreeAndNil(cuadroRegistrarPersona);
end;

procedure TForm1.botonCrearEspecieClick(Sender: TObject);
begin
  Application.CreateForm(TdialogoRegistrarRazaNueva,dialogoRegistrarRazaNueva);
  if dialogoRegistrarRazaNueva.ShowModal=mrOK then begin
      actualizarEspeciesYRazas;
  end;
  FreeAndNil(dialogoRegistrarRazaNueva);
end;

procedure TForm1.botonAdoptarClick(Sender: TObject);
begin
    showMessage('Esta función había sido pensada inicialmente pero luego se desechó.'+#13#10+'Quizá cuando sepas hacer tus propias GUIs te aventuras a programarla por tí mismo/a.');
end;

procedure TForm1.botonDarDeBajaMascotaClick(Sender: TObject);
begin
    showMessage('Esta función había sido pensada inicialmente pero luego se desechó.'+#13#10+'Quizá cuando sepas hacer tus propias GUIs te aventuras a programarla por tí mismo/a.');
end;

procedure TForm1.botonDarDeBajaPersonaClick(Sender: TObject);
begin
    showMessage('Esta función había sido pensada inicialmente pero luego se desechó.'+#13#10+'Quizá cuando sepas hacer tus propias GUIs te aventuras a programarla por tí mismo/a.');
end;

procedure TForm1.FormCreate(Sender: TObject);
var s: string;
begin
    atrControlador:= TControlador.getInstacia;
    actualizarEspeciesYRazas;
    atrListaMascotasPorEspecie:= TListaArchivable.Create;
    atrListaMascotasPorDuenno:= TListaArchivable.Create;
    atrListaPersonas:= atrControlador.listaDePersonas;
    actualizarTablaPersonas;
end;

procedure TForm1.listaEspeciesSelectionChange(Sender: TObject; User: boolean);
begin
    listaRazas.Items:= atrControlador.listaDeRazas(listaEspecies.Items.ValueFromIndex[listaEspecies.ItemIndex]);
end;

procedure TForm1.listaRazasSelectionChange(Sender: TObject; User: boolean);
var rowIndex: integer;
    m: TMascota;
begin
    FreeAndNil(atrListaMascotasPorEspecie);
    atrListaMascotasPorEspecie:= atrControlador.listaDeMascotas(
                                     listaEspecies.Items.ValueFromIndex[listaEspecies.ItemIndex],
                                     listaRazas.Items.ValueFromIndex[listaRazas.ItemIndex]
                                 );
    atrListaMascotasPorEspecie.reset;

    reiniciarTablaMascotasPorEspecie;

    rowIndex:= 1;
    while atrListaMascotasPorEspecie.HaySiguiente do begin
        m:= atrListaMascotasPorEspecie.Actual as TMascota;
        tablaMascotas.InsertRowWithValues(rowIndex,[m.ID,m.Nombre]);
        rowIndex+=1;
        atrListaMascotasPorEspecie.siguiente;
    end;
end;

end.

