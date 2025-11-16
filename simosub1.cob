        IDENTIFICATION DIVISION.
        PROGRAM-ID.    SIMOSUB1.
        *>AUTHOR.        SIMOTIME TECHNOLOGIES.
        *>
        ENVIRONMENT DIVISION.
        DATA DIVISION.
        *>****************************************************************
        WORKING-STORAGE SECTION.
        01  I-1            pic 9(5) value 0.
        01  I-2            pic 9(5) value 0.
        01  SUB-PTR        pic 9(5) value 0.
        
        01  SOURCE-SIZE    pic 9(5) value 0.
        01  TARGET-SIZE    pic 9(5) value 0.
        
        *>****************************************************************
        LINKAGE SECTION.
        *>COPY PASSSUB1.
        01  SUBSTITUTE-PARAMETERS.
           05  SUB-BUFFER-SOURCE    pic X(1024).
           05  SUB-BUFFER-TARGET    pic X(1024).
           05  SUB-SEARCH-STRING    pic X(128).
           05  SUB-REPLACE-STRING   pic X(128).
           05  SUB-SEARCH-LENGTH    pic 9(3).
           05  SUB-REPLACE-LENGTH   pic 9(3).
        
        
        *>****************************************************************
        PROCEDURE DIVISION using SUBSTITUTE-PARAMETERS.
        
           if  SUB-SEARCH-LENGTH = SUB-REPLACE-LENGTH
               move SUB-BUFFER-SOURCE to SUB-BUFFER-TARGET
               inspect SUB-BUFFER-TARGET replacing
                       all SUB-SEARCH-STRING(1:SUB-SEARCH-LENGTH)
                        by SUB-REPLACE-STRING(1:SUB-REPLACE-LENGTH)
           else
               perform INSPECT-AND-REPLACE-EXTENDED
           end-if
        
           GOBACK.
        
        *>****************************************************************
        INSPECT-AND-REPLACE-EXTENDED.
           add length of SUB-BUFFER-SOURCE to ZERO giving SOURCE-SIZE
           add length of SUB-BUFFER-TARGET to ZERO giving TARGET-SIZE
           add 1 to ZERO giving I-1
           add 1 to ZERO giving I-2
           perform until I-1 > SOURCE-SIZE - SUB-SEARCH-LENGTH
                      or I-2 > TARGET-SIZE - SUB-REPLACE-LENGTH

             if  SUB-BUFFER-SOURCE(I-1:1) not = SUB-SEARCH-STRING(1:1)
                 move SUB-BUFFER-SOURCE(I-1:1)
                   to SUB-BUFFER-TARGET(I-2:1)
                 add 1 to I-1
                 add 1 to I-2
             else
                 if  SUB-BUFFER-SOURCE(I-1:SUB-SEARCH-LENGTH)
                 not = SUB-SEARCH-STRING
                     move SUB-BUFFER-SOURCE(I-1:1)
                       to SUB-BUFFER-TARGET(I-2:1)
                     add 1 to I-1
                     add 1 to I-2
                 else
                     move SUB-REPLACE-STRING
                       to SUB-BUFFER-TARGET(I-2:SUB-REPLACE-LENGTH)
                     add SUB-SEARCH-LENGTH  to I-1
                     add SUB-REPLACE-LENGTH to I-2
                 end-if
             end-if
           end-perform
      *    display 'i1=' I-1 ' i2=' I-2 ' srcesize=' source-size
      *    ' targsize=' target-size ' srchlen=' sub-search-length
      *    ' repllen=' sub-replace-length
           exit.
        END PROGRAM SIMOSUB1.
