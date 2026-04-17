REM BASIC Matrix Artifact - Extended

DIM Matrix(3, 3) AS INTEGER
DIM i AS INTEGER, j AS INTEGER

PRINT "BASIC Matrix Artifact - Extended"

' Preenche a matriz
Matrix(1,1) = 1: Matrix(1,2) = 2: Matrix(1,3) = 3
Matrix(2,1) = 4: Matrix(2,2) = 5: Matrix(2,3) = 6
Matrix(3,1) = 7: Matrix(3,2) = 8: Matrix(3,3) = 9

' Exibe os valores
FOR i = 1 TO 3
    FOR j = 1 TO 3
        PRINT "Matrix("; i; ","; j; ") = "; Matrix(i,j)
    NEXT j
NEXT i
