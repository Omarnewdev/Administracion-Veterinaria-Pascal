unit dialogoRegistrarRaza;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TdialogoRegistrarRazaNueva }

  TdialogoRegistrarRazaNueva = class(TForm)
    botonAceptar: TButton;
    botonCancelar: TButton;
    comboBoxEspecies: TComboBox;
    campoNombreEspecie: TEdit;
    campoRaza: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure botonAceptarClick(Sender: TObject);
    procedure botonCancelarClick(Sender: TObject);
    procedure campoNombreEspecieEnter(Sender: TObject);
    procedure campoRazaEnter(Sender: TObject);
    procedure comboBoxEspeciesSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private

  public
    const MENSAJE_ESCRIBIR_ESPECIE= 'Escribe el nombre de la especie aqui...';
    const MENSAJE_ESCRIBIR_RAZA= 'Escribe el nombre de la raza aqui...';
  end;

var
  dialogoRegistrarRazaNueva: TdialogoRegistrarRazaNueva;

implementation
uses InterfazGrafica;

{$R *.lfm}

{ TdialogoRegistrarRazaNueva }

procedure TdialogoRegistrarRazaNueva.RadioButton1Change(Sender: TObject);
begin
    comboBoxEspecies.Enabled:= false;
    campoNombreEspecie.Enabled:= true;
end;

procedure TdialogoRegistrarRazaNueva.campoNombreEspecieEnter(Sender: TObject);
begin
    if(CompareText(campoNombreEspecie.Text,MENSAJE_ESCRIBIR_ESPECIE)=0) then
        campoNombreEspecie.Text:='';
end;

procedure TdialogoRegistrarRazaNueva.botonAceptarClick(Sender: TObject);
begin
    if (campoNombreEspecie.Text<>'') and (CompareText(campoNombreEspecie.Text,MENSAJE_ESCRIBIR_ESPECIE)<>0)
       and (CompareText(campoNombreEspecie.TExt,MENSAJE_ESCRIBIR_RAZA)<>0)
       and (campoRaza.text<>'') and (CompareText(campoRAza.text,MENSAJE_ESCRIBIR_ESPECIE)<>0)
       and (CompareText(campoRaza.text,MENSAJE_ESCRIBIR_RAZA)<>0) then begin
       if form1.atrControlador.registrarEspecie(campoNombreEspecie.Text,campoRaza.text) then
           showMessage('La espcie '+campoNombreEspecie.Text+' está registrada y vinculada a la raza '+campoRaza.Text+'.');
           self.ModalResult:= mrOK;
    end else begin
        ShowMessage('Verifica que hay un nombre de especie y uno de raza para registrar.');
    end;
end;

procedure TdialogoRegistrarRazaNueva.botonCancelarClick(Sender: TObject);
begin
    self.ModalResult:= mrCancel;
end;

procedure TdialogoRegistrarRazaNueva.campoRazaEnter(Sender: TObject);
begin
    if (CompareText(campoRaza.Text,MENSAJE_ESCRIBIR_RAZA)=0) then
        campoRaza.Text:= '';
end;

procedure TdialogoRegistrarRazaNueva.comboBoxEspeciesSelect(Sender: TObject);
begin
    campoNombreEspecie.Text:= comboBoxEspecies.Items.ValueFromIndex[comboBoxEspecies.ItemIndex];
end;

procedure TdialogoRegistrarRazaNueva.FormCreate(Sender: TObject);
var s: string;
begin
    campoRaza.Text:= MENSAJE_ESCRIBIR_RAZA;
    campoNombreEspecie.Text:= MENSAJE_ESCRIBIR_ESPECIE;
    if Form1.atrControlador.listaDeEspecies.Count<>0 then
        for s in Form1.atrControlador.listaDeEspecies do begin
            comboBoxEspecies.AddItem(s,nil);
        end;
end;

procedure TdialogoRegistrarRazaNueva.RadioButton2Click(Sender: TObject);
begin
    if comboBoxEspecies.Items.Count<>0 then begin
        comboBoxEspecies.Enabled:= true;
        campoNombreEspecie.Enabled:= false;
    end else begin
        RadioButton1.Checked:= true;
        ShowMessage('No hay especies en el sistema para vincular una raza.'+#13#10+'Crea una especie nueva.');
    end;
end;

end.

