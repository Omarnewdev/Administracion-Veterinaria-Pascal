unit U_dialogoRegistrarMascota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TdialogoRegistrarMascota }

  TdialogoRegistrarMascota = class(TForm)
    botonRegistrar: TButton;
    botonCancelar: TButton;
    campoID: TEdit;
    comboBoxGenero: TComboBox;
    comboBoxGestacion: TComboBox;
    comboBoxEspecie: TComboBox;
    comboBoxRaza: TComboBox;
    campoNombre: TEdit;
    campoEdad: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure botonCancelarClick(Sender: TObject);
    procedure botonRegistrarClick(Sender: TObject);
    procedure comboBoxEspecieSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  dialogoRegistrarMascota: TdialogoRegistrarMascota;

implementation

uses InterfazGrafica, UAnimales;

{$R *.lfm}

{ TdialogoRegistrarMascota }

procedure TdialogoRegistrarMascota.FormCreate(Sender: TObject);
var s: string;
begin
    self.comboBoxEspecie.Clear;
    self.comboBoxEspecie.Text:= 'Selecciona una especie...';
    for s in Form1.atrControlador.listaDeEspecies do begin
       Self.comboBoxEspecie.AddItem(s,nil);
    end;
end;

procedure TdialogoRegistrarMascota.botonCancelarClick(Sender: TObject);
begin
    self.ModalResult:= mrCancel;
end;

procedure TdialogoRegistrarMascota.botonRegistrarClick(Sender: TObject);
var tipoGenero: TAnimal.TGenero;
    tipoGestacion: TAnimal.TGestacion;
    generoString, gestacionString, especieString, razaString: string;
begin
    if (campoID.Text<>'') and (campoNombre.Text<>'') and (campoEdad.Text<>'') and
    (StrToInt(campoEdad.Text)>0) and (StrToInt(campoEdad.Text)<200) and
    (comboBoxGenero.ItemIndex>=0) and (comboBoxGestacion.ItemIndex>=0) and
    (comboBoxEspecie.ItemIndex>=0) and (comboBoxRaza.ItemIndex>=0) then begin
        generoString:= comboBoxGenero.Items.ValueFromIndex[comboBoxGenero.ItemIndex];
        gestacionString:= comboBoxGestacion.Items.ValueFromIndex[comboBoxGestacion.ItemIndex];
        especieString:= comboBoxEspecie.Items.ValueFromIndex[comboBoxEspecie.ItemIndex];
        razaString:= comboBoxRAza.Items.ValueFromIndex[comboBoxRAza.ItemIndex];

        if CompareText(generoString,'Macho')=0 then
            tipoGenero:= TAnimal.TGenero.ANIMAL_MACHO
        else
            tipoGenero:= TAnimal.TGenero.ANIMAL_HEMBRA;

        if CompareText(gestacionString,'Ovíparo')=0 then
            tipoGestacion:= TAnimal.TGestacion.OVIPARO
        else
            tipoGestacion:= TAnimal.TGestacion.VIVIPARO;

        if form1.atrControlador.registrarMascota(campoId.Text,campoNombre.Text,
        tipoGenero,StrToInt(campoEdad.Text),tipoGestacion,especieString,razaString) then begin
            ShowMessage('La mascota se ha registrado correctamente.');
            self.ModalResult:= mrOK;
        end else begin
            ShowMessage('Ha ocurrido un error y no se ha podido registrar la mascota.');
        end;
    end else begin
        ShowMessage('Todos los campos son requeridos, además la edad no puede ser negativa ni mayor a 200.');
    end;
end;

procedure TdialogoRegistrarMascota.comboBoxEspecieSelect(Sender: TObject);
var s: string;
begin
    self.comboBoxRaza.Clear;
    self.comboBoxRaza.Text:= 'Selecciona una raza...';
    for s in Form1.atrControlador.listaDeRazas(self.comboBoxEspecie.Items.ValueFromIndex[self.comboBoxEspecie.ItemIndex]) do begin
        self.comboBoxRaza.AddItem(s,nil);
    end;

end;

end.

