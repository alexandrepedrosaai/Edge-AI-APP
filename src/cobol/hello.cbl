       IDENTIFICATION DIVISION.
       PROGRAM-ID. MATRIX-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MATRIX-DATA.
          05 ROW-ITEM OCCURS 3 TIMES.
             10 COL-ITEM OCCURS 3 TIMES PIC 9(2).

       01 I PIC 9 VALUE 1.
       01 J PIC 9 VALUE 1.

       PROCEDURE DIVISION.
           DISPLAY "COBOL Matrix Artifact - Extended".
           MOVE 01 TO COL-ITEM (1, 1).
           MOVE 02 TO COL-ITEM (1, 2).
           MOVE 03 TO COL-ITEM (1, 3).
           MOVE 04 TO COL-ITEM (2, 1).
           MOVE 05 TO COL-ITEM (2, 2).
           MOVE 06 TO COL-ITEM (2, 3).
           MOVE 07 TO COL-ITEM (3, 1).
           MOVE 08 TO COL-ITEM (3, 2).
           MOVE 09 TO COL-ITEM (3, 3).

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 3
              PERFORM VARYING J FROM 1 BY 1 UNTIL J > 3
                 DISPLAY "MATRIX(" I "," J ") = " COL-ITEM (I, J)
              END-PERFORM
           END-PERFORM.

           STOP RUN.
