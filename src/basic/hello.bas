' hello.bas
' FreeBASIC demo for Edge-AI-APP workflow
' Versão compatível com libtinfo.so.6

DECLARE FUNCTION Tangente(x AS DOUBLE) AS DOUBLE
DECLARE FUNCTION Cotangente(x AS DOUBLE) AS DOUBLE

PRINT "Quantum AGI initialized via FreeBASIC"
PRINT "Hello from Edge-AI-APP workflow!"
PRINT "This confirms FreeBASIC integration is working with libtinfo.so.6"

DIM x AS DOUBLE
INPUT "Enter x (decimal): ", x

PRINT "Input x = "; x
PRINT "tan(x) ≈ "; Tangente(x)
PRINT "cot(x) ≈ "; Cotangente(x)

FUNCTION Tangente(x AS DOUBLE) AS DOUBLE
    ' Aproximação simples: tan(x) ≈ x + x^3/3
    RETURN x + (x^3)/3
END FUNCTION

FUNCTION Cotangente(x AS DOUBLE) AS DOUBLE
    DIM t AS DOUBLE
    t = Tangente(x)
    IF t <> 0 THEN
        RETURN 1 / t
    ELSE
        RETURN 0
    END IF
END FUNCTION
