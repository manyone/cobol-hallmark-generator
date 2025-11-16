//HERC02C  JOB (COB),
//             'HALLMARK',
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
//SYSLMOD DD DISP=SHR,DSN=HERC02.RUN.LOAD(HALLMARK)                     00160000
//SYSLIB DD   DSN=SYSC.COBLIB,DISP=SHR                                  00170000
//SYSUT1 DD UNIT=SYSDA,SPACE=(1024,(50,20))                             00180000
//SYSPRINT DD SYSOUT=*                                                  00190000
// PEND
//STP1 EXEC COBUCL
//COB.SYSIN  DD *
        IDENTIFICATION DIVISION.
        PROGRAM-ID.    HALLMARK.
        AUTHOR.        MANNY JUAN.
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT VARS-FILE
               ASSIGN TO UT-S-VARS
               ACCESS MODE IS SEQUENTIAL.

               SELECT PLOT-FILE
               ASSIGN TO UT-S-PLOT
               ACCESS MODE IS SEQUENTIAL.
        DATA DIVISION.
       FILE SECTION.

       FD  VARS-FILE
              RECORD CONTAINS 80 CHARACTERS
              BLOCK CONTAINS 0 RECORDS
              RECORDING MODE IS F.

       01  VARS-RECORD.
           03 FILLER PIC X(80).
       FD  PLOT-FILE
              RECORD CONTAINS 1024 CHARACTERS
              BLOCK CONTAINS 0 RECORDS
              RECORDING MODE IS F.

       01  PLOT-RECORD.
           03 FILLER PIC X(1024).
        WORKING-STORAGE SECTION.
       01 EOF-FLAGS.
           03  NO-MORE-VARS-FLAG PIC X(01) VALUE SPACE.
               88 NO-MORE-VARS VALUE 'Y'.
           03 NO-MORE-PLOT-FLAG PIC X(01) VALUE SPACE.
               88 NO-MORE-PLOT VALUE 'Y'.

       01  REF-DATA.
           03  VIMAX   PIC 99 VALUE 14.
           03  VJMAX   PIC 9 VALUE 7.
       01 WS-FS-VARS  PIC X(02).
       01 WS-FS-PLOT  PIC X(02).
        01 CNTL-FIELDS.
           03 CNTL-VAR-NAME    PIC X(16).
           03  CNTL-VAR-COUNT  PIC 99.
        01  VARS-REC.
           03  VARS-VAR-NAME   PIC X(16).
           03  VARS-VAR-VALUE  PIC X(60).
           03  FILLER          PIC X(04).
       01  CHOICE-SELECT-X PIC X.
       01  FILLER REDEFINES CHOICE-SELECT-X.
          03  CHOICE-SELECT PIC 9.

       01  PLAY-AGAIN-X PIC X.
       01  FILLER REDEFINES PLAY-AGAIN-X.
          03  PLAY-AGAIN PIC 9.

       01  REDRAW-STORY-X PIC X.
       01  FILLER REDEFINES REDRAW-STORY-X.
          03  REDRAW-STORY PIC 9.

        01 CHOICES-TABLE.
           03 CHOICE-NUMBER    PIC 9 OCCURS 14 TIMES.

       01 REPL-COMPLETE PIC X VALUE 'N'.

       01 VAR-REPL-LEN PIC 99.
       01 VAR-REPL-VAL.
           03 VAR-REPL-CH PIC X OCCURS 60.
       01 VAR-SRCH-LEN PIC 99.
       01 VAR-SRCH-VAL.
           03 VAR-SRCH-CH PIC X OCCURS 16.
        01 VAR-TABLE-AREA.
           03  VAR-GRID.
               05 VAR-NAME-COUNT                PIC 99.
               05 VAR-SET OCCURS 14 TIMES.
                   07 VAR-NAME             PIC X(16).
                   07  VAR-VAL-COUNT     PIC 99.
                   07  VAR-VAL             PIC X(60) OCCURS 7 TIMES.

       01  VAR-INDICES.
           03 VI PIC 99.
           03 VJ  PIC 9.

           03 VSX PIC 99.
           03 VRX PIC 99.
       01  PLOT-COUNT PIC 99 VALUE 0.
       01  PLOT-REC.
           03 FILLER PIC X(1024).

       01  STORY-TEXT PIC X(1024) VALUE 'YOUR-GENERATED-STORY-HERE'.
       01  FILLER REDEFINES STORY-TEXT.
           03  STRY-CH PIC X OCCURS 1024.
       01  STORY-LENGTH PIC 9(4) VALUE 1024.
       01  INDEX-POS PIC 9(4) VALUE 1.
       01  LINE-BUFFER PIC X(80).
       01  FILLLER REDEFINES LINE-BUFFER.
           03  LBUF-CH PIC X OCCURS 80.
       01  REMAINING-LEN PIC 9(4).
       01  COPY-LEN PIC 9(4).
       01  SPACE-POS PIC 9(4).
       01  DISP-LEN PIC 99 VALUE 80.
       01  CCX      PIC 9999.
       01  LCX      PIC 9999.


      *  COPY PASSSUB1.
        01  SUBSTITUTE-PARAMETERS.
           05  SUB-BUFFER-SOURCE    PIC X(1024).
           05  SUB-BUFFER-TARGET    PIC X(1024).
           05  SUB-SEARCH-STRING    PIC X(128).
           05  SUB-REPLACE-STRING   PIC X(128).
           05  SUB-SEARCH-LENGTH    PIC 9(3).
           05  SUB-REPLACE-LENGTH   PIC 9(3).

        PROCEDURE DIVISION.
           OPEN INPUT PLOT-FILE.

           MOVE 0 TO PLOT-COUNT.
           PERFORM READ-PLOT.
           PERFORM PROCESS-PLOT UNTIL NO-MORE-PLOT.

           CLOSE PLOT-FILE.

           OPEN INPUT VARS-FILE.
           MOVE 0 TO VAR-NAME-COUNT.
           PERFORM READ-VARS.
           PERFORM  BUILD-VARS-TABLE UNTIL NO-MORE-VARS.
           CLOSE VARS-FILE.


           PERFORM BUILD-STORY.
           DISPLAY 'WOULD YOU LIKE TO CREATE ANOTHER STORY? (1=YES)'
           ACCEPT PLAY-AGAIN-X.
           PERFORM  CHECK-PLAY-AGAIN
             UNTIL NOT (PLAY-AGAIN-X NUMERIC AND PLAY-AGAIN = 1).
           DISPLAY 'THANKS FOR PLAYING'.
           GOBACK.
       CHECK-PLAY-AGAIN.
           PERFORM BUILD-STORY
           DISPLAY 'WOULD YOU LIKE TO CREATE ANOTHER STORY? (1=YES)'
           ACCEPT PLAY-AGAIN-X.
       BUILD-STORY.
           PERFORM SHOW-NEXT-VAR VARYING VI FROM 1 BY +1
           UNTIL VI > VAR-NAME-COUNT.

      *    DISPLAY 'CHOICES=' CHOICES-TABLE


           MOVE PLOT-REC TO SUB-BUFFER-SOURCE.

           PERFORM REPLACE-VARIABLES .
           DISPLAY ' '.
           DISPLAY 'HERE IS YOUR HALLMARK MOVIE!'.
           DISPLAY ' '.
      *    DISPLAY SUB-BUFFER-TARGET .

           MOVE SUB-BUFFER-TARGET TO STORY-TEXT.
           PERFORM SHOW-MOVIE-PLOT.
           DISPLAY 'RE-DISPLAY? (1=YES)'.
           ACCEPT REDRAW-STORY-X.
           PERFORM RE-DISPLAY
           UNTIL NOT(REDRAW-STORY-X NUMERIC AND REDRAW-STORY = 1).

       RE-DISPLAY.
           PERFORM SHOW-MOVIE-PLOT.
           DISPLAY 'RE-DISPLAY? (1=YES)'.
           ACCEPT REDRAW-STORY-X.
       PROCESS-PLOT.
             IF PLOT-COUNT < 1
                   ADD 1 TO PLOT-COUNT
                   MOVE PLOT-RECORD TO PLOT-REC
           ELSE
               PERFORM READ-PLOT.
        BUILD-VARS-TABLE.
               MOVE VARS-VAR-NAME TO CNTL-VAR-NAME
               ADD 1 TO VAR-NAME-COUNT
               IF VAR-NAME-COUNT > VIMAX
                   DISPLAY 'TOO MANY VARS, MAX=' VIMAX
                   STOP RUN.

               MOVE VAR-NAME-COUNT TO VI.
               MOVE VARS-VAR-NAME TO VAR-NAME(VI).
               MOVE 0 TO VAR-VAL-COUNT(VI).
               PERFORM LOAD-VARS-OPTS
                   UNTIL NO-MORE-VARS
                    OR CNTL-VAR-NAME NOT = VARS-VAR-NAME.


      *        DISPLAY 'I=' VI ' NAME=' VAR-NAME(VI)
      *        ' CNT=' VAR-VAL-COUNT(VI)

       LOAD-VARS-OPTS.
           ADD 1 TO VAR-VAL-COUNT(VI).
            IF VAR-VAL-COUNT(VI) > VJMAX
               DISPLAY 'TOO MANY OPTIONS FOR VAR, MAX= ' VJMAX
                STOP RUN.

            MOVE VAR-VAL-COUNT(VI) TO VJ.
            MOVE VARS-VAR-VALUE TO VAR-VAL (VI,VJ).
            PERFORM READ-VARS.
       SHOW-NEXT-VAR.
             DISPLAY ' '.
            DISPLAY 'SELECT CHOICE FOR ' VAR-NAME (VI).
           PERFORM SHOW-NEXT-OPTION VARYING VJ FROM 1 BY +1
            UNTIL VJ > VAR-VAL-COUNT(VI).

              ACCEPT CHOICE-SELECT-X.
              PERFORM GET-CHOICE
              UNTIL CHOICE-SELECT-X NUMERIC AND
                         NOT (CHOICE-SELECT < 1
                OR CHOICE-SELECT > VAR-VAL-COUNT(VI)).

              MOVE CHOICE-SELECT TO CHOICE-NUMBER(VI).
      *       DISPLAY '---SELECTED: ' VAR-VAL (VI,CHOICE-SELECT).
       SHOW-NEXT-OPTION.
            DISPLAY VJ ' ' VAR-VAL (VI,VJ).
       GET-CHOICE.
            DISPLAY 'IMVALID VALUE'.
            DISPLAY 'SELECT CHOICE FOR ' VAR-NAME (VI).
           PERFORM SHOW-NEXT-OPTION VARYING VJ FROM 1 BY +1
            UNTIL VJ > VAR-VAL-COUNT(VI).

          ACCEPT CHOICE-SELECT-X
       REPLACE-VARIABLES.
           PERFORM REPLACE-VARIABLE
           VARYING VI FROM 1 BY +1 UNTIL VI>VAR-NAME-COUNT.
       REPLACE-VARIABLE.
               MOVE VAR-NAME(VI)TO VAR-SRCH-VAL.
               MOVE 0 TO VAR-SRCH-LEN.
               MOVE 16 TO VSX.
               PERFORM BACKSP-VSX
                    UNTIL VAR-SRCH-CH (VSX) NOT = ' '
                     OR VSX < 1.

               MOVE VSX TO VAR-SRCH-LEN

               MOVE CHOICE-NUMBER (VI)  TO VJ.
               MOVE VAR-VAL(VI,VJ) TO VAR-REPL-VAL.
               MOVE 0 TO VAR-REPL-LEN.
               MOVE 60 TO VRX.
               PERFORM BACKSP-VRX
                    UNTIL VAR-REPL-CH (VRX) NOT = ' '
                    OR VRX < 1.
               MOVE VRX TO VAR-REPL-LEN.

      *        DISPLAY
      *        'VAR-NAME=' VAR-NAME(VI)
      *         ' VSX=' VSX ' SL=' VAR-SRCH-LEN
      *         ' VRX=' VRX ' RL=' VAR-REPL-LEN
      *        ' RV='VAR-REPL-VAL

            MOVE VAR-NAME(VI) TO SUB-SEARCH-STRING.
           MOVE VAR-REPL-VAL TO SUB-REPLACE-STRING.

             MOVE VAR-SRCH-LEN TO SUB-SEARCH-LENGTH.
             MOVE VAR-REPL-LEN TO SUB-REPLACE-LENGTH.
             CALL 'SIMOSUB2' USING SUBSTITUTE-PARAMETERS.
            MOVE SUB-BUFFER-TARGET TO SUB-BUFFER-SOURCE.

       BACKSP-VSX.
           SUBTRACT 1 FROM VSX.
       BACKSP-VRX.
           SUBTRACT 1 FROM VRX.
       READ-PLOT.
           READ PLOT-FILE
           AT END
               MOVE 'Y' TO NO-MORE-PLOT-FLAG.

        READ-VARS.
           READ VARS-FILE INTO VARS-REC
           AT END
               MOVE 'Y' TO NO-MORE-VARS-FLAG.

       SHOW-MOVIE-PLOT.
           MOVE 1 TO INDEX-POS.
           PERFORM WORD-WRAP UNTIL INDEX-POS > STORY-LENGTH.

       WORD-WRAP.
           COMPUTE REMAINING-LEN = STORY-LENGTH - INDEX-POS + 1.
           MOVE 1 TO LCX
           MOVE INDEX-POS TO CCX
           PERFORM STORY-TO-LINE UNTIL LCX > DISP-LEN
           IF REMAINING-LEN > DISP-LEN
               MOVE  DISP-LEN TO COPY-LEN
               PERFORM FIND-SPACE-BACKWARDS
           ELSE
               MOVE REMAINING-LEN TO COPY-LEN.
           MOVE SPACES TO LINE-BUFFER.
           MOVE 1 TO LCX.
           MOVE INDEX-POS TO CCX.
           PERFORM STORY-TO-LINE UNTIL LCX > COPY-LEN.
           DISPLAY LINE-BUFFER.
           ADD COPY-LEN TO INDEX-POS.
       STORY-TO-LINE.
           MOVE STRY-CH (CCX) TO LBUF-CH (LCX).
           ADD 1 TO LCX.
           ADD 1 TO CCX.

       FIND-SPACE-BACKWARDS.
           MOVE  DISP-LEN TO SPACE-POS
           PERFORM BACK-SPACE
           UNTIL SPACE-POS < 1 OR LBUF-CH(SPACE-POS)  = ' '.

           IF SPACE-POS > 1
               MOVE SPACE-POS TO COPY-LEN.

       BACK-SPACE.
           SUBTRACT 1 FROM SPACE-POS.
       SKIP-TO-NEXT-WORD.
           IF INDEX-POS < STORY-LENGTH AND
              STRY-CH(INDEX-POS) IS NOT EQUAL TO ' '
               ADD 1 TO INDEX-POS
           ELSE
              NEXT SENTENCE.
//LKED.SYSIN DD *
  INCLUDE SYSLMOD(SIMOSUB2)
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
