IDENTIFICATION DIVISION.
       PROGRAM-ID. MATRIX-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MATRIX.
          05 ROW OCCURS 3 TIMES.
             10 COL OCCURS 3 TIMES PIC 9(2).

       01 I PIC 9 VALUE 1.
       01 J PIC 9 VALUE 1.

       PROCEDURE DIVISION.
           DISPLAY "COBOL Matrix Artifact - Extended".
           MOVE 01 TO COL (1,1).
           MOVE 02 TO COL (1,2).
           MOVE 03 TO COL (1,3).
           MOVE 04 TO COL (2,1).
           MOVE 05 TO COL (2,2).
           MOVE 06 TO COL (2,3).
           MOVE 07 TO COL (3,1).
           MOVE 08 TO COL (3,2).
           MOVE 09 TO COL (3,3).

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 3
              PERFORM VARYING J FROM 1 BY 1 UNTIL J > 3
                 DISPLAY "MATRIX(" I "," J ") = " COL (I,J)
              END-PERFORM
           END-PERFORM.

           STOP RUN.
