unit U_dialogoRegistrarPersona;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TcuadroRegistrarPersona }

  TcuadroRegistrarPersona = class(TForm)
    botonRegistrar: TButton;
    botonCancelar: TButton;
    comboBoxGenero: TComboBox;
    campoDNI: TEdit;
    campoNombre: TEdit;
    campoEdad: TEdit;
    campoDireccion: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure botonCancelarClick(Sender: TObject);
    procedure botonRegistrarClick(Sender: TObject);
  private

  public

  end;

var
  cuadroRegistrarPersona: TcuadroRegistrarPersona;

implementation
uses UAnimales, interfazgrafica;

{$R *.lfm}

{ TcuadroRegistrarPersona }

procedure TcuadroRegistrarPersona.botonCancelarClick(Sender: TObject);
begin
    self.ModalResult:= mrCancel;
end;

procedure TcuadroRegistrarPersona.botonRegistrarClick(Sender: TObject);
var tipoGenero: TAnimal.TGenero;
    generoString: string;
begin
    if (campoDNI.Text<>'') and (campoNombre.Text<>'') and (campoEdad.Text<>'') and
    (StrToInt(campoEdad.Text)>0) and (StrToInt(campoEdad.Text)<100) and
    (comboBoxGenero.ItemIndex>=0) and (campoDireccion.Text<>'') then begin
        generoString:= comboBoxGenero.Items.ValueFromIndex[comboBoxGenero.ItemIndex];

        if CompareText(generoString,'Masculino')=0 then
            tipoGenero:= TAnimal.TGenero.PERSONA_MASCULINO
        else
            tipoGenero:= TAnimal.TGenero.PERSONA_FEMENINO;

        if form1.atrControlador.registrarPersona(campoDNI.text,campoNombre.text,StrToInt(campoEdad.text),tipoGenero,campoDireccion.Text) then begin
            ShowMessage('La persona se ha registrado correctamente.');
            self.ModalResult:= mrOK;
        end else begin
            ShowMessage('Ha ocurrido un error y no se ha podido registrar la persona.');
        end;
    end else begin
        ShowMessage('Todos los campos son requeridos, además la edad no puede ser negativa ni mayor a 100.');
    end;
end;

end.

