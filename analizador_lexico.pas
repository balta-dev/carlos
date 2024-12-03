
Unit analizador_Lexico;
 {$codepage utf8}


Interface

Uses
Classes, SysUtils;

Const
    MaxSim =   200;
    FinArch =   #0;

Type
    TipoSG =   (Tprogram,Tid,TCreal,Tcad,Twhile,Tif,Tdef,Ttitle,Tpycom,Tcoma,Tarray,Tmenos,Tmas,Tasig,Tnot,Tand,Tor,
                Tmultip,Tdiv,TParen_ab,TParen_cer,TCorr_ab,TCorr_cer,TLlav_ab,TLlav_cer,Tpot,Troot,Telse,Tread,Tprint,
                TRelacional,pesos,ErrorLexico,VLenguaje, VL_2, VL_3, VTitulo, VDefiniciones, VD_2, VD_3, VCuerpo, VC2,
                VSent, VAsig, VAsig_2, VAsig_3, VElem_V, VElem_V2, VopArit, VSOA, VOA2, VSOA2, VOA3, Varreglo, VPotencia
                , VNum_p, VCondi, VOtro, Vvalor_B, VSOL, VOL2, VSOL2, VOL3, VLeer, VImprimir, VMostrar, VSM, VSM2,
                VCiclo);
    FileOfChar =   file Of char;
    TElemTS =   Record
        compLex:   TipoSG;
        Lexema:   string;
    End;
    TablaDeSimbolos =   Record
        elem:   array[1..MaxSim] Of TElemTS;
        cant:   0..maxsim;
    End;
Procedure InicializarTS(Var TS:TablaDeSimbolos);
Procedure CompletarTS(Var TS:TablaDeSimbolos);
Procedure LeerCar(Var Fuente:FileOfChar;Var control:Longint; Var car:char);
Function EsId(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;
Function EsConstanteReal(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;
Function EsCadena(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;
Function EsSimboloEspecial(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String;Var CompLex:TipoSG):   Boolean;
Procedure ObtenerSiguienteCompLex(Var Fuente:FileOfChar;Var Control:Longint; Var CompLex:TipoSG;Var Lexema:String;Var TS
                                  :TablaDeSimbolos);


Implementation
Procedure InicializarTS(Var TS:TablaDeSimbolos);
//inicializador de tabla
Begin
    TS.cant := 0;
End;
Procedure CompletarTS(Var TS:TablaDeSimbolos);
//definicion de tabla
Begin
    // Colocar las palabras reservadas
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'while';
    TS.elem[TS.cant].compLex := Twhile;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'if';
    TS.elem[TS.cant].compLex := Tif;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'def';
    TS.elem[TS.cant].compLex := Tdef;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'program';
    TS.elem[TS.cant].compLex := Tprogram;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'title';
    TS.elem[TS.cant].compLex := Ttitle;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'read';
    TS.elem[TS.cant].compLex := Tread;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'print';
    TS.elem[TS.cant].compLex := Tprint;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'pot';
    TS.elem[TS.cant].compLex := Tpot;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'root';
    TS.elem[TS.cant].compLex := Troot;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'array';
    TS.elem[TS.cant].compLex := Tarray;
    Inc(TS.cant);
    TS.elem[TS.cant].lexema := 'else';
    TS.elem[TS.cant].compLex := Telse;
End;
Procedure InstalarEnTS(lexema:String; Var TS:TablaDeSimbolos; Var CompLex:TipoSG);

Var
    pre_ex:   boolean;
    i:   byte;
Begin
    pre_ex := False;
    For i:=1 To TS.cant Do
        Begin
            If lexema = TS.elem[i].lexema Then
                Begin
                    Complex := TS.elem[i].compLex;
                    pre_ex := True;
                End;
        End;
    If Not pre_ex Then
        Begin
            inc(TS.cant);
            TS.elem[TS.cant].lexema := lexema;
            TS.elem[TS.cant].compLex := Tid;
            CompLex := Tid;
        End;
End;

Procedure LeerCar(Var Fuente:FileOfChar;Var control:Longint; Var car:char);
Begin
    If control< filesize(Fuente) Then
        Begin
            seek(FUENTE,control);
            read(fuente,car);
        End
    Else
        Begin
            car := FinArch;
        End;
End;

Function EsId(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;

Const
    q0 =   0;
    F =   [2];

Type
    Q =   0..3;
    Sigma =   (L,D,O);
    TipoDelta =   array[Q,Sigma] Of Q;

Var
    E_actual:   Q;
    car:   char;
    delta:   TipoDelta;
    ContLocal:   Longint;
Function CarASimb(Car:Char):   Sigma;
Begin
    Case Car Of
        'a'..'z', 'A'..'Z':   CarASimb := L;
        '0'..'9'      :   CarASimb := D;
        Else
            CarASimb := o;
    End;
End;
Begin
    Lexema := '';
    ContLocal := Control;
    Delta[0,L] := 1;
    Delta[0,D] := 3;
    Delta[0,o] := 3;
    Delta[1,L] := 1;
    Delta[1,D] := 1;
    Delta[1,o] := 2;
    E_actual := q0;
    While (E_actual<>3) And (E_actual<>2) Do
        Begin
            LeerCar(Fuente,ContLocal,car);
            E_actual := delta[E_actual,CarASimb(car)];
            INC(ContLocal);
            If E_actual = 1 Then
                lexema := lexema+car;
        End;
    If E_actual In F Then
        Begin
            Esid := true;
            Control := (ContLocal-1);
            //+1 no estamos seguros;
        End
    Else
        Esid := false;
End;
Function EsConstanteReal(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;

Const
    q0 =   0;
    F =   [4];

Type
    Q =   0..5;
    Sigma =   (D,o,punto);
    TipoDelta =   array[Q,Sigma] Of Q;

Var
    E_actual:   Q;
    car:   char;
    delta:   TipoDelta;
    ContLocal:   Longint;
Function CarASimb(Car:Char):   Sigma;
Begin
    Case Car Of
        '0'..'9':   CarASimb := D;
        '.':   CarASimb := punto;
        Else
            CarASimb := o;
    End;
End;
Begin
    Lexema := '';
    ContLocal := Control;
    Delta[0,D] := 1;
    Delta[0,o] := 5;
    Delta[0,punto] := 5;
    Delta[1,D] := 1;
    Delta[1,o] := 4;
    Delta[1,punto] := 2;
    Delta[2,D] := 3;
    Delta[2,o] := 5;
    Delta[2,punto] := 5;
    Delta[3,D] := 3;
    Delta[3,o] := 4;
    Delta[3,punto] := 4;
    E_actual := q0;
    While (E_actual<>5) And (E_actual<>4) Do
        Begin
            LeerCar(Fuente,ContLocal,car);
            E_actual := delta[E_actual,CarASimb(car)];
            INC(ContLocal);
            If (E_actual<>4) Then
                lexema := lexema+car;
        End;
    If E_actual In F Then
        Begin
            EsConstanteReal := true;
            Control := (ContLocal-1);
        End
    Else
        EsConstanteReal := false;
End;
Function EsCadena(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String):   Boolean;

Const
    q0 =   0;
    F =   [2];

Type
    Q =   0..3;
    Sigma =   (C,o);
    TipoDelta =   array[Q,Sigma] Of Q;

Var
    E_actual:   Q;
    car:   char;
    delta:   TipoDelta;
    ContLocal:   Longint;
Function CarASimb(Car:Char):   Sigma;
Begin
    Case Car Of
        #39:   CarASimb := C;
        Else
            CarASimb := o;
    End;
End;
Begin
    Lexema := '';
    ContLocal := Control;
    Delta[0,C] := 1;
    Delta[0,o] := 3;
    Delta[1,C] := 2;
    Delta[1,o] := 1;
    E_actual := q0;
    While (E_actual<>3) And (E_actual<>2) Do
        Begin
            LeerCar(Fuente,ContLocal,car);
            E_actual := delta[E_actual,CarASimb(car)];
            INC(ContLocal);
            lexema := lexema+car;
        End;
    If E_actual In F Then
        Begin
            EsCadena := true;
            Control := (ContLocal);
            //+1 no estamos seguros;
        End
    Else
        EsCadena := false;
End;
Function EsSimboloEspecial(Var Fuente:FileOfChar;Var control:Longint;Var Lexema:String;Var CompLex:TipoSG):   Boolean;

Var
    car:   char;
Begin
    LeerCar(Fuente,control,car);
    lexema := car;
    INC(control);
    EsSimboloEspecial := true;
    Case car Of
        ';':   CompLex := Tpycom;
        //Algunos simbolos pueden ser palabras reservadas, asi que esto quizas deberia cambiarse
        ',':   CompLex := Tcoma;
        '(':   CompLex := TParen_ab;
        ')':   CompLex := TParen_cer;
        '[':   CompLex := TCorr_ab;
        ']':   CompLex := TCorr_cer;
        '{':   CompLex := TLlav_ab;
        '}':   CompLex := TLlav_cer;
        '=':
               Begin
                   CompLex := Tasig;
                   LeerCar(Fuente,control,car);
                   If car = '=' Then
                       Begin
                           lexema := '==';
                           Inc(control);
                           Complex := Trelacional;
                       End;
               End;
        '|':   CompLex := Tor;
        '&':   CompLex := Tand;
        '!':   CompLex := Tnot;
        '+':   CompLex := Tmas;
        '-':   CompLex := Tmenos;
        '*':   CompLex := Tmultip;
        '/':   CompLex := Tdiv;
        '<':
               Begin
                   CompLex := Trelacional;
                   LeerCar(Fuente,control,car);
                   If car = '=' Then
                       Begin
                           lexema := '<=';
                           Inc(control);
                       End
                   Else
                       If car = '>' Then
                           Begin
                               lexema := '<>';
                               Inc(control);
                           End
               End;
        '>':
               Begin
                   CompLex := Trelacional;
                   LeerCar(Fuente,control,car);
                   If car = '=' Then
                       Begin
                           lexema := '>=';
                           Inc(control);
                       End;
               End;
        Else
            DEC(control);
        EsSimboloEspecial := false
    End;

End;

Procedure ObtenerSiguienteCompLex(Var Fuente:FileOfChar;Var Control:Longint; Var CompLex:TipoSG;Var Lexema:String;Var TS
                                  :TablaDeSimbolos);

Var
    car:   char;
Begin
    Leercar(Fuente,control,car);
    While car In [#1..#32] Do
        Begin
            INC(control);
            Leercar(Fuente,control,car);
        End;
    If car=FinArch Then
        complex := pesos
    Else
        Begin
            If EsId(Fuente,Control,Lexema) Then
                InstalarEnTS(Lexema,TS,CompLex)
            Else If EsConstanteReal(Fuente,Control,Lexema) Then
                     CompLex := Tcreal
            Else If EsCadena(Fuente,Control,Lexema) Then
                     CompLex := Tcad
            Else If Not EsSimboloEspecial(Fuente,Control,Lexema,CompLex) Then
                     CompLex := ErrorLexico
        End;
End;
End.

