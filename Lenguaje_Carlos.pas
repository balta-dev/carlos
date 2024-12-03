Program Lenguaje_Carlos;
{$codepage utf8}

Uses
crt, analizadorSintactico,Evaluador;
Var
    arbol:   TapuntNodo;
    error:   boolean;
    estado:   TEstado;
Begin
    Analizador_Predictivo('holaMundo.txt',arbol,error);
    If Not error Then
        Begin
            GuardarArbol('Arbol.txt',arbol);
            InicializarEst(estado);
            evalLenguaje(arbol,estado);
        End;
    readln;
End.

