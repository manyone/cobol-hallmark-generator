//HERC02C  JOB (COB),
//             'ADVENT',
//             CLASS=A,
//             MSGCLASS=C,
//             REGION=0M,TIME=1440,
//             MSGLEVEL=(1,1)
//* ALSO INCLUDES COBGO STEP BELOW
//COBUCL  PROC CPARM1='LOAD,SUPMAP',                                   100010000
//             CPARM2='SIZE=2048K,BUF=1024K'                            00020000
//COB  EXEC  PGM=IKFCBL00,REGION=4096K,                                 00040001
//           PARM='&CPARM1,&CPARM2'                                     00050001
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR                                 00051001
//SYSPRINT  DD SYSOUT=*                                                 00060000
//SYSUT1 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00070000
//SYSUT2 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00080000
//SYSUT3 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00090000
//SYSUT4 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00100000
//SYSLIN DD DSN=&LOADSET,DISP=(MOD,PASS),UNIT=SYSDA,                    00110000
//             SPACE=(80,(500,100))                                     00120000
//LKED EXEC PGM=IEWL,PARM='LIST,XREF,LET',COND=(5,LT,COB),REGION=96K    00130000
//SYSLIN  DD DSN=&LOADSET,DISP=(OLD,DELETE)                             00140000
//  DD  DDNAME=SYSIN                                                    00150000
//SYSLMOD DD DISP=SHR,DSN=HERC02.RUN.LOAD(SIMOSUB2)                     00160000
//SYSLIB DD   DSN=SYSC.COBLIB,DISP=SHR                                  00170000
//SYSUT1 DD UNIT=SYSDA,SPACE=(1024,(50,20))                             00180000
//SYSPRINT DD SYSOUT=*                                                  00190000
// PEND
//STP1 EXEC COBUCL
//COB.SYSIN  DD *
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
//

//
//COBUCLG PROC CPARM1='LOAD,SUPMAP',                                   100010000
//             CPARM2='SIZE=2048K,BUF=1024K'                            00020000
//COB  EXEC  PGM=IKFCBL00,REGION=4096K,                                 00040001
//           PARM='&CPARM1,&CPARM2'                                     00050001
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR                                 00051001
//SYSPRINT  DD SYSOUT=*                                                 00060000
//SYSUT1 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00070000
//SYSUT2 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00080000
//SYSUT3 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00090000
//SYSUT4 DD UNIT=SYSDA,SPACE=(460,(700,100))                            00100000
//SYSLIN DD DSN=&LOADSET2,DISP=(MOD,PASS),UNIT=SYSDA,                   00110000
//             SPACE=(80,(500,100))                                     00120000
//LKED EXEC PGM=IEWL,PARM='LIST,XREF,LET',COND=(5,LT,COB),REGION=96K    00130000
//SYSLIN  DD DSN=&LOADSET2,DISP=(OLD,DELETE)                            00140000
//  DD  DDNAME=SYSIN                                                    00150000
//LUHNINCL DD DISP=SHR,DSN=HERC02.RUN.LOAD                              00160000
//SYSLMOD DD DSN=&GODATA(RUN),DISP=(NEW,PASS),UNIT=SYSDA,               00160000
//             SPACE=(1024,(50,20,1))                                   00170000
//SYSLIB DD   DSN=SYSC.COBLIB,DISP=SHR                                  00180000
//SYSUT1 DD UNIT=SYSDA,SPACE=(1024,(50,20))                             00190000
//SYSPRINT DD SYSOUT=*                                                  00200000
//GO  EXEC PGM=*.LKED.SYSLMOD,COND=((5,LT,COB),(5,LT,LKED))             00210000
//SYSOUT  DD SYSOUT=*
//STEPLIB DD DISP=SHR,DSN=&GODATA
// DD DISP=SHR,DSN=HERC02.RUN.LOAD
// PEND
//STP2 EXEC COBUCLG
//COB.SYSIN DD *
100001 IDENTIFICATION DIVISION.
100002 PROGRAM-ID.  LUHNTEST.
100003 ENVIRONMENT DIVISION.
100004 INPUT-OUTPUT SECTION.
100005 DATA DIVISION.
100006 WORKING-STORAGE SECTION.
100007 01  INP-CARD.
100008   03  INP-CARD-CH      PIC X(01) OCCURS 20 TIMES.
100009 01  WS-RESULT          PIC 9(01).
100010   88  PASS-LUHN-TEST             VALUE 0.
100011
100012 PROCEDURE DIVISION.
100013     MOVE '49927398716'       TO INP-CARD
100014     PERFORM TEST-CARD
100015     MOVE '49927398717'       TO INP-CARD
100016     PERFORM TEST-CARD
100017     MOVE '1234567812345678'  TO INP-CARD
100018     PERFORM TEST-CARD
100019     MOVE '1234567812345670'  TO INP-CARD
100020     PERFORM TEST-CARD
100021     STOP RUN
100022     .
100023 TEST-CARD.
100024     CALL 'LUHN' USING INP-CARD, WS-RESULT
100025     IF PASS-LUHN-TEST
100026       DISPLAY 'INPUT=' INP-CARD 'PASS'
100027     ELSE
100028       DISPLAY 'INPUT=' INP-CARD 'FAIL'
100029     .
//LKED.SYSLIN  DD DSN=&LOADSET2,DISP=(OLD,DELETE)                       00140000
//  DD  DDNAME=SYSIN                                                    00150000
//LKED.SYSIN DD *
  INCLUDE LUHNINCL(LUHN)
