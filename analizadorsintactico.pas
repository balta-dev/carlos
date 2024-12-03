
Unit analizadorSintactico;
//TAS: Matriz con esp en blanco nill y elementos son listas de estuct de datos

Interface
//Definir estructuras de Datos

Uses
crt, analizador_Lexico;

Const
    MaxProd =   6;

Type                                              //Lista de hijos: lista de apuntadores
    TProduccion =   Record
        elem:   array[1..MaxProd] Of TipoSG;
        cant:   0..MaxProd;
    End;
    TipoVariable =   VLenguaje..VCiclo;
    TipoTerminypesos =   Tprogram..pesos;
    TipoTAS =   array [TipoVariable, TipoTerminypesos] Of ^Tproduccion;
    TApuntNodo =   ^TNodoArbol;
    TipoHIjos =   Record
        elem:   array[1..MaxProd] Of TApuntNodo;
        cant:   0..MaxProd;
    End;
    TNodoArbol =   Record
        Simbolo:   TipoSG;
        lexema:   string;
        Hijos:   TipoHIjos;
    End;
    //--------------------------TODO LO DE PILAS-----------------------------------------------------


    TipoElemPila =   Record
        Simbolo:   TipoSG;
        NodoArbol:   TApuntNodo;
    End;
    T_PUNT_PILA =   ^T_NODO_PILA;

    TipoPila =   Record
        TOPE:   T_PUNT_PILA;
        TAM:   WORD;
    End;

    T_NODO_PILA =   Record
        INFO:   TipoElemPila;
        SIG:   T_PUNT_PILA;
    End;

    //--------------------------------------------------------------------------

Procedure CREARPILA(Var P:TipoPila);
Procedure APILAR (Var P:TipoPila; X:TipoElemPila);
Procedure DESAPILAR (Var P:TipoPila; Var X:TipoElemPila);
procedure GuardarArbol(Ruta:string; var arbol:TApuntNodo);
Procedure Analizador_Predictivo(rutaFuente:String;Var arbol:TApuntNodo; Var Error:Boolean);
{Function PILA_LLENA (Var P:TipoPila):   BOOLEAN;
Function PILA_VACIA (Var P:TipoPila):   BOOLEAN;
}

Implementation

Procedure CREARPILA(Var P:TipoPila);
Begin
    P.TAM := 0;
    P.TOPE := Nil;
End;
Procedure APILAR (Var P:TipoPila; X:TipoElemPila);

Var DIR:   T_PUNT_PILA;
Begin
    NEW (DIR);
    DIR^.INFO := X;
    DIR^.SIG := P.TOPE;
    P. TOPE := DIR;
    INC(P.TAM)
End;

Procedure DESAPILAR (Var P:TipoPila;Var X:TipoElemPila);

Var dir:   t_punt_PILA;
Begin
    X := P.TOPE^.INFO;
    dir := P.TOPE;
    P.TOPE := P.TOPE^.sig;
    DISPOSE (dir);
    DEC(P.TAM)
End;

Procedure ApilarTodos(Var Celda:Tproduccion; Var padre:TApuntNodo; Var pila:TipoPila);

Var
    i:   0..MaxProd;
    Epila:   TipoElemPila;
    // CompLex:   TipoSG;
Begin
    For  i:= celda.cant Downto 1 Do
        Begin
            Epila.simbolo := celda.elem[i];
            Epila.NodoArbol := padre^.Hijos.elem[i];
            Apilar(pila,Epila);
        End;
End;

Procedure inicializarTas(Var TAS:TipoTAS);

Var i,j:   TipoSG;
Begin
    For i:=VLenguaje To Vciclo Do
        For j:=Tprogram To pesos Do
            TAS[i, j] := Nil;
End;

Procedure cargarTas(Var TAS:TipoTAS);

Begin


    new (TAS[VLenguaje, Tprogram]);
    TAS[VLenguaje, Tprogram]^.elem[1] := Tprogram;
    TAS[VLenguaje, Tprogram]^.elem[2] := VL_2;
    TAS[VLenguaje, Tprogram]^.cant := 2;

    new (TAS[VL_2, Tdef]);
    TAS[VL_2, Tdef]^.elem[1] := VTitulo;
    TAS[VL_2, Tdef]^.elem[2] := VL_3;
    TAS[VL_2, Tdef]^.cant := 2;

    new (TAS[VL_2, Ttitle]);
    TAS[VL_2, Ttitle]^.elem[1] := VTitulo;
    TAS[VL_2, Ttitle]^.elem[2] := VL_3;
    TAS[VL_2, Ttitle]^.cant := 2;

    new (TAS[VL_2, TLlav_ab]);
    TAS[VL_2, TLlav_ab]^.elem[1] := VTitulo;
    TAS[VL_2, TLlav_ab]^.elem[2] := VL_3;
    TAS[VL_2, TLlav_ab]^.cant := 2;

    new (TAS[VL_3, Tdef]);
    TAS[VL_3, Tdef]^.elem[1] := Tdef;
    TAS[VL_3, Tdef]^.elem[2] := VDefiniciones;
    TAS[VL_3, Tdef]^.elem[3] := Tpycom;
    TAS[VL_3, Tdef]^.elem[4] := TLlav_ab;
    TAS[VL_3, Tdef]^.elem[5] := VCuerpo;
    TAS[VL_3, Tdef]^.elem[6] := TLlav_cer;
    TAS[VL_3, Tdef]^.cant := 6;

    new (TAS[VL_3, TLlav_ab]);
    TAS[VL_3, TLlav_ab]^.elem[1] := TLlav_ab;
    TAS[VL_3, TLlav_ab]^.elem[2] := VCuerpo;
    TAS[VL_3, TLlav_ab]^.elem[3] := TLlav_cer;
    TAS[VL_3, TLlav_ab]^.cant := 3;

    new (TAS[VTitulo, Tdef]);
    TAS[VTitulo, Tdef]^.cant := 0;

    new (TAS[VTitulo, Ttitle]);
    TAS[VTitulo, Ttitle]^.elem[1] := Ttitle;
    TAS[VTitulo, Ttitle]^.elem[2] := Tcad;
    TAS[VTitulo, Ttitle]^.elem[3] := Tpycom;
    TAS[VTitulo, Ttitle]^.cant := 3;

    new (TAS[VTitulo, TLlav_ab]);
    TAS[VTitulo, TLlav_ab]^.cant := 0;

    new (TAS[VTitulo, pesos]);
    TAS[VTitulo, pesos]^.cant := 0;

    new (TAS[VDefiniciones,Tid]);
    TAS[VDefiniciones,Tid]^.elem[1] := Tid;
    TAS[VDefiniciones,Tid]^.elem[2] := VD_2;
    TAS[VDefiniciones,Tid]^.cant := 2;

    new(TAS[VD_2,Tpycom]);
    TAS[VD_2,Tpycom]^.cant := 0;

    new(TAS[VD_2,Tcoma]);
    TAS[VD_2,Tcoma]^.elem[1] := Tcoma;
    TAS[VD_2,Tcoma]^.elem[2] := VDefiniciones;
    TAS[VD_2,Tcoma]^.cant := 2;

    new(TAS[VD_2,Tarray]);
    TAS[VD_2,Tarray]^.elem[1] := Tarray;
    TAS[VD_2,Tarray]^.elem[2] := TCorr_ab;
    TAS[VD_2,Tarray]^.elem[3] := VopArit;
    TAS[VD_2,Tarray]^.elem[4] := TCorr_cer;
    TAS[VD_2,Tarray]^.elem[5] := VD_3;
    TAS[VD_2,Tarray]^.cant := 5;

    new(TAS[VD_2,pesos]);
    TAS[VD_2,pesos]^.cant := 0;

    new(TAS[VD_3,Tpycom]);
    TAS[VD_3,Tpycom]^.cant := 0;

    new(TAS[VD_3,Tcoma]);
    TAS[VD_3,Tcoma]^.elem[1] := Tcoma;
    TAS[VD_3,Tcoma]^.elem[2] := VDefiniciones;
    TAS[VD_3,Tcoma]^.cant := 2;

    New(TAS[VCuerpo,Tid]);
    TAS[VCuerpo,Tid]^.elem[1] := VSent;
    TAS[VCuerpo,Tid]^.elem[2] := VC2;
    TAS[VCuerpo,Tid]^.cant := 2;

    New(TAS[VCuerpo,Tif]);
    TAS[VCuerpo,Tif]^.elem[1] := VSent;
    TAS[VCuerpo,Tif]^.elem[2] := VC2;
    TAS[VCuerpo,Tif]^.cant := 2;

    New(TAS[VCuerpo,Tread]);
    TAS[VCuerpo,Tread]^.elem[1] := VSent;
    TAS[VCuerpo,Tread]^.elem[2] := VC2;
    TAS[VCuerpo,Tread]^.cant := 2;

    New(TAS[VCuerpo,Tprint]);
    TAS[VCuerpo,Tprint]^.elem[1] := VSent;
    TAS[VCuerpo,Tprint]^.elem[2] := VC2;
    TAS[VCuerpo,Tprint]^.cant := 2;

    New(TAS[VCuerpo,Twhile]);
    TAS[VCuerpo,Twhile]^.elem[1] := VSent;
    TAS[VCuerpo,Twhile]^.elem[2] := VC2;
    TAS[VCuerpo,Twhile]^.cant := 2;

    New(TAS[VC2,Tpycom]);
    TAS[VC2,Tpycom]^.elem[1] := Tpycom;
    TAS[VC2,Tpycom]^.elem[2] := VCuerpo;
    TAS[VC2,Tpycom]^.cant := 2;

    New(TAS[VC2,TLlav_cer]);
    TAS[VC2,TLlav_cer]^.cant := 0;

    New(TAS[VC2,pesos]);
    TAS[VC2,pesos]^.cant := 0;

    New(TAS[VSent, Tid]);
    TAS[VSent, Tid]^.elem[1] := Vasig;
    TAS[VSent, Tid]^.cant := 1;

    New(TAS[VSent, Tif]);
    TAS[VSent, Tif]^.elem[1] := VCondi;
    TAS[VSent, Tif]^.cant := 1;

    New(TAS[VSent, Tread]);
    TAS[VSent, Tread]^.elem[1] := VLeer;
    TAS[VSent, Tread]^.cant := 1;

    New(TAS[VSent, Tprint]);
    TAS[VSent, Tprint]^.elem[1] := VImprimir;
    TAS[VSent, Tprint]^.cant := 1;

    New(TAS[VSent, Twhile]);
    TAS[VSent, Twhile]^.elem[1] := VCiclo;
    TAS[VSent, Twhile]^.cant := 1;

    New(TAS[Vasig,Tid]);
    TAS[Vasig,Tid]^.elem[1] := Tid;
    TAS[Vasig,Tid]^.elem[2] := VAsig_2;
    TAS[Vasig,Tid]^.cant := 2;

    New(TAS[Vasig_2,TCorr_ab]);
    TAS[Vasig_2,TCorr_ab]^.elem[1] := TCorr_ab;
    TAS[Vasig_2,TCorr_ab]^.elem[2] := VopArit;
    TAS[Vasig_2,TCorr_ab]^.elem[3] := TCorr_cer;
    TAS[Vasig_2,TCorr_ab]^.elem[4] := Tasig;
    TAS[Vasig_2,TCorr_ab]^.elem[5] := Vasig_3;
    TAS[Vasig_2,TCorr_ab]^.cant := 5;

    New(TAS[Vasig_2,Tasig]);
    TAS[Vasig_2,Tasig]^.elem[1] := Tasig;
    TAS[Vasig_2,Tasig]^.elem[2] := VAsig_3;
    TAS[Vasig_2,Tasig]^.cant := 2;

    New(TAS[Vasig_3,Tid]);
    TAS[Vasig_3,Tid]^.elem[1] := VopArit;
    TAS[Vasig_3,Tid]^.cant := 1;

    New(TAS[Vasig_3,TCorr_ab]);
    TAS[Vasig_3,TCorr_ab]^.elem[1] := TCorr_ab;
    TAS[Vasig_3,TCorr_ab]^.elem[2] := VElem_V;
    TAS[Vasig_3,TCorr_ab]^.elem[3] := TCorr_cer;
    TAS[Vasig_3,TCorr_ab]^.cant := 3;

    New(TAS[Vasig_3,Tmenos]);
    TAS[Vasig_3,Tmenos]^.elem[1] := VopArit;
    TAS[Vasig_3,Tmenos]^.cant := 1;

    New(TAS[Vasig_3,TCreal]);
    TAS[Vasig_3,TCreal]^.elem[1] := VopArit;
    TAS[Vasig_3,TCreal]^.cant := 1;

    New(TAS[Vasig_3,Tpot]);
    TAS[Vasig_3,Tpot]^.elem[1] := VopArit;
    TAS[Vasig_3,Tpot]^.cant := 1;

    New(TAS[Vasig_3,Troot]);
    TAS[Vasig_3,Troot]^.elem[1] := VopArit;
    TAS[Vasig_3,Troot]^.cant := 1;

    New(TAS[Vasig_3,TParen_ab]);
    TAS[Vasig_3,TParen_ab]^.elem[1] := VopArit;
    TAS[Vasig_3,TParen_ab]^.cant := 1;

    New(TAS[VElem_V,Tid]);
    TAS[VElem_V,Tid]^.elem[1] := VopArit;
    TAS[VElem_V,Tid]^.elem[2] := VElem_V2;
    TAS[VElem_V,Tid]^.cant := 2;

    New(TAS[VElem_V,Tmenos]);
    TAS[VElem_V,Tmenos]^.elem[1] := VopArit;
    TAS[VElem_V,Tmenos]^.elem[2] := VElem_V2;
    TAS[VElem_V,Tmenos]^.cant := 2;

    New(TAS[VElem_V,TCreal]);
    TAS[VElem_V,TCreal]^.elem[1] := VopArit;
    TAS[VElem_V,TCreal]^.elem[2] := VElem_V2;
    TAS[VElem_V,TCreal]^.cant := 2;

    New(TAS[VElem_V,Tpot]);
    TAS[VElem_V,Tpot]^.elem[1] := VopArit;
    TAS[VElem_V,Tpot]^.elem[2] := VElem_V2;
    TAS[VElem_V,Tpot]^.cant := 2;

    New(TAS[VElem_V,Troot]);
    TAS[VElem_V,Troot]^.elem[1] := VopArit;
    TAS[VElem_V,Troot]^.elem[2] := VElem_V2;
    TAS[VElem_V,Troot]^.cant := 2;

    New(TAS[VElem_V,TParen_ab]);
    TAS[VElem_V,TParen_ab]^.elem[1] := VopArit;
    TAS[VElem_V,TParen_ab]^.elem[2] := VElem_V2;
    TAS[VElem_V,TParen_ab]^.cant := 2;

    New(TAS[VElem_V2,Tpycom]);
    TAS[VElem_V2,Tpycom]^.cant := 0 ;

    New(TAS[VElem_V2,Tcoma]);
    TAS[VElem_V2,Tcoma]^.elem[1] := Tcoma;
    TAS[VElem_V2,Tcoma]^.elem[2] := VElem_V;
    TAS[VElem_V2,Tcoma]^.cant := 2;

    New(TAS[VElem_V2,TLlav_cer]);
    TAS[VElem_V2,TLlav_cer]^.cant := 0 ;

    New(TAS[VElem_V2,TCorr_cer]);
    TAS[VElem_V2,TCorr_cer]^.cant := 0 ;

    New(TAS[VElem_V2,pesos]);
    TAS[VElem_V2,pesos]^.cant := 0 ;

    New(TAS[VopArit, Tid]);
    TAS[VopArit, Tid]^.elem[1] := VOA2;
    TAS[VopArit, Tid]^.elem[2] := VSOA;
    TAS[VopArit, Tid]^.cant := 2;

    New(TAS[VopArit, Tmenos]);
    TAS[VopArit, Tmenos]^.elem[1] := VOA2;
    TAS[VopArit, Tmenos]^.elem[2] := VSOA;
    TAS[VopArit, Tmenos]^.cant := 2;

    New(TAS[VopArit, TCreal]);
    TAS[VopArit, TCreal]^.elem[1] := VOA2;
    TAS[VopArit, TCreal]^.elem[2] := VSOA;
    TAS[VopArit, TCreal]^.cant := 2;

    New(TAS[VopArit, Tpot]);
    TAS[VopArit, Tpot]^.elem[1] := VOA2;
    TAS[VopArit, Tpot]^.elem[2] := VSOA;
    TAS[VopArit, Tpot]^.cant := 2;

    New(TAS[VopArit, Troot]);
    TAS[VopArit, Troot]^.elem[1] := VOA2;
    TAS[VopArit, Troot]^.elem[2] := VSOA;
    TAS[VopArit, Troot]^.cant := 2;

    New(TAS[VopArit, TParen_ab]);
    TAS[VopArit, TParen_ab]^.elem[1] := VOA2;
    TAS[VopArit, TParen_ab]^.elem[2] := VSOA;
    TAS[VopArit, TParen_ab]^.cant := 2;

    New(TAS[VSOA, TLlav_cer]);
    TAS[VSOA, TLlav_cer]^.cant := 0;

    New(TAS[VSOA, Tcoma]);
    TAS[VSOA, Tcoma]^.cant := 0;

    New(TAS[VSOA, TCorr_cer]);
    TAS[VSOA, TCorr_cer]^.cant := 0;

    New(TAS[VSOA, Tmas]);
    TAS[VSOA, Tmas]^.elem[1] := Tmas;
    TAS[VSOA, Tmas]^.elem[2] := VOA2;
    TAS[VSOA, Tmas]^.elem[3] := VSOA;
    TAS[VSOA, Tmas]^.cant := 3;

    New(TAS[VSOA, Tmenos]);
    TAS[VSOA, Tmenos]^.elem[1] := Tmenos;
    TAS[VSOA, Tmenos]^.elem[2] := VOA2;
    TAS[VSOA, Tmenos]^.elem[3] := VSOA;
    TAS[VSOA, Tmenos]^.cant := 3;

    New(TAS[VSOA, TParen_cer]);
    TAS[VSOA, TParen_cer]^.cant := 0;

    New(TAS[VSOA, TAnd]);
    TAS[VSOA, TAnd]^.cant := 0;

    New(TAS[VSOA, TRelacional]);
    TAS[VSOA, TRelacional]^.cant := 0;

    New(TAS[VSOA, Tpycom]);                        //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA, Tpycom]^.cant := 0;

    New(TAS[VSOA, Tllav_ab]);                      //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA, Tllav_ab]^.cant := 0;

    New(TAS[VSOA, Tor]);                           //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA, Tor]^.cant := 0;

    New(TAS[VSOA, pesos]);
    TAS[VSOA, pesos]^.cant := 0;

    New(TAS[VOA2, Tid]);
    TAS[VOA2, Tid]^.elem[1] := VOA3;
    TAS[VOA2, Tid]^.elem[2] := VSOA2;
    TAS[VOA2, Tid]^.cant := 2;

    New(TAS[VOA2, Tmenos]);
    TAS[VOA2, Tmenos]^.elem[1] := VOA3;
    TAS[VOA2, Tmenos]^.elem[2] := VSOA2;
    TAS[VOA2, Tmenos]^.cant := 2;

    New(TAS[VOA2, TCreal]);
    TAS[VOA2, TCreal]^.elem[1] := VOA3;
    TAS[VOA2, TCreal]^.elem[2] := VSOA2;
    TAS[VOA2, TCreal]^.cant := 2;

    New(TAS[VOA2, Tpot]);
    TAS[VOA2, Tpot]^.elem[1] := VOA3;
    TAS[VOA2, Tpot]^.elem[2] := VSOA2;
    TAS[VOA2, Tpot]^.cant := 2;

    New(TAS[VOA2, Troot]);
    TAS[VOA2, Troot]^.elem[1] := VOA3;
    TAS[VOA2, Troot]^.elem[2] := VSOA2;
    TAS[VOA2, Troot]^.cant := 2;

    New(TAS[VOA2, TParen_ab]);
    TAS[VOA2, TParen_ab]^.elem[1] := VOA3;
    TAS[VOA2, TParen_ab]^.elem[2] := VSOA2;
    TAS[VOA2, TParen_ab]^.cant := 2;

    New(TAS[VSOA2, TLlav_cer]);
    TAS[VSOA2, TLlav_cer]^.cant := 0;

    New(TAS[VSOA2, Tcoma]);
    TAS[VSOA2, Tcoma]^.cant := 0;

    New(TAS[VSOA2, TCorr_cer]);
    TAS[VSOA2, TCorr_cer]^.cant := 0;

    New(TAS[VSOA2, Tmas]);
    TAS[VSOA2, Tmas]^.cant := 0;

    New(TAS[VSOA2, Tmenos]);
    TAS[VSOA2, Tmenos]^.cant := 0;

    New(TAS[VSOA2, TMultip]);
    TAS[VSOA2, TMultip]^.elem[1] := TMultip;
    TAS[VSOA2, TMultip]^.elem[2] := VOA3;
    TAS[VSOA2, TMultip]^.elem[3] := VSOA2;
    TAS[VSOA2, TMultip]^.cant := 3;

    New(TAS[VSOA2, Tdiv]);
    TAS[VSOA2, Tdiv]^.elem[1] := Tdiv;
    TAS[VSOA2, Tdiv]^.elem[2] := VOA3;
    TAS[VSOA2, Tdiv]^.elem[3] := VSOA2;
    TAS[VSOA2, Tdiv]^.cant := 3;

    New(TAS[VSOA2, TParen_cer]);
    TAS[VSOA2, TParen_cer]^.cant := 0;

    New(TAS[VSOA2, TParen_cer]);
    TAS[VSOA2, TParen_cer]^.cant := 0;

    New(TAS[VSOA2, TAnd]);
    TAS[VSOA2, TAnd]^.cant := 0;

    New(TAS[VSOA2, TRelacional]);
    TAS[VSOA2, TRelacional]^.cant := 0;

    New(TAS[VSOA2, Tpycom]);                        //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA2, Tpycom]^.cant := 0;

    New(TAS[VSOA2, Tllav_ab]);                      //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA2, Tllav_ab]^.cant := 0;

    New(TAS[VSOA2, Tor]);                           //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VSOA2, Tor]^.cant := 0;

    New(TAS[VSOA2, pesos]);
    TAS[VSOA2, pesos]^.cant := 0;

    New(TAS[VOA3, Tid]);
    TAS[VOA3, Tid]^.elem[1] := Tid;
    TAS[VOA3, Tid]^.elem[2] := VArreglo;
    TAS[VOA3, Tid]^.cant := 2;

    New(TAS[VOA3, Tmenos]);
    TAS[VOA3, Tmenos]^.elem[1] := Tmenos;
    TAS[VOA3, Tmenos]^.elem[2] := VOA3;
    TAS[VOA3, Tmenos]^.cant := 2;

    New(TAS[VOA3, TCreal]);
    TAS[VOA3, TCreal]^.elem[1] := TCreal;
    TAS[VOA3, TCreal]^.cant := 1;

    New(TAS[VOA3, Tpot]);
    TAS[VOA3, Tpot]^.elem[1] := VPotencia;
    TAS[VOA3, Tpot]^.cant := 1;

    New(TAS[VOA3, Troot]);
    TAS[VOA3, Troot]^.elem[1] := VPotencia;
    TAS[VOA3, Troot]^.cant := 1;

    New(TAS[VOA3, TParen_ab]);
    TAS[VOA3, TParen_ab]^.elem[1] := TParen_ab;
    TAS[VOA3, TParen_ab]^.elem[2] := VopArit;
    TAS[VOA3, TParen_ab]^.elem[3] := TParen_cer;
    TAS[VOA3, TParen_ab]^.cant := 3;

    New(TAS[VArreglo, Tcoma]);
    TAS[VArreglo, Tcoma]^.cant := 0;

    New(TAS[VArreglo, TLlav_cer]);
    TAS[VArreglo, TLlav_cer]^.cant := 0;

    New(TAS[VArreglo, TCorr_ab]);
    TAS[VArreglo, TCorr_ab]^.elem[1] := TCorr_ab;
    TAS[VArreglo, TCorr_ab]^.elem[2] := VopArit;
    TAS[VArreglo, TCorr_ab]^.elem[3] := TCorr_cer;
    TAS[VArreglo, TCorr_ab]^.cant := 3;

    New(TAS[VArreglo, TCorr_cer]);
    TAS[VArreglo, TCorr_cer]^.cant := 0;

    New(TAS[VArreglo, Tmas]);
    TAS[VArreglo, Tmas]^.cant := 0;

    New(TAS[VArreglo, Tmenos]);
    TAS[VArreglo, Tmenos]^.cant := 0;

    New(TAS[VArreglo, TMultip]);
    TAS[VArreglo, TMultip]^.cant := 0;

    New(TAS[VArreglo, Tdiv]);
    TAS[VArreglo, Tdiv]^.cant := 0;

    New(TAS[VArreglo, TParen_cer]);
    TAS[VArreglo, TParen_cer]^.cant := 0;

    New(TAS[VArreglo, TAnd]);
    TAS[VArreglo, TAnd]^.cant := 0;

    New(TAS[VArreglo, TRelacional]);
    TAS[VArreglo, TRelacional]^.cant := 0;

    New(TAS[VArreglo, Tpycom]);                        //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VArreglo, Tpycom]^.cant := 0;

    New(TAS[VArreglo, Tllav_ab]);                      //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    TAS[VArreglo, Tllav_ab]^.cant := 0;

    New(TAS[VArreglo, Tor]);
    TAS[VArreglo, Tor]^.cant := 0;

    New(TAS[VArreglo, pesos]);
    TAS[VArreglo, pesos]^.cant := 0;

    New(TAS[VPotencia, Tpot]);
    TAS[VPotencia, Tpot]^.elem[1] := Tpot;
    TAS[VPotencia, Tpot]^.elem[2] := TParen_ab;
    TAS[VPotencia, Tpot]^.elem[3] := VNum_p;
    TAS[VPotencia, Tpot]^.elem[4] := TParen_cer;
    TAS[VPotencia, Tpot]^.cant := 4;

    New(TAS[VPotencia, Troot]);
    TAS[VPotencia, Troot]^.elem[1] := Troot;
    TAS[VPotencia, Troot]^.elem[2] := TParen_ab;
    TAS[VPotencia, Troot]^.elem[3] := VNum_p;
    TAS[VPotencia, Troot]^.elem[4] := TParen_cer;
    TAS[VPotencia, Troot]^.cant := 4;

    New(TAS[VNum_p, Tid]);
    TAS[VNum_p, Tid]^.elem[1] := VopArit;
    TAS[VNum_p, Tid]^.elem[2] := Tcoma;
    TAS[VNum_p, Tid]^.elem[3] := VopArit;
    TAS[VNum_p, Tid]^.cant := 3;

    New(TAS[VNum_p, Tcoma]);
    TAS[VNum_p, Tcoma]^.elem[1] := VopArit;
    TAS[VNum_p, Tcoma]^.elem[2] := Tcoma;
    TAS[VNum_p, Tcoma]^.elem[3] := VopArit;
    TAS[VNum_p, Tcoma]^.cant := 3;

    New(TAS[VNum_p, Tmenos]);
    TAS[VNum_p, Tmenos]^.elem[1] := VopArit;
    TAS[VNum_p, Tmenos]^.elem[2] := Tcoma;
    TAS[VNum_p, Tmenos]^.elem[3] := VopArit;
    TAS[VNum_p, Tmenos]^.cant := 3;

    New(TAS[VNum_p, TCreal]);
    TAS[VNum_p, TCreal]^.elem[1] := VopArit;
    TAS[VNum_p, TCreal]^.elem[2] := Tcoma;
    TAS[VNum_p, TCreal]^.elem[3] := VopArit;
    TAS[VNum_p, TCreal]^.cant := 3;

    New(TAS[VNum_p, Tpot]);
    TAS[VNum_p, Tpot]^.elem[1] := VopArit;
    TAS[VNum_p, Tpot]^.elem[2] := Tcoma;
    TAS[VNum_p, Tpot]^.elem[3] := VopArit;
    TAS[VNum_p, Tpot]^.cant := 3;

    New(TAS[VNum_p, Troot]);
    TAS[VNum_p, Troot]^.elem[1] := VopArit;
    TAS[VNum_p, Troot]^.elem[2] := Tcoma;
    TAS[VNum_p, Troot]^.elem[3] := VopArit;
    TAS[VNum_p, Troot]^.cant := 3;

    New(TAS[VCondi, Tif]);
    TAS[VCondi, Tif]^.elem[1] := Tif;
    TAS[VCondi, Tif]^.elem[2] := VValor_B;
    TAS[VCondi, Tif]^.elem[3] := TLlav_ab;
    TAS[VCondi, Tif]^.elem[4] := VCuerpo;
    TAS[VCondi, Tif]^.elem[5] := TLlav_cer;
    TAS[VCondi, Tif]^.elem[6] := VOtro;
    TAS[VCondi, Tif]^.cant := 6;

    New(TAS[VOtro, Tcoma]);
    TAS[VOtro, Tcoma]^.cant := 0;

    New(TAS[VOtro, TLlav_cer]);
    TAS[VOtro, TLlav_cer]^.cant := 0;

    New(TAS[VOtro, Tpycom]);
    TAS[VOtro, Tpycom]^.cant := 0;

    New(TAS[VOtro, TElse]);
    TAS[VOtro, TElse]^.elem[1] := TElse;
    TAS[VOtro, TElse]^.elem[2] := TLlav_ab;
    TAS[VOtro, TElse]^.elem[3] := VCuerpo;
    TAS[VOtro, TElse]^.elem[4] := TLlav_cer;
    TAS[VOtro, TElse]^.cant := 4;

    New(TAS[VOtro, pesos]);
    TAS[VOtro, pesos]^.cant := 0;

    new(TAS[VValor_B, Tid]);
    TAS[VValor_B, Tid]^.elem[1] := VOL2;
    TAS[VValor_B, Tid]^.elem[2] := VSOL;
    TAS[VValor_B, Tid]^.cant := 2;

    new(TAS[VValor_B, TLlav_ab]);
    TAS[VValor_B, TLlav_ab]^.elem[1] := VOL2;
    TAS[VValor_B, TLlav_ab]^.elem[2] := VSOL;
    TAS[VValor_B, TLlav_ab]^.cant := 2;

    new(TAS[VValor_B, Tmenos]);
    TAS[VValor_B, Tmenos]^.elem[1] := VOL2;
    TAS[VValor_B, Tmenos]^.elem[2] := VSOL;
    TAS[VValor_B, Tmenos]^.cant := 2;

    new(TAS[VValor_B, Tcreal]);
    TAS[VValor_B, Tcreal]^.elem[1] := VOL2;
    TAS[VValor_B, Tcreal]^.elem[2] := VSOL;
    TAS[VValor_B, Tcreal]^.cant := 2;

    new(TAS[VValor_B, Tpot]);
    TAS[VValor_B, Tpot]^.elem[1] := VOL2;
    TAS[VValor_B, Tpot]^.elem[2] := VSOL;
    TAS[VValor_B, Tpot]^.cant := 2;

    new(TAS[VValor_B, Troot]);
    TAS[VValor_B, Troot]^.elem[1] := VOL2;
    TAS[VValor_B, Troot]^.elem[2] := VSOL;
    TAS[VValor_B, Troot]^.cant := 2;

    new(TAS[VValor_B, TParen_ab]);
    TAS[VValor_B, TParen_ab]^.elem[1] := VOL2;
    TAS[VValor_B, TParen_ab]^.elem[2] := VSOL;
    TAS[VValor_B, TParen_ab]^.cant := 2;

    new(TAS[VValor_B, Tnot]);
    TAS[VValor_B, Tnot]^.elem[1] := VOL2;
    TAS[VValor_B, Tnot]^.elem[2] := VSOL;
    TAS[VValor_B, Tnot]^.cant := 2;

    new(TAS[VSOL, TLlav_ab]);
    TAS[VSOL, TLlav_ab]^.cant := 0;

    new(TAS[VSOL, TLlav_cer]);
    TAS[VSOL, TLlav_cer]^.cant := 0;

    new(TAS[VSOL, Tor]);
    TAS[VSOL, Tor]^.elem[1] := Tor;
    TAS[VSOL, Tor]^.elem[2] := VOL2;
    TAS[VSOL, Tor]^.elem[3] := VSOL;
    TAS[VSOL, Tor]^.cant := 3;

    new(TAS[VOL2, Tid]);
    TAS[VOL2, Tid]^.elem[1] := VOL3;
    TAS[VOL2, Tid]^.elem[2] := VSOL2;
    TAS[VOL2, Tid]^.cant := 2;

    new(TAS[VOL2, TLlav_ab]);
    TAS[VOL2, TLlav_ab]^.elem[1] := VOL3;
    TAS[VOL2, TLlav_ab]^.elem[2] := VSOL2;
    TAS[VOL2, TLlav_ab]^.cant := 2;

    new(TAS[VOL2, Tmenos]);
    TAS[VOL2, Tmenos]^.elem[1] := VOL3;
    TAS[VOL2, Tmenos]^.elem[2] := VSOL2;
    TAS[VOL2, Tmenos]^.cant := 2;

    new(TAS[VOL2, Tcreal]);
    TAS[VOL2, Tcreal]^.elem[1] := VOL3;
    TAS[VOL2, Tcreal]^.elem[2] := VSOL2;
    TAS[VOL2, Tcreal]^.cant := 2;

    new(TAS[VOL2, Tpot]);
    TAS[VOL2, Tpot]^.elem[1] := VOL3;
    TAS[VOL2, Tpot]^.elem[2] := VSOL2;
    TAS[VOL2, Tpot]^.cant := 2;

    new(TAS[VOL2, Troot]);
    TAS[VOL2, Tcreal]^.elem[1] := VOL3;
    TAS[VOL2, Tcreal]^.elem[2] := VSOL2;
    TAS[VOL2, Tcreal]^.cant := 2;

    new(TAS[VOL2, TLlav_ab]);
    TAS[VOL2, TLlav_ab]^.elem[1] := VOL3;
    TAS[VOL2, TLlav_ab]^.elem[2] := VSOL2;
    TAS[VOL2, TLlav_ab]^.cant := 2;

    new(TAS[VOL2, Tmenos]);
    TAS[VOL2, Tmenos]^.elem[1] := VOL3;
    TAS[VOL2, Tmenos]^.elem[2] := VSOL2;
    TAS[VOL2, Tmenos]^.cant := 2;

    new(TAS[VOL2, Tcreal]);
    TAS[VOL2, Tcreal]^.elem[1] := VOL3;
    TAS[VOL2, Tcreal]^.elem[2] := VSOL2;
    TAS[VOL2, Tcreal]^.cant := 2;

    new(TAS[VOL2, Tpot]);
    TAS[VOL2, Tpot]^.elem[1] := VOL3;
    TAS[VOL2, Tpot]^.elem[2] := VSOL2;
    TAS[VOL2, Tpot]^.cant := 2;

    new(TAS[VOL2, Troot]);
    TAS[VOL2, Troot]^.elem[1] := VOL3;
    TAS[VOL2, Troot]^.elem[2] := VSOL2;
    TAS[VOL2, Troot]^.cant := 2;

    new(TAS[VOL2, TParen_ab]);
    TAS[VOL2, TParen_ab]^.elem[1] := VOL3;
    TAS[VOL2, TParen_ab]^.elem[2] := VSOL2;
    TAS[VOL2, TParen_ab]^.cant := 2;

    new(TAS[VOL2, Tnot]);
    TAS[VOL2, Tnot]^.elem[1] := VOL3;
    TAS[VOL2, Tnot]^.elem[2] := VSOL2;
    TAS[VOL2, Tnot]^.cant := 2;

    new(TAS[VSOL2, TLlav_ab]);
    TAS[VSOL2, TLlav_ab]^.cant := 0;

    new(TAS[VSOL2, TLlav_cer]);
    TAS[VSOL2, TLlav_cer]^.cant := 0;

    new (TAS[VSOL2, Tor]);
    TAS[VSOL2, Tor]^.cant := 0;

    new (TAS[VSOL2, Tand]);
    TAS[VSOL2, Tand]^.elem[1] := Tand;
    TAS[VSOL2, Tand]^.elem[2] := VOL3;
    TAS[VSOL2, Tand]^.elem[3] := VSOL2;
    TAS[VSOL2, Tand]^.cant := 3;

    new(TAS[VOL3, Tid]);
    TAS[VOL3, Tid]^.elem[1] := VopArit;
    TAS[VOL3, Tid]^.elem[2] := TRelacional;
    TAS[VOL3, Tid]^.elem[3] := VopArit;
    TAS[VOL3, Tid]^.cant := 3;

    new(TAS[VOL3, TLlav_ab]);
    TAS[VOL3, TLlav_ab]^.elem[1] := TLlav_ab;
    TAS[VOL3, TLlav_ab]^.elem[2] := VValor_B;
    TAS[VOL3, TLlav_ab]^.elem[3] := TLlav_cer;
    TAS[VOL3, TLlav_ab]^.cant := 3;

    new(TAS[VOL3, Tmenos]);
    TAS[VOL3, Tmenos]^.elem[1] := VopArit;
    TAS[VOL3, Tmenos]^.elem[2] := TRelacional;
    TAS[VOL3, Tmenos]^.elem[3] := VopArit;
    TAS[VOL3, Tmenos]^.cant := 3;

    new(TAS[VOL3, Tcreal]);
    TAS[VOL3, Tcreal]^.elem[1] := VopArit;
    TAS[VOL3, Tcreal]^.elem[2] := TRelacional;
    TAS[VOL3, Tcreal]^.elem[3] :=  VopArit;
    TAS[VOL3, Tcreal]^.cant := 3;

    new(TAS[VOL3, Tpot]);
    TAS[VOL3, Tpot]^.elem[1] := VopArit;
    TAS[VOL3, Tpot]^.elem[2] := TRelacional;
    TAS[VOL3, Tpot]^.elem[3] :=  VopArit;
    TAS[VOL3, Tpot]^.cant := 3;

    new(TAS[VOL3, Troot]);
    TAS[VOL3, Troot]^.elem[1] := VopArit;
    TAS[VOL3, Troot]^.elem[2] := TRelacional;
    TAS[VOL3, Troot]^.elem[3] :=  VopArit;
    TAS[VOL3, Troot]^.cant := 3;

    new(TAS[VOL3, TLlav_ab]);
    TAS[VOL3, TLlav_ab]^.elem[1] := VopArit;
    TAS[VOL3, TLlav_ab]^.elem[2] := TRelacional;
    TAS[VOL3, TLlav_ab]^.elem[3] :=  VopArit;
    TAS[VOL3, TLlav_ab]^.cant := 3;

    new(TAS[VOL3, Tnot]);
    TAS[VOL3, Tnot]^.elem[1] := Tnot;
    TAS[VOL3, Tnot]^.elem[2] := VOL3;
    TAS[VOL3, Tnot]^.cant := 2;

    new(TAS[VLeer, Tread]);
    TAS[VLeer, Tread]^.elem[1] := Tread;
    TAS[VLeer, Tread]^.elem[2] := TParen_ab;
    TAS[VLeer, Tread]^.elem[3] := Tcad;
    TAS[VLeer, Tread]^.elem[4] := Tcoma;
    TAS[VLeer, Tread]^.elem[5] := Tid;
    TAS[VLeer, Tread]^.elem[6] := TParen_cer;
    TAS[VLeer, Tread]^.cant := 6;

    new(TAS[VImprimir, Tprint]);
    TAS[VImprimir, Tprint]^.elem[1] := Tprint;
    TAS[VImprimir, Tprint]^.elem[2] := TParen_ab;
    TAS[VImprimir, Tprint]^.elem[3] := VMostrar;
    TAS[VImprimir, Tprint]^.elem[4] := TParen_cer;
    TAS[VImprimir, Tprint]^.cant := 4;

    new(TAS[VMostrar, Tid]);
    TAS[VMostrar, Tid]^.elem[1] := VopArit;
    TAS[VMostrar, Tid]^.elem[2] := VSM;
    TAS[VMostrar, Tid]^.cant := 2;

    new(TAS[VMostrar, Tcad]);
    TAS[VMostrar, Tcad]^.elem[1] := Tcad;
    TAS[VMostrar, Tcad]^.elem[2] := VSM;
    TAS[VMostrar, Tcad]^.cant := 2;

    new(TAS[VMostrar, Tmenos]);
    TAS[VMostrar, Tmenos]^.elem[1] := VopArit;
    TAS[VMostrar, Tmenos]^.elem[2] := VSM;
    TAS[VMostrar, Tmenos]^.cant := 2;

    new(TAS[VMostrar, Tcreal]);
    TAS[VMostrar, Tcreal]^.elem[1] := VopArit;
    TAS[VMostrar, Tcreal]^.elem[2] := VSM;
    TAS[VMostrar, Tcreal]^.cant := 2;

    new(TAS[VMostrar, Tpot]);
    TAS[VMostrar, Tpot]^.elem[1] := VopArit;
    TAS[VMostrar, Tpot]^.elem[2] := VSM;
    TAS[VMostrar, Tpot]^.cant := 2;

    new(TAS[VMostrar, Troot]);
    TAS[VMostrar, Troot]^.elem[1] := VopArit;
    TAS[VMostrar, Troot]^.elem[2] := VSM;
    TAS[VMostrar, Troot]^.cant := 2;

    new(TAS[VMostrar, TParen_ab]);
    TAS[VMostrar, TParen_ab]^.elem[1] := VopArit;
    TAS[VMostrar, TParen_ab]^.elem[2] := VSM;
    TAS[VMostrar, TParen_ab]^.cant := 2;

    new(TAS[VSM, Tcoma]);
    TAS[VSM, Tcoma]^.elem[1] := Tcoma;
    TAS[VSM, Tcoma]^.elem[2] := VSM2;
    TAS[VSM, Tcoma]^.cant := 2;

    new(TAS[VSM, TParen_cer]);
    TAS[VSM, TParen_cer]^.cant := 0;

    new(TAS[VSM2, Tid]);
    TAS[VSM2, Tid]^.elem[1] := VopArit;
    TAS[VSM2, Tid]^.elem[2] := VSM;
    TAS[VSM2, Tid]^.cant := 2;

    new(TAS[VSM2, Tcad]);
    TAS[VSM2, Tcad]^.elem[1] := Tcad;
    TAS[VSM2, Tcad]^.elem[2] := VSM;
    TAS[VSM2, Tcad]^.cant := 2;

    new(TAS[VSM2, Tmenos]);
    TAS[VSM2, Tmenos]^.elem[1] := VopArit;
    TAS[VSM2, Tmenos]^.elem[2] :=   VSM;
    TAS[VSM2, Tmenos]^.cant := 2;

    new(TAS[VSM2, Tcreal]);
    TAS[VSM2, Tcreal]^.elem[1] := VopArit;
    TAS[VSM2, Tcreal]^.elem[2] := VSM;
    TAS[VSM2, Tcreal]^.cant := 2;

    new(TAS[VSM2, Tpot]);
    TAS[VSM2, Tpot]^.elem[1] := VopArit;
    TAS[VSM2, Tpot]^.elem[2] := VSM;
    TAS[VSM2, Tpot]^.cant := 2;

    new(TAS[VSM2, Troot]);
    TAS[VSM2, Troot]^.elem[1] := VopArit;
    TAS[VSM2, Troot]^.elem[2] := VSM;
    TAS[VSM2, Troot]^.cant := 2;

    new(TAS[VSM2, TParen_ab]);
    TAS[VSM2, TParen_ab]^.elem[1] := VopArit;
    TAS[VSM2, TParen_ab]^.elem[2] := VSM;
    TAS[VSM2, TParen_ab]^.cant := 2;

    new(TAS[VCiclo, Twhile]);
    TAS[VCiclo, Twhile]^.elem[1] := Twhile;
    TAS[VCiclo, Twhile]^.elem[2] := Vvalor_B;
    TAS[VCiclo, Twhile]^.elem[3] := TLlav_ab;
    TAS[VCiclo, Twhile]^.elem[4] := VCuerpo;
    TAS[VCiclo, Twhile]^.elem[5] := TLlav_cer;
    TAS[VCiclo, Twhile]^.cant := 5;

End;
Procedure Crear_Nodo (SG:tipoSG; Var apuntador:TApuntNodo);
Begin
    new(apuntador);
    apuntador^.simbolo := SG;
    apuntador^.lexema := '';
    apuntador^.hijos.cant := 0;
End;

Procedure AgregarHijo(Var raiz:TApuntNodo; Var hijo:TApuntNodo);
Begin
    If raiz^.hijos.cant < MaxProd Then
        Begin
            inc(raiz^.hijos.cant);
            raiz^.hijos.elem[raiz^.hijos.cant] := hijo;
        End;
End;

Procedure Analizador_Predictivo(rutaFuente:String;Var arbol:TApuntNodo; Var Error:Boolean);
Var
    Control:   Longint;
    TS:   TablaDeSimbolos;
    TAS:   TipoTAS;
    Pila:   TipoPila;
    Estado:   (enproceso, errorLexico, errorSintactico, Exito);
    EPila:   TipoElemPila;
    Fuente:   FileOfChar;
    CompLex:   TipoSG;
    Lexema:   String;
    i :   0..MaxProd;
    Auxiliar:   TipoSG;
    Aux2: TapuntNodo;
    car:char;
Begin

    assign(fuente,RutaFuente);
    {$i-}
         reset(fuente);
    {$i+}
    if IOresult<>0 then
        begin
        writeln('X');
        readkey;
        end;

    read(fuente,car);
    //asignar y abrir archivo !!!!
    InicializarTS(TS);
    //Cargar TS
    CompletarTS(TS);
    inicializarTas(TAS);
    //Inicializar TAS
    cargarTas(TAS);
    //Cargar TAS
    CREARPILA(Pila);
    //Inicializar Pila
    Crear_Nodo(VLenguaje, arbol);
    Epila.Simbolo := pesos;
    Epila.NodoArbol := Nil;
    Apilar(pila,Epila);
    //Apilar $
    Epila.Simbolo := VLenguaje;
    Epila.NodoArbol := arbol;
    Apilar(pila,Epila);
    //Apilar VLenguaje.arbol
    Control := 0;
    ObtenerSiguienteCompLex(Fuente,control,CompLex,Lexema,TS);
    //Llamar al siguiente componente lexico
    Estado := Enproceso;

    While (Estado=enproceso) Do
        Begin
            Desapilar(Pila, Epila);

            {If Epila.simbolo = pesos Then  //modifique el simbolo
                Begin
                    writeln('se alcanzo pesos');
                End;}

            If Epila.simbolo In [Tprogram..TRelacional] Then       //SI X es Terminal
                Begin
                    If Epila.simbolo = CompLex Then
                        Begin
                            Epila.NodoArbol^.lexema := lexema;
                            ObtenerSiguienteCompLex(Fuente,control,CompLex,Lexema,TS);
                        End
                    Else
                        Begin
                            Estado := errorSintactico;
                            writeln('ERROR SINTACTICO: Se esperaba ',CompLex, ' y se encontro ', Epila.simbolo);
                            writeln(control);
                            Error := true;
                        End;
                End;
            If Epila.simbolo In [VLenguaje..VCiclo]  Then                 //SI X es Variable
                Begin
                    If TAS[Epila.simbolo, CompLex] = Nil Then
                        Begin
                            Estado := errorSintactico;
                            writeln('ERROR SINTACTICO: Se esperaba ',CompLex, ' y se encontro ', Epila.simbolo);
                            writeln(control);
                            Error:=true;
                        End
                    Else
                        Begin
                            For I:=1 To TAS[Epila.simbolo, CompLex]^.cant Do
                                Begin

                                    Auxiliar := TAS[Epila.simbolo, CompLex]^.elem[i];

                                    Crear_Nodo(Auxiliar,aux2);
                                    //revisalo tani
                                    AgregarHijo(Epila.NodoArbol,aux2);
                                    // revisalo tani

                                End;
                            ////////Aca deberia apilarse las cosas///////////////////
                            ApilarTodos(TAS[Epila.simbolo, CompLex]^, Epila.NodoArbol,Pila);
                        End;
                End
            Else
                Begin

                    If (CompLex = pesos) And (Epila.simbolo=pesos) Then
                        Begin
                            estado := Exito;
                            Error := false;
                        End;
                End;
        End;

    Close(Fuente);
End;
Procedure GuardarNodo (var arch:text; var arbol:TApuntNodo; dezpl:string);
var
    i:byte;
begin
    writeln(arch,dezpl,arbol^.simbolo,' (',arbol^.lexema,')');
    for i:=1 to arbol^.hijos.cant do
         begin
             GuardarNodo(arch,arbol^.hijos.elem[i],dezpl+'  ');
         end;
end;

procedure GuardarArbol(Ruta:string; var arbol:TApuntNodo);
var
    Arch:text;
begin
   
    assign(Arch,ruta);
    Rewrite(Arch);
    GuardarNodo(arch,arbol,'');
    close(arch);
end;

End.

