unit Interseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetodosAbiertos, MetodosCerrados, ParseMath, Dialogs;

type
  vector = array of real;
  TInterseccion=class
    public
      rows:Integer;
      presicion:real;
      Interseccion:vector;
      function Bolzano(x,xn:real):boolean;
      procedure execute(a1,b1:real;funtion:string);
      function biseccion(Ia:real;Ib:real;funtion:string):real;

    private
  end;

implementation
function TInterseccion.biseccion(Ia:real;Ib:real;funtion:string):real;
var
   fx:TParseMath;
   i:Integer;
   xn:real;
begin
   i:=0;
   fx := TParseMath.create();
   fx.Expression := funtion;
   fx.AddVariable('x',0);

   while(i<4) do
   begin
     xn:=(Ia+Ib)/2;
     fx.NewValue('x',xn);
     if(Ia*fx.Evaluate()<0) then
     begin
       Ib:=xn;
     end
     else
     begin
       Ia:=xn;
     end;
     i:=i+1;
   end;
   Result:=xn;
end;

function TInterseccion.Bolzano(x,xn:real):boolean;
begin
   if(x*xn<0) then
   begin
     Result:=True;
   end
   else
   begin
     Result:=False;
   end;
end;

procedure TInterseccion.execute(a1,b1:real;funtion:string);
var
  cont,i,ii:Integer;
  h:real;
  Ia,Ib,temp1,temp2:real;
  Puntos:vector;
  MetodoAbierto:TMetodoAbiertos;
  MetodoCerrado:TMetodosCerrados;
  fx:TParseMath;
begin
   MetodoAbierto:=TMetodoAbiertos.Create;
   MetodoCerrado:=TMetodosCerrados.create(funtion);
   h := 0.3;
   fx := TParseMath.create();
   fx.Expression := funtion;
   fx.AddVariable('x',0);
   SetLength(puntos,50);
   SetLength(Interseccion,50);
   rows:=0;
   i:=0;
   cont:=0;
   Ia:=a1;
   Ib:=a1+h;
   while(Ib<=b1) do
   begin
     fx.NewValue('x',Ia);
     temp1:=fx.Evaluate();
     fx.NewValue('x',Ib);
     temp2:=fx.Evaluate();

     if(Bolzano(temp1,temp2)=True) then
     begin
       Puntos[i]:=MetodoCerrado.MBiseccion(Ia,Ib,presicion,4);
       i:=i+1;
       cont:=cont+1;
     end;
     Ia:=Ib;
     Ib:=Ib+h;
   end;
   if(cont=0) then
   begin
     ShowMessage('No hay Interseccion de las f(x) y g(x) en el Intervalo');
     exit();
   end;

   for i:=0 to cont-1 do
   begin
     if((Puntos[i]>=a1) and (Puntos[i]<=b1)) then
     begin
       Interseccion[rows]:=MetodoAbierto.Secante(Puntos[i],presicion,funtion);
       rows:=rows+1;
     end;
   end;
end;

end.

