Unit Evaluador;


Interface

Uses
crt, analizadorSintactico, analizador_Lexico, math, sysutils;

Const
    MaxVar =   200;
    MaxReal =   200;
    MaxArreglo =   100;

Type
    TTipo =   (Treal,Tarreglo);

    TElemEstado =   Record
        lexemaId:   string;
        ValReal:   real;
        Tipo:   TTipo;
        ValArray:   array[1..MaxArreglo] Of real;
        CantArray:   byte;

    End;
    TEstado =   Record
        elementos:   array [1..maxVar] Of TElemEstado;
        cant:   word;
    End;

    // EVALUADORES
Procedure InicializarEst(Var Estado:TEstado);
Function ValorDe(Var E:TEstado; lexemaid:String; indice:byte):   real;
Procedure evalLenguaje(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalL_2(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalL_3(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalTitulo(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure agregarVar(Var E:tEstado; Var lexemaId:String; Var tipo:TTipo);
Procedure agregarArray(Var arbol:TapuntNodo;Var E:tEstado; Var lexemaId:String; tam:byte; tipo:TTipo);
Procedure evalDefiniciones(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalD_2(Var arbol:TApuntNodo; Var estado:tEstado; lexemaId:String);
Procedure evalD_3(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalCuerpo(Var arbol:TApuntNodo; Var estado:tEstado; resultado:boolean);
Procedure evalC2(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalSent(Var arbol:TApuntNodo; Var estado:tEstado);
Function transformacionReal(lexema: String):   real;
Procedure evalAsig(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalAsig_2(Var arbol:TApuntNodo; Var estado:TEstado; lexemaId:String);
Procedure evalAsig_3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Procedure evalElem_V(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalElem_V2(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalopArit(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Procedure evalSOA(Var arbol:TApuntNodo; Var estado:tEstado;Var op1:real ;Var resultado:real);
Procedure evalOA2(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Procedure evalSOA2(Var arbol:TApuntNodo; Var estado:tEstado;Var op1:real; Var resultado:real);
Procedure evalOA3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Procedure evalPot(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Procedure evalArreglo(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real; lexemaId:String);
Procedure evalNum_p(Var arbol:TApuntNodo; Var estado:tEstado; Var base:real; Var exponente:real);
Procedure evalCondi(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalOtro(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado: boolean);
Procedure evalValor_B(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado: boolean);
Procedure evalSOL(Var arbol:TApuntNodo; Var estado:tEstado;Var aux:boolean ;Var resultado:   boolean);
Procedure evalOL2(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:   boolean);
Procedure evalSOL2(Var arbol:TApuntNodo; Var estado:tEstado;Var aux:boolean; Var resultado:   boolean);
Procedure evalOL3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:   boolean);
Procedure evalLeer(Var arbol:   TApuntNodo; Var estado:   tEstado);
Procedure evalImprimir(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalMostrar(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalSM(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalSM2(Var arbol:TApuntNodo; Var estado:tEstado);
Procedure evalCiclo(Var arbol:TApuntNodo; Var estado:tEstado);



Implementation
Procedure InicializarEst(Var Estado:TEstado);
Begin
    Estado.cant := 0;
End;

Function transformacionReal(lexema: String):   real;

Var
    valor:   real;
    codigo:   integer;
Begin
    valor := 0 ;
    val(lexema, valor, codigo);
    transformacionReal := valor;
End;
Function ValorDe(Var E:TEstado; lexemaid:String; indice:byte):   real;

Var i:   integer;
Begin
    For i:=1 To E.cant Do
        Begin

            If AnsiLowerCase(E.elementos[i].lexemaId) = AnsiLowerCase(lexemaId) Then
                Begin
                    If E.elementos[i].Tipo = Treal Then
                        Begin
                            valorDe := E.elementos[i].ValReal;
                        End
                    Else            //si es un array
                        Begin
                            valorDe := E.elementos[i].valArray[indice];
                        End;
                End;

        End;
End;

Procedure agregarVar(Var E:tEstado; Var lexemaId:String; Var tipo:TTipo);
Begin
    E.cant := E.cant+1;
    E.elementos[E.cant].lexemaId := lexemaId;
    E.elementos[E.cant].valReal := 0;
    E.elementos[E.cant].Tipo := tipo;
    E.elementos[E.cant].CantArray := 0;
    // deberia ser 1 o 0 el tamaño? porque seria una caja adentro de otra
End;

Procedure agregarArray(Var arbol:TapuntNodo;Var E:tEstado; Var lexemaId:String; tam:byte; tipo:TTipo);

Var
    i:   byte;
    resultado:   real;
Begin
    E.cant := E.cant+1;
    E.elementos[E.cant].lexemaId := lexemaId;
    For i:=1 To tam Do
        E.elementos[E.cant].valArray[i] := 0;
    E.elementos[E.cant].CantArray := floor(tam);
    E.elementos[E.cant].tipo := tipo;
End;

Procedure AsignarValor(lexemaId:String; Var E:tEstado; indice:byte; valor:real);

Var i:   integer;
Begin
    For i:=1 To E.cant Do
        Begin

            If AnsiLowerCase(E.elementos[i].lexemaId) = AnsiLowerCase(lexemaId) Then
                Begin
                    If E.elementos[i].Tipo = Treal Then
                        Begin
                            E.elementos[i].ValReal := valor;
                        End
                    Else            //si es un array
                        Begin
                            E.elementos[i].valArray[indice] := valor;
                        End;
                End;

        End;
End;
//<Lenguaje> -> "Program" <L_2>
Procedure evalLenguaje(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    evalL_2(arbol^.hijos.elem[2], estado);
End;

//<L_2> -> <Titulo> <L_3>
Procedure evalL_2(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    evalTitulo(arbol^.hijos.elem[1], estado);
    evalL_3(arbol^.hijos.elem[2], estado);
End;

//<L_3> -> “def” <Definiciones> “;” "{"<Cuerpo>"}" |  "{"<Cuerpo>"}"
Procedure evalL_3(Var arbol:TApuntNodo; Var estado:tEstado);

Var a:   boolean;
Begin
    a := True;
    Case arbol^.hijos.elem[1]^.simbolo Of
        Tdef:
                Begin
                    evalDefiniciones(arbol^.hijos.elem[2], estado);
                    evalCuerpo(arbol^.hijos.elem[5], estado, a);
                End;
        TLlav_ab:   evalCuerpo(arbol^.hijos.elem[5], estado,a);


    End;
End;

//<Titulo> -> "title" "cad" ";" | epsilon
Procedure evalTitulo(Var arbol:TApuntNodo; Var estado:tEstado);
Begin

End;

//<Definiciones> -> "id" <D_2>
Procedure evalDefiniciones(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    If arbol^.hijos.elem[1]^.simbolo = Tid Then
        Begin
            evalD_2(arbol^.hijos.elem[2], estado,arbol^.hijos.elem[1]^.lexema);
        End;
End;

//<D_2> -> “,” <Definiciones> |  "array" "[" <OpArit> "]" <D_3> | epsilon
Procedure evalD_2(Var arbol:TApuntNodo; Var estado:tEstado; lexemaId:String);
// evalua si lo que sigue es otra definicion o si la nueva variable es un tarray

Var
    tipo:   ttipo;
    indice:   real;
Begin
    tipo := Treal;
    If arbol^.hijos.cant > 0 Then
        Begin
            Case arbol^.hijos.elem[1]^.simbolo Of
                Tcoma:
                         Begin
                             agregarVar(estado, lexemaId, tipo);
                             evalDefiniciones(arbol^.hijos.elem[2], estado);
                         End;
                Tarray:
                          Begin
                              tipo := Tarreglo;
                              evalOpArit(arbol^.hijos.elem[3], estado, indice);
                              // aca modificamos el coso para pasar de real a byte
                              agregarArray(arbol,estado, lexemaId, floor(indice), tipo);
                              evalD_3(arbol^.hijos.elem[5], estado);

                          End;
            End;
        End
    Else

        agregarVar(estado, lexemaId, tipo);
End;

//<D_3> -> "," <Definiciones> | epsilon
Procedure evalD_3(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    If arbol^.hijos.cant > 0 Then
        evalDefiniciones(arbol^.hijos.elem[2], estado);
End;

//<Cuerpo> -> <Sent> <C2>
Procedure evalCuerpo(Var arbol:TApuntNodo; Var estado:tEstado; resultado:boolean);
Begin
    If resultado Then
        Begin
            evalSent(arbol^.hijos.elem[1], estado);
            evalC2(arbol^.hijos.elem[2], estado);
        End;
End;

//<C2> -> ";" <Cuerpo> | epsilon
Procedure evalC2(Var arbol:TApuntNodo; Var estado:tEstado);

Var a :   boolean;
Begin
    If arbol^.hijos.cant > 0 Then
        evalCuerpo(arbol^.hijos.elem[2], estado,True);
End;

//<Sent> -> <Asig> | <Condi> | <Leer> | <Imprimir> | <Ciclo>
Procedure evalSent(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        VAsig:   evalAsig(arbol^.hijos.elem[1], estado);
        VCondi:   evalCondi(arbol^.hijos.elem[1], estado);
        VLeer:   evalLeer(arbol^.hijos.elem[1], estado);
        VImprimir:   evalImprimir(arbol^.hijos.elem[1], estado);
        VCiclo:   evalCiclo(arbol^.hijos.elem[1], estado);
    End;
End;

//<Asig> -> “id” <Asig_2>
Procedure evalAsig(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    If arbol^.hijos.elem[1]^.simbolo = Tid Then
        Begin
            evalAsig_2(arbol^.hijos.elem[2], estado,arbol^.hijos.elem[1]^.lexema);
        End;
End;

//<Asig_2> -> "["  <opArit> "]" "=" <Asig_3> | “=” <Asig_3>
Procedure evalAsig_2(Var arbol:TApuntNodo; Var estado:TEstado; lexemaId:String);

Var indice,valor:   real;
Begin

    Case arbol^.hijos.elem[1]^.simbolo Of
        TCorr_ab :
                     Begin
                         evalopArit(arbol^.hijos.elem[2], estado, indice);
                         evalAsig_3(arbol^.hijos.elem[5], estado, valor);
                         AsignarValor(lexemaId,estado,floor(indice),valor);
                     End;

        TAsig :
                  Begin
                      evalAsig_3(arbol^.hijos.elem[2], estado, valor);
                      AsignarValor(lexemaId,estado,0,valor);

                  End;
    End;

End;

//<Asig_3> -> <opArit> | “[“<Elem_V> “]”
Procedure evalAsig_3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Begin
    If arbol^.hijos.elem[1]^.simbolo = TCorr_ab Then
        evalElem_V(arbol^.hijos.elem[2], estado)
    Else
        evalopArit(arbol^.hijos.elem[1], estado, resultado);
End;

//<Elem_V> -> <OpArit> <Elem_V2>
Procedure evalElem_V(Var arbol:TApuntNodo; Var estado:tEstado);

Var resultado:   real;
Begin
    evalOpArit(arbol^.hijos.elem[1], estado, resultado);
    evalElem_V2(arbol^.hijos.elem[2], estado);
End;

//<Elem_V2> -> “,” <Elem_V> | epsilon
Procedure evalElem_V2(Var arbol:TApuntNodo; Var estado:tEstado);
Begin
    If arbol^.hijos.cant > 0 Then
        evalElem_V(arbol^.hijos.elem[2], estado);
End;

//<opArit> -> <OA2> <SOA>
Procedure evalopArit(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);

Var op1:   real;
Begin
    evalOA2(arbol^.hijos.elem[1], estado, op1);
    evalSOA(arbol^.hijos.elem[2], estado, op1, resultado);
End;
//<SOA> -> “+”<OA2> <SOA> | “-”<OA2> <SOA> | epsilon
Procedure evalSOA(Var arbol:TApuntNodo; Var estado:tEstado;Var op1:real ;Var resultado:real);

Var op2:   real;
Begin
    If  arbol^.hijos.cant > 0 Then
        Begin
            Case arbol^.hijos.elem[1]^.simbolo Of
                Tmas:
                        Begin
                            evalOA2(arbol^.hijos.elem[2], estado, op2);
                            op1 := op1+op2;
                            evalSOA(arbol^.hijos.elem[3], estado, op1,resultado);
                        End;
                Tmenos:
                          Begin
                              evalOA2(arbol^.hijos.elem[2], estado, op2);
                              op1 := op1-op2;
                              evalSOA(arbol^.hijos.elem[3], estado, op1,resultado);
                          End;


            End;
        End
    Else
        resultado := op1;
End;
//<OA2> -> <OA3> <SOA2>
Procedure evalOA2(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);

Var op1:   real;
Begin
    evalOA3(arbol^.hijos.elem[1], estado, op1);
    evalSOA2(arbol^.hijos.elem[2], estado, op1,resultado);
End;

//<SOA2> ->  "*" <OA3><SOA2> |  "/" <OA3><SOA2> | epsilon
Procedure evalSOA2(Var arbol:TApuntNodo; Var estado:tEstado;Var op1:real; Var resultado:real);

Var op2:   real;
Begin
    If  arbol^.hijos.cant > 0 Then
        Begin
            Case arbol^.hijos.elem[1]^.simbolo Of
                Tmultip:
                           Begin
                               evalOA3(arbol^.hijos.elem[2], estado, op2);
                               op1 := op1*op2;
                               evalSOA2(arbol^.hijos.elem[3], estado, op1,resultado);
                           End;
                Tdiv:
                        Begin
                            evalOA3(arbol^.hijos.elem[2], estado, op2);
                            If op2<>0 Then
                                Begin
                                    op1 := op1/op2;
                                End
                            Else
                                Begin
                                    CLRSCR;
                                    WriteLn('ERROR MATEMATICO');
                                End;
                            evalSOA2(arbol^.hijos.elem[3], estado, op1,resultado);
                        End;


            End;
        End
    Else
        resultado := op1;
End;


//<OA3> -> <Potencia> | "id"<arreglo> | "Creal" | "(" <opArit> ")" | “-”<OA3>
Procedure evalOA3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        VPotencia:   evalPot(arbol^.hijos.elem[1], estado, resultado);
        Tid:   evalArreglo(arbol^.hijos.elem[2], estado, resultado,arbol^.hijos.elem[1]^.lexema);
        TCreal:   resultado :=   transformacionReal(arbol^.hijos.elem[1]^.lexema);
        //No estamos del todo seguros
        TParen_ab:   evalOpArit(arbol^.hijos.elem[2], estado, resultado);
        Tmenos:
                  Begin
                      evalOA3(arbol^.hijos.elem[2], estado, resultado);
                      resultado := resultado * -1;
                  End;
    End;


End;
//<Potencia> -> "pot" "(" "<Num_p>" ")" | "root" "(" "<Num_p>" ")"
Procedure evalPot(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real);

Var base, exponente:   real;
    i:   byte;
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        Tpot:
                Begin
                    evalNum_p(arbol^.hijos.elem[3], estado, base, exponente);
                    resultado:=power(base,exponente);
                    {resultado := base;
                    For i:= 1 To floor(exponente) Do
                        resultado := resultado * base; }
                End;
        Troot:
                 Begin
                     evalNum_p(arbol^.hijos.elem[3], estado, base, exponente);
                     if (base=0) and (exponente<>0) then
                         resultado:=0
                     else
                         resultado := Exp((1/exponente)*Ln(base));
                 End;
    End;
End;

//<arreglo> -> "[" <opArit> "]" | epsilon
Procedure evalArreglo(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:real; lexemaId:String);

Var indice:   real;
Begin
    If  arbol^.hijos.cant > 0 Then
        Begin
            evalopArit(arbol^.hijos.elem[2], estado, indice);
            resultado := ValorDe(estado,lexemaid,floor(indice));
        End
    Else
        resultado := ValorDe(estado,lexemaid,0);

End;

//<Num_p> -> <opArit> "," <opArit>                           	// base, exponente
Procedure evalNum_p(Var arbol:TApuntNodo; Var estado:tEstado; Var base:real; Var exponente:real);
Begin
    evalOpArit(arbol^.hijos.elem[1], estado, base);
    evalOpArit(arbol^.hijos.elem[3], estado, exponente);
End;

//<Condi> -> "If" <valor_B> "{"<Cuerpo>"}" <Otro>
Procedure evalCondi(Var arbol:TApuntNodo; Var estado:tEstado);

Var resultado:   boolean;
Begin
    evalValor_B(arbol^.hijos.elem[2], estado, resultado);
    evalCuerpo(arbol^.hijos.elem[4], estado, resultado);
    evalOtro(arbol^.hijos.elem[6], estado, resultado);
End;
//<Otro> -> “else” "{"<Cuerpo>"}" | epsilon
Procedure evalOtro(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado: boolean);
Begin
    If arbol^.hijos.cant > 0 Then
        Begin
            If Not resultado Then
                evalCuerpo(arbol^.hijos.elem[3], estado, True);

        End;
End;
//<valor_B> -> <OL2> <SOL>
Procedure evalValor_B(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado: boolean);

Var aux:   boolean;
Begin
    evalOL2(arbol^.hijos.elem[1], estado, aux);
    evalSOL(arbol^.hijos.elem[2], estado, aux ,resultado);
End;

//<SOL> -> “|” <OL2><SOL> | epsilon
Procedure evalSOL(Var arbol:TApuntNodo; Var estado:tEstado;Var aux:boolean ;Var resultado:   boolean);

Var r2:   boolean;
Begin
    If arbol^.hijos.cant > 0 Then
        Begin
            evalOL2(arbol^.hijos.elem[2], estado, r2);
            aux := aux Or r2;
            evalSOL(arbol^.hijos.elem[3], estado, aux,resultado);
        End
    Else
        resultado := aux;
End;

//<OL2> -> <OL3><SOL2>
Procedure evalOL2(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:   boolean);

Var aux:   boolean;
Begin
    evalOL3(arbol^.hijos.elem[1], estado, aux);
    evalSOL2(arbol^.hijos.elem[2], estado, aux,resultado);
End;

//<SOL2>  -> "&" <OL3><SOL2> | epsilon
Procedure evalSOL2(Var arbol:TApuntNodo; Var estado:tEstado;Var aux:boolean; Var resultado:   boolean);

Var r2:   boolean;
Begin
    If arbol^.hijos.cant > 0 Then
        Begin
            evalOL3(arbol^.hijos.elem[2], estado, r2);
            aux := aux And r2;
            evalSOL2(arbol^.hijos.elem[3], estado, aux, resultado);
        End
    Else
        resultado := aux;
End;

//<OL3> -> “!” <OL3> | <opArit> “Relacional” <opArit>  | "{" <valor_B> "}"
Procedure evalOL3(Var arbol:TApuntNodo; Var estado:tEstado; Var resultado:   boolean);

Var
    val1,val2:   real;
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        Tnot:
                Begin
                    evalOL3(arbol^.hijos.elem[2],estado,resultado);
                    resultado := Not resultado;
                End;
        VopArit:
                   Begin
                       evalOpArit(arbol^.hijos.elem[1],estado,val1);
                       evalOpArit(arbol^.hijos.elem[3],estado,val2);
                       Case arbol^.hijos.elem[2]^.lexema Of
                           '<':   resultado := (val1 < val2);
                           '>':   resultado := (val1 > val2);
                           '==':   resultado := (val1 = val2);
                           '<>':   resultado := (val1 <> val2);
                           '<=':   resultado := (val1 <= val2);
                           '>=':   resultado := (val1 >= val2);
                       End;
                   End;
        TLlav_ab:   evalValor_B(arbol^.hijos.elem[2],estado,resultado);
    End;
End;

//<Leer> -> "read" "(" “cad” “,” “id” ")"
Procedure evalLeer(Var arbol:   TApuntNodo; Var estado:   tEstado);

Var valEscrito:   real;
Begin
    write(arbol^.hijos.elem[3]^.lexema);
    readln(valEscrito);
    AsignarValor(arbol^.hijos.elem[5]^.lexema, estado,0,valEscrito);
    //puede ser que halla un
End;

//<Imprimir> -> "print" "(" <Mostrar> ")"
Procedure evalImprimir(Var arbol:TApuntNodo; Var estado:tEstado);
Begin

    evalMostrar(arbol^.hijos.elem[3], estado);

End;

//<Mostrar> -> <OpArit><SM> | "cad"<SM>
Procedure evalMostrar(Var arbol:TApuntNodo; Var estado:tEstado);

Var resultado:   real;
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        VopArit:
                   Begin
                       evalopArit(arbol^.hijos.elem[1], estado, resultado);
                       writeln(resultado:15:3);
                       evalSM(arbol^.hijos.elem[2], estado);
                   End;
        Tcad:
                Begin
                    writeln(arbol^.hijos.elem[1]^.lexema);
                    evalSM(arbol^.hijos.elem[2], estado);
                End;
    End;
End;
//<SM> ->  ”,”<SM2>  | epsilon
Procedure evalSM(Var arbol:TApuntNodo; Var estado:tEstado);
Begin

    If arbol^.hijos.cant > 0 Then
        evalSM2(arbol^.hijos.elem[2], estado);

End;

//<SM2> -> "cad"<SM> | <OpArit><SM>
Procedure evalSM2(Var arbol:TApuntNodo; Var estado:tEstado);

Var resultado:   real;
Begin
    Case arbol^.hijos.elem[1]^.simbolo Of
        Tcad:
                Begin

                    writeln(arbol^.hijos.elem[1]^.lexema);
                    evalSM(arbol^.hijos.elem[2], estado);

                End;
        VOpArit:
                   Begin

                       evalopArit(arbol^.hijos.elem[1],estado,resultado);
                       writeln(resultado:15:3);
                       evalSM(arbol^.hijos.elem[2], estado);

                   End;
    End;
End;

//<Ciclo> -> "while" <valor_B> "{" "<Cuerpo>" "}"
Procedure evalCiclo(Var arbol:TApuntNodo; Var estado:tEstado);

Var resultado:   boolean;
Begin
    evalValor_B(arbol^.hijos.elem[2],estado,resultado);
    While resultado Do
        Begin
            evalCuerpo(arbol^.hijos.elem[4],estado,true);
            evalValor_B(arbol^.hijos.elem[2],estado,resultado);
        End;
End;

End.

