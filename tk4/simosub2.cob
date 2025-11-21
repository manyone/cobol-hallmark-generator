        IDENTIFICATION DIVISION.
        PROGRAM-ID.    SIMOSUB2.
        AUTHOR.        SIMOTIME TECHNOLOGIES.
        11/12/2025 ADAPED FROM SIMOSUBC1 AND MODIFIED
        BY MANNY JUANN SO IT COMPILES IN COBOL74
        ENVIRONMENT DIVISION.
        DATA DIVISION.
      *
        WORKING-STORAGE SECTION.
        01 BUF-LEN PIC 9(4) VALUE 1024.
        01  I-1            PIC 9(5) VALUE 0.
        01  I-2            PIC 9(5) VALUE 0.
        01  SUB-PTR        PIC 9(5) VALUE 0.

        01  SOURCE-SIZE    PIC 9(5) VALUE 0.
        01  TARGET-SIZE    PIC 9(5) VALUE 0.
        01 SRX     PIC 9(4).
        01 WIX     PIC 9(4).
        01 WRK-SRCH-STRING.
           03  WRK-SRCH-CH PIC X OCCURS 128.
      ****************************************************************
        LINKAGE SECTION.
      **COPY PASSSUB1.
        01  SUBSTITUTE-PARAMETERS.
           05  SUB-BUFFER-SOURCE    PIC X(1024).
           05 FILLER REDEFINES SUB-BUFFER-SOURCE.
                07  SUB-BUF-SRCE-CH    PIC X OCCURS 1024.
           05  SUB-BUFFER-TARGET    PIC X(1024).
           05 FILLER REDEFINES SUB-BUFFER-TARGET.
               07  SUB-BUF-TARG-CH    PIC X OCCURS 1024.
           05  SUB-SEARCH-STRING    PIC X(128).
           05 FILLER REDEFINES , SUB-SEARCH-STRING.
                07  SUB-SRCH-CH    PIC X OCCURS 128.
           05  SUB-REPLACE-STRING   PIC X(128).
           05 FILLER REDEFINES SUB-REPLACE-STRING.
                07  SUB-REPL-CH    PIC X OCCURS 128.
           05  SUB-SEARCH-LENGTH    PIC 9(3).
           05  SUB-REPLACE-LENGTH   PIC 9(3).


      ****************************************************************
        PROCEDURE DIVISION USING SUBSTITUTE-PARAMETERS.

           PERFORM INSPECT-AND-REPLACE-EXTENDED.


           GOBACK.

      ****************************************************************
        INSPECT-AND-REPLACE-EXTENDED.
           MOVE BUF-LEN TO SOURCE-SIZE.
           MOVE BUF-LEN TO TARGET-SIZE.
           ADD 1 TO ZERO GIVING I-1.
           ADD 1 TO ZERO GIVING I-2.
           PERFORM SRCH-AND-REPL
               UNTIL I-1 > SOURCE-SIZE - SUB-SEARCH-LENGTH
                      OR I-2 > TARGET-SIZE - SUB-REPLACE-LENGTH.

      *    DISPLAY 'I1=' I-1 ' I2=' I-2 ' SRCESIZE=' SOURCE-SIZE
      *    ' TARGSIZE=' TARGET-SIZE ' SRCHLEN=' SUB-SEARCH-LENGTH
      *    ' REPLLEN=' SUB-REPLACE-LENGTH

       SRCH-AND-REPL.
             IF  SUB-BUF-SRCE-CH(I-1) NOT = SUB-SRCH-CH(1)
               MOVE SUB-BUF-SRCE-CH (I-1) TO SUB-BUF-TARG-CH(I-2)

                 ADD 1 TO I-1
                 ADD 1 TO I-2
             ELSE
                   MOVE 1 TO SRX
                   MOVE I-1 TO WIX
                   MOVE SPACES TO WRK-SRCH-STRING
                  PERFORM GET-SRCH-STRING
                   UNTIL SRX > SUB-SEARCH-LENGTH

                 IF  WRK-SRCH-STRING
                 NOT = SUB-SEARCH-STRING
                     MOVE SUB-BUF-SRCE-CH (I-1) TO SUB-BUF-TARG-CH(I-2)

                     ADD 1 TO I-1
                     ADD 1 TO I-2
                 ELSE
                   MOVE 1 TO SRX
                   MOVE I-2 TO WIX
                   PERFORM    APPLY-REPL-TO-TARG
                       UNTIL SRX> SUB-REPLACE-LENGTH

                   ADD SUB-SEARCH-LENGTH  TO I-1
                   ADD SUB-REPLACE-LENGTH TO I-2.

        GET-SRCH-STRING.
            MOVE SUB-BUF-SRCE-CH(WIX) TO WRK-SRCH-CH(SRX).
             ADD 1 TO SRX.
            ADD 1 TO WIX.
       APPLY-REPL-TO-TARG.
           MOVE SUB-REPL-CH(SRX) TO SUB-BUF-TARG-CH(WIX).
           ADD 1 TO SRX.
           ADD 1 TO WIX.
