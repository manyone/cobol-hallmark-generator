        >>SOURCE FIXED
        IDENTIFICATION DIVISION.
        PROGRAM-ID.    HALLMARK.
        AUTHOR.        SIMOTIME TECHNOLOGIES.
        *>
        ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      
           SELECT VARS-FILE
               ASSIGN TO "vars.dat"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FS-VARS.

               SELECT PLOT-FILE
               ASSIGN TO "plot.dat"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FS-VARS.
        DATA DIVISION.
       FILE SECTION.
       
       FD  VARs-file
              RECORD CONTAINS 80 CHARACTERS
              BLOCK CONTAINS 0 RECORDS
              RECORDING MODE IS F.

       01  VARS-RECORD.
           03 FILLER PIC X(80).
       FD  plot-file
              RECORD CONTAINS 1024 CHARACTERS
              BLOCK CONTAINS 0 RECORDS
              RECORDING MODE IS F.

       01  plot-rECORD.
           03 FILLER PIC X(1024).
        WORKING-STORAGE SECTION.
       01 EOF-FLAGS.
           03 FILLER PIC X(01) VALUE SPACE.
               88 NO-MORE-VARS VALUE 'Y'.
           03 FILLER PIC X(01) VALUE SPACE.
               88 NO-MORE-plot VALUE 'Y'.

       01  REF-DATA.
           03  VIMAX   PIC 99 VALUE 14.
           03  VJMAX   PIC 99 VALUE 7.
       01 WS-FS-VARS  PIC X(02).        
        *>****************************************************************
        *>   Data-structure for Title and Copyright...
        *>   ------------------------------------------------------------
        01 cntl-fields.
           03 cntl-var-name    pic x(16).
           03  cntl-var-count  pic 99.
        01  vars-rec.
           03  vars-var-name   pic x(16).
           03  vars-var-value  pic x(60).
           03  filler          pic x(04).

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
           03 CHOICE-NUMBER    PIC 9 OCCURS 14 times.

       01 REPL-COMPLETE PIC X VALUE 'n'.

       01 VAR-REPL-LEN PIC 99.
       01 VAR-REPL-VAL.
           03 VAR-REPL-CH PIC X OCCURS 60.
       01 VAR-srCH-LEN PIC 99.
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
           03 VJ  PIC 99.

           03 VSX PIC 99.
           03 VRX PIC 99.
       01 PLOT-COUNT PIC 99 VALUE 0.
       01  plot-rec.
           03 filler pic x(1024).

       01  STORY-TEXT PIC X(1024) VALUE "YOUR-GENERATED-STORY-HERE".
       01  STORY-LENGTH PIC 9(4) VALUE 1024.
       01  INDEX-POS PIC 9(4) VALUE 1.
       01  LINE-BUFFER PIC X(80).
       01  REMAINING-LEN PIC 9(4).
       01  COPY-LEN PIC 9(4).
       01  SPACE-POS PIC 9(4).
       01  DISP-LEN PIC 99 VALUE 80.

        
        *>COPY PASSSUB1.
        01  SUBSTITUTE-PARAMETERS.
           05  SUB-BUFFER-SOURCE    pic X(1024).
           05  SUB-BUFFER-TARGET    pic X(1024).
           05  SUB-SEARCH-STRING    pic X(128).
           05  SUB-REPLACE-STRING   pic X(128).
           05  SUB-SEARCH-LENGTH    pic 9(3).
           05  SUB-REPLACE-LENGTH   pic 9(3).
        
        *>****************************************************************
        PROCEDURE DIVISION.
           open input pLOT-FILE

           MOVE 0 TO PLOT-COUNT
           PERFORM READ-PLOT
           PERFORM UNTIL NO-MORE-PLOT
               IF PLOT-COUNT < 1
                   ADD 1 TO PLOT-COUNT
                   MOVE PLOT-RECORD TO PLOT-REC 
               END-IF
               PERFORM READ-PLOT
           END-PERFORM
           CLOSE PLOT-FILE

           open input VARS-FILE
           MOVE 0 TO VAR-NAME-COUNT
           perform read-vars
           perform  until no-more-vars
               move vars-var-name to cntl-var-name
               ADD 1 TO VAR-NAME-COUNT
               IF VAR-NAME-COUNT > vimax
                   DISPLAY 'TOO MANY VARS, MAX=' VIMAX
                   STOP run
               END-IF
               MOVE VAR-NAME-COUNT TO VI
               MOVE VARS-VAR-NAME TO VAR-NAME(VI)
               MOVE 0 TO VAR-VAL-COUNT(VI)
               perform until NO-MORE-VARS
               or cntl-var-name not = vars-var-name
                   ADD 1 TO VAR-VAL-COUNT(VI)
                   IF VAR-VAL-COUNT(VI) > vjmax
                       DISPLAY 'TOO MANY OPTIONS FOR VAR, MAX= ' VJMAX
                       STOP run
                   end-if
                   MOVE VAR-VAL-COUNT(VI) TO VJ
                   MOVE VARS-VAR-VALUE TO VAR-VAL (VI,VJ)

                    perform read-vars
               end-perform
      *        display 'I=' VI ' NAME=' VAR-NAME(VI)
      *        ' CNT=' VAR-VAL-COUNT(VI)
           end-perform
           close VARS-FILE
           PERFORM TEST after
           UNTIL NOT (PLAY-AGAIN-X NUMERIC AND PLAY-AGAIN = 1)
               PERFORM BUILD-STORY
               DISPLAY 'WOULD YOU LIKE TO CREATE ANOTHER STORY? (1=YES)'
               ACCEPT PLAY-AGAIN-X
           END-PERFORM
           GOBACK.
       BUILD-STORY.
           PERFORM VARYING VI FROM 1 BY +1 UNTIL VI > VAR-NAME-COUNT
               display ' '
              DISPLAY 'SELECT CHOICE FOR ' VAR-NAME (VI)
              PERFORM VARYING VJ FROM 1 BY +1 
              UNTIL VJ > VAR-VAL-COUNT(VI)
               DISPLAY VJ ' ' VAR-VAL (VI,VJ)
              END-PERFORM
              ACCEPT CHOICE-SELECT-X
              PERFORM UNTIL CHOICE-SELECT-X NUMERIC
              AND  NOT (CHOICE-SELECT < 1 
              OR CHOICE-SELECT > VAR-VAL-COUNT(VI))
                   DISPLAY 'IMVALID VALUE'
                   ACCEPT CHOICE-SELECT-X
              END-PERFORM
              MOVE CHOICE-SELECT TO CHOICE-NUMBER(VI)
              DISPLAY '---selected: ' VAR-VAL (VI,CHOICE-SELECT) 
           END-PERFORM
      *    DISPLAY 'CHOICES=' CHOICES-TABLE


           move 'N' to repl-complete
           MOVE PLOT-REC TO SUB-BUFFER-SOURCE

           perform replace-variables 
           display ' '
           DISPLAY 'HERE IS YOUR HALLMARK MOVIE!'
           display ' '
      *    display sub-buffer-target  
           MOVE SUB-BUFFER-TARGET TO STORY-TEXT
           PERFORM TEST AFTER
           UNTIL NOT (REDRAW-STORY-X NUMERIC AND (REDRAW-STORY = 1))
                  perform SHOW-MOVIE-PLOT
                  DISPLAY 'RE-DISPLAY? (1=YES)' 
                  ACCEPT REDRAW-STORY-X 
           END-PERFORM
           CONTINUE.
       replace-variables.
           PERFORM VARYING VI FROM 1 BY +1 UNTIL VI>VAR-NAME-COUNT
               MOVE VAR-NAME(VI)TO VAR-SRCH-VAL
               MOVE 0 TO VAR-srCH-LEN
               MOVE 16 TO VSX
               PERFORM 
               UNTIL VAR-SRCH-CH (VSX) NOT = ' '
               OR VSX < 1
                   SUBTRACT 1 FROM VSX

               end-perform
               move vsx to VAR-srch-LEN

               move choice-number (vi)  to VJ
               MOVE VAR-VAL(VI,VJ) TO VAR-REPL-VAL
               MOVE 0 TO VAR-REPL-LEN
               MOVE 60 TO VRX
               PERFORM 
               UNTIL VAR-REPL-CH (VRX) NOT = ' '
               OR VRX < 1
                   SUBTRACT 1 FROM VRX

               end-perform

               move vrx to VAR-REPL-LEN

      *        DISPLAY 
      *        'VAR-NAME=' VAR-NAME(VI)
      *         ' vsx=' vsx ' sL=' VAR-srch-LEN
      *         ' vrx=' vrx ' rL=' VAR-REPL-LEN
      *        ' RV='VAR-REPL-VAL

                  move VAR-NAME(VI) to SUB-SEARCH-STRING
                  move VAR-REPL-VAL to SUB-REPLACE-STRING
       
                  MOVE VAR-SRCH-LEN to SUB-SEARCH-LENGTH
                  move VAR-REPL-LEn to SUB-REPLACE-LENGTH
                  call 'SIMOSUB1' using SUBSTITUTE-PARAMETERS
                move sub-buffer-target to SUB-BUFFER-SOURCE
           END-PERFORM.



       READ-PLOT.
           READ PLOT-FILE AT END SET NO-MORE-PLOT TO TRUE
           END-READ
           CONTINUE.            
        read-vars.
           read vars-file into VARS-REC
           at end
               set no-more-vars to true
           end-read.

       SHOW-MOVIE-PLOT.
           MOVE 1 TO INDEX-POS
           PERFORM UNTIL INDEX-POS > STORY-LENGTH
               COMPUTE REMAINING-LEN = STORY-LENGTH - INDEX-POS + 1
               MOVE STORY-TEXT(INDEX-POS:DISP-LEN) TO LINE-BUFFER
               IF REMAINING-LEN > DISP-LEN
                   MOVE  DISP-LEN TO COPY-LEN
                   PERFORM FIND-SPACE-BACKWARDS
               ELSE
                   MOVE REMAINING-LEN TO COPY-LEN
               END-IF
               MOVE SPACES TO LINE-BUFFER
               MOVE STORY-TEXT(INDEX-POS:COPY-LEN) TO LINE-BUFFER
               DISPLAY LINE-BUFFER
               ADD COPY-LEN TO INDEX-POS

      *        SUBTRACT 1 FROM INDEX-POS
      *        PERFORM SKIP-TO-NEXT-WORD
           END-PERFORM
           CONTINUE.

       FIND-SPACE-BACKWARDS.
           MOVE  DISP-LEN TO SPACE-POS
           PERFORM UNTIL SPACE-POS < 1 OR LINE-BUFFER(SPACE-POS:1) = ' '
               SUBTRACT 1 FROM SPACE-POS
           END-PERFORM
           IF SPACE-POS > 1
               MOVE SPACE-POS TO COPY-LEN
           END-IF.

       SKIP-TO-NEXT-WORD.
           IF INDEX-POS < STORY-LENGTH AND
              STORY-TEXT(INDEX-POS:1) IS NOT EQUAL TO ' '
               ADD 1 TO INDEX-POS
           END-IF.

        END PROGRAM HALLMARK.
